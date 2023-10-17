local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug

local Utils = KVS.Utils
local Config = KVS.Config
local Persist = KVS.Persist
local KVS_Entity = KVS.Entity

local Main = Main
local State = State
local Constants = Constants

-- ==================================================
-- ==================================================

---@param change_data table
---@param character_uuid UUID Character to affect
---@param ignore_incompatibility boolean If true, warnings about visual incompatibility are NOT shown
---@return boolean
local function _Record( change_data, character_uuid, ignore_incompatibility )
    character_uuid = character_uuid or GetHostCharacter()
    Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")

    if not ignore_incompatibility then
        -- TODO: Check character's body type, body shape and race. Warn when applying incompatible visual
        local isCompatible = true
        -- local inCompatibilityReasons = {} -- TODO: bodyShape/bodyType/race
        if not isCompatible then
            _W(string.format("Applying Incompatible visual to character")) -- TODO: inCompatibilityReasons
            return false
        end
    end

    -- Write to PVars
    State.Visuals.Record(character_uuid, change_data, false)
    -- Write to history (Config.json) - As a record of which UUIDs have been applied to a character at any point
    State.Visuals.Record(character_uuid, change_data, true)
    return true
end

-- ==================================================

---@param character_uuid UUID Character to affect
---@param changeID string
---@return boolean
function _Remove( character_uuid, changeID )
    character_uuid = character_uuid or GetHostCharacter()
    Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")

    -- Remove record of this visual from PVars (but not from Config)
    local fromHistory = false
    -- local change_data = State.Visuals.Get( character_uuid, changeID, fromHistory )
    return State.Visuals.Unrecord(character_uuid, changeID, fromHistory)
end

-- ==================================================
-- ==================================================

---@param character_uuid UUID Character to affect
---@param visual_override UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@param callerAddon string Identifier for the mod/addon calling the API
---@return boolean
function Main.Apply_VisualOverride( character_uuid, visual_override, ignoreIncompatibility, callerAddon )
    local changeRecordType = Constants.changeRecordTypes["VISUAL"]
    local changeID = State.Visuals.CreateChangeID(callerAddon, changeRecordType, visual_override) -- "Override:%s"
    local changeData = State.Visuals.CreateChangeRecordTable(changeRecordType, changeID, callerAddon)
    changeData["visual_override"] = visual_override

    if _Record(changeData, character_uuid, ignoreIncompatibility) then
        Osi.AddCustomVisualOverride(character_uuid, visual_override)
        _I(string.format("Applied visual override with UUID: '%s'", visual_override))
        return true
    end
    return false
end

---@param character_uuid UUID Character to affect
---@param new_visual UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@param callerAddon string Identifier for the mod/addon calling the API
---@return boolean
function Main.Apply_EntityVisual_Add( character_uuid, new_visual, ignoreIncompatibility, callerAddon )
    local changeRecordType = Constants.changeRecordTypes["ENTITY_VISUALS_ADD"]
    local changeID = State.Visuals.CreateChangeID(callerAddon, changeRecordType, new_visual) -- "Add:%s"
    local changeData = State.Visuals.CreateChangeRecordTable(changeRecordType, changeID, callerAddon)
    changeData["new_visual"] = new_visual

    local newIndex = KVS_Entity.CCA.GetVisualsCount(character_uuid) + 1
    changeData["index"] = newIndex

    if _Record(changeData, character_uuid, ignoreIncompatibility) then
        KVS_Entity.CCA.AddVisualByUUID(character_uuid, new_visual, newIndex, false)
        _I(string.format("Added entity visual with UUID: '%s' at index: '%s'", new_visual, newIndex))
        return true
    end
    return false
end

---@param character_uuid UUID Character to affect
---@param old_visual UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@param new_visual UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@param callerAddon string Identifier for the mod/addon calling the API
---@return boolean
function Main.Apply_EntityVisual_Swap( character_uuid, old_visual, new_visual, ignoreIncompatibility, callerAddon )
    local changeRecordType = Constants.changeRecordTypes["ENTITY_VISUALS_SWAP"] -- "Swap:%s_%s"
    local changeID = State.Visuals.CreateChangeID(callerAddon, changeRecordType, old_visual, new_visual)
    local changeData = State.Visuals.CreateChangeRecordTable(changeRecordType, changeID, callerAddon)
    changeData["old_visual"] = old_visual
    changeData["new_visual"] = new_visual

    if _Record(changeData, character_uuid, ignoreIncompatibility) then
        KVS_Entity.CCA.ReplaceVisualByUUID(character_uuid, old_visual, new_visual, false, false)
        _I(string.format("Replaced entity visual - Old: '%s', New: '%s'", old_visual, new_visual))
        return true
    end
    return false
end

---@param material UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@param character_uuid UUID Character to affect
---@param callerAddon string Identifier for the mod/addon calling the API
---@return boolean
function Main.Apply_MaterialOverride( character_uuid, material, ignoreIncompatibility, callerAddon )
    local changeRecordType = Constants.changeRecordTypes["MATERIAL"]
    local changeID = State.Visuals.CreateChangeID(callerAddon, changeRecordType, material) -- "MaterialOverride:%s"
    _W("MaterialOverride not implemented yet!")
    return false

    -- local changeData = State.Visuals.CreateChangeRecordTable( Constants.changeRecordTypes["MATERIAL"], callerAddon )
    -- changeData["material"] = material

    -- return _Apply(changeData, character_uuid, ignoreIncompatibility)
    -- return _Apply(visual_uuid, character_uuid, Constants.changeRecordTypes["MATERIAL"], ignoreIncompatibility, callerAddon)
end

-- ==================================================

---@param character_uuid UUID Character to affect
---@param visual_override UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@return boolean
function Main.Remove_VisualOverride( character_uuid, visual_override, callerAddon )
    local changeRecordType = Constants.changeRecordTypes["VISUAL"]
    local changeID = State.Visuals.CreateChangeID(callerAddon, changeRecordType, visual_override) -- "Override:%s"

    if _Remove(character_uuid, changeID) then
        -- Beware typo in Larian function name
        Osi.RemoveCustomVisualOvirride(character_uuid, visual_override)
        _I(string.format("Removed visual override with UUID: '%s'", visual_override))
        return true
    end
    return false
end

---@param character_uuid UUID Character to affect
---@param new_visual UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@return boolean
function Main.Remove_EntityVisual( character_uuid, new_visual, callerAddon )
    local changeRecordType = Constants.changeRecordTypes["ENTITY_VISUALS_ADD"]
    local changeID = State.Visuals.CreateChangeID(callerAddon, changeRecordType, new_visual) -- "Add:%s"

    if _Remove(character_uuid, changeID) then
        local removedFomIndex = KVS_Entity.CCA.RemoveVisualByUUID(character_uuid, new_visual, false)
        _I(string.format("Removed entity visual with UUID: '%s' at index: '%s'", new_visual, removedFomIndex))
        return true
    end
    return false
end

---@param character_uuid UUID Character to affect
---@param replaced_visual UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@param new_visual UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@return boolean
function Main.Remove_EntityVisual_Swap( character_uuid, replaced_visual, new_visual, callerAddon )
    local changeRecordType = Constants.changeRecordTypes["ENTITY_VISUALS_SWAP"] -- "Swap:%s_%s"
    local changeID = State.Visuals.CreateChangeID(callerAddon, changeRecordType, replaced_visual, new_visual)
    if _Remove(character_uuid, changeID) then
        -- Reversed swap
        KVS_Entity.CCA.ReplaceVisualByUUID(character_uuid, new_visual, replaced_visual, false, false)
        return true
    end
    return false
end

---@param visual_uuid UUID ID of a valid CharacterCreationAppearanceVisual or CharacterCreationSharedVisual
---@param character_uuid UUID Character to affect
---@return boolean
function Main.Remove_MaterialOverride( character_uuid, visual_uuid, callerAddon )
    _W("MaterialOverride not implemented yet!")
    return false
    -- material_uuid must be a `ScriptMaterialOverridePreset` - Can't be a generic material etc.
    -- return _Remove(visual_uuid, character_uuid, Constants.changeRecordTypes["MATERIAL"], ignoreIncompatibility)
end

-- ==================================================

-- ---@param character_uuid UUID Character to affect
-- ---@param unrecordHistory boolean
-- function RemoveAllUsedVisualsForCharacter( character_uuid, unrecordHistory )
--     character_uuid = character_uuid or GetHostCharacter()
--     Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")

--     -- TODO

--     -- local visualsUsed = State.Visuals.GetForCharacter(character_uuid, usedVisualsByCharacter)

--     -- for visual_uuid in pairs(visualsUsed) do
--     --     RemoveCustomVisualOverride(character_uuid, visual_uuid)
--     --     if unrecord then
--     --         State.Visuals.Unrecord(visual_uuid, character_uuid)
--     --     end
--     -- end
-- end
-- Main.RemoveAllUsedVisualsForCharacter = RemoveAllUsedVisualsForCharacter
