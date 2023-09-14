local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug

local Utils = KVS.Utils
local Config = KVS.Config

local Main = Main
-- ==================================================
-- Typo in the function name exposed to BG3SE by the game executable - Assigning it to a local to avoid confusing myself later
local RemoveCustomVisualOverride = Osi.RemoveCustomVisualOvirride
-- ==================================================
local CONFIG_KEY_USED_VISUALS = "UsedVisualsByCharacter"
-- ==================================================


local function GetVisualsUsed()
    local usedVisualsByCharacter = Config.GetValue(CONFIG_KEY_USED_VISUALS)
    if not usedVisualsByCharacter then
        usedVisualsByCharacter = {}
    end
    return usedVisualsByCharacter
end

local function GetVisualsUsedForCharacter(character_uuid, usedVisuals_allCharacters)
    Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")
    local usedVisuals_allCharacters = usedVisuals_allCharacters or GetVisualsUsed()

    local thisChar_usedVisuals = usedVisuals_allCharacters[character_uuid]
    if not thisChar_usedVisuals then
        thisChar_usedVisuals = {}
        usedVisuals_allCharacters[character_uuid] = thisChar_usedVisuals
    end
    return thisChar_usedVisuals

end

local function RecordUsedVisual(visual_uuid, character_uuid)
    local usedVisuals_allCharacters = GetVisualsUsed()
    local usedVisuals_thisCharacter = GetVisualsUsedForCharacter(character_uuid, usedVisuals_allCharacters)
    usedVisuals_thisCharacter[visual_uuid] = true
    Config.SetValue(CONFIG_KEY_USED_VISUALS, usedVisuals_allCharacters)
end

local function UnRecordUsedVisual(visual_uuid, character_uuid)
    local usedVisuals_allCharacters = GetVisualsUsed()
    local usedVisuals_thisCharacter = GetVisualsUsedForCharacter(character_uuid, usedVisuals_allCharacters)
    usedVisuals_thisCharacter[visual_uuid] = nil
    Config.SetValue(CONFIG_KEY_USED_VISUALS, usedVisuals_allCharacters)
end


function AddVisual(visual_uuid, character_uuid)
    Utils.assertIsStr(visual_uuid, "Invalid visual UUID specified - Must be a valid UUID string")
    character_uuid = character_uuid or GetHostCharacter()
    Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")

    -- Keep a record of which UUIDs have been applied to a character at any time
    -- TODO: Move this to PersistentVars so that it's in-sync with the game state upon saving
    RecordUsedVisual(visual_uuid, character_uuid)

    Osi.AddCustomVisualOverride(character_uuid, visual_uuid)
end
Main.AddVisual = AddVisual


function RemoveVisual(visual_uuid, character_uuid)
    Utils.assertIsStr(visual_uuid, "Invalid visual UUID specified - Must be a valid UUID string")
    character_uuid = character_uuid or GetHostCharacter()
    Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")

    RemoveCustomVisualOverride(character_uuid, visual_uuid)
end
Main.RemoveVisual = RemoveVisual

function RemoveAllUsedVisualsForCharacter(character_uuid, unrecord)
    character_uuid = character_uuid or GetHostCharacter()
    Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")

    local visualsUsed = GetVisualsUsedForCharacter(character_uuid, usedVisualsByCharacter)

    for visual_uuid in pairs(visualsUsed) do
        RemoveCustomVisualOverride(character_uuid, visual_uuid)
        if unrecord then
            UnRecordUsedVisual(visual_uuid, character_uuid)
        end
    end
end