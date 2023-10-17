local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug
local DB = KVS.DB
local Utils = KVS.Utils
local String = KVS.String
local Table = KVS.Table
local Output = KVS.Output
local Config = KVS.Config
local Persist = KVS.Persist
local Static = KVS.Static

local Constants = Constants

-- ==================================================
-- TODO: Move base state logic to KVS
-- ==================================================

local State = State
State.Visuals = {}

State.INSTALL_STATE_KEY = "KVAF_INSTALL_STATE"

local enum_InstallStates = {}
enum_InstallStates["INIT"] = "INIT"
enum_InstallStates["INSTALLED"] = "INSTALLED"
enum_InstallStates["UNINSTALLED"] = "UNINSTALLED"

local CONFIG_KEY_USED_VISUALS = "UsedVisualsByCharacter"

-- ==================================================

---@return string --enum_InstallStates[newState]
function State.GetInstallState()
    return Config.GetValue(State.INSTALL_STATE_KEY)
end

---@param newState string enum_InstallStates[newState]
function State.SetInstallState( newState )
    if not enum_InstallStates[newState] then
        _E("State.SetInstallState() - Invalid install state: '" .. (newState or "") .. "' (type: '" .. type(newState) .. "')")
    end
    return Config.SetValue(State.INSTALL_STATE_KEY, newState)
end

---@return boolean
function State.IsInstalled() -- > bool
    return State.GetInstallState() == enum_InstallStates["INSTALLED"]
end

---@return boolean
function State.IsUninstalled() -- > bool
    return State.GetInstallState() == enum_InstallStates["UNINSTALLED"]
end

---@return nil
function State.Init()
    local install_state = State.GetInstallState()
    if not install_state then
        _I("-- Fresh Installation --")
        install_state = enum_InstallStates["INIT"]
        State.Install()
    else
        _I("State:", install_state or "INIT")
    end
end

---@return nil
function State.Install()
    _I("-- Installing --")
    -- Installation init, callbacks, etc. here
    State.SetInstallState(enum_InstallStates["INSTALLED"])
end

---@return nil
function State.Uninstall()
    _I("-- Uninstalling --")
    -- TODO: Uninstallation cleanup, callbacks, etc. here
    CampEvents.Cleanup()
    State.SetInstallState(enum_InstallStates["UNINSTALLED"])
    Output.MessageBox("Uninstalled. You can now safely remove the mod.")
end

-- ==================================================
-- ==================================================

---@param fromHistory boolean
---@return table -- Config || Persist
local function GetBackend( fromHistory )
    if fromHistory then
        return Config
    end
    return Persist
end

-- ==================================================
-- ==================================================
-- ==================================================

---@param changeRecordType string Constants.changeRecordTypes[changeRecordType]
---@param part1 string
---@param part2? string
---@return string
function State.Visuals.CreateChangeID(callerAddon, changeRecordType, part1, part2)
    if Constants.changeRecordTypes[changeRecordType] == "VISUAL" then
        return string.format("%s:VisualOverride:%s", callerAddon, part1)

    elseif Constants.changeRecordTypes[changeRecordType] == "ENTITY_VISUALS_ADD" then
        return string.format("%s:Add:%s", callerAddon, part1)

    elseif Constants.changeRecordTypes[changeRecordType] == "ENTITY_VISUALS_SWAP" then
        return string.format("%s:Swap:%s_%s", callerAddon, part1, part2)

    elseif Constants.changeRecordTypes[changeRecordType] == "MATERIAL" then
        return string.format("%s:MaterialOverride:%s", callerAddon, part1)
    end
    _E(string.format("Invalid changeRecordType: %s", changeRecordType))
end

-- v1
-- ConfigTable[CONFIG_KEY_USED_VISUALS][character_uuid][addon][changeRecordType][changeID] = change_data
---@param character_uuid UUID
---@param changeID string
---@return string
-- function State.Visuals.GetChangeRecordPath_v1( callerAddon, character_uuid, changeRecordType, changeID )
function State.Visuals.GetChangeRecordPath_v1( character_uuid, changeID )
    -- return string.format("%s.%s.%s.%s.%s", CONFIG_KEY_USED_VISUALS, callerAddon, character_uuid, changeRecordType, changeID)
    -- return string.format("%s.%s.%s.%s", CONFIG_KEY_USED_VISUALS, callerAddon, character_uuid, changeID)
    return string.format("%s.%s.%s", CONFIG_KEY_USED_VISUALS, character_uuid, changeID)
end

---@param character_uuid UUID
---@param change_data table
---@return string
function State.Visuals.GetChangeRecordPath_FromChangeData_v1( character_uuid, change_data )
    local changeRecordType = change_data.changeRecordType
    Utils.assert(changeRecordType, string.format("Invalid changeRecordType: '%s'", changeRecordType))
    local callerAddon = change_data.addon
    Utils.assert(callerAddon, string.format("Invalid callerAddon: '%s'", callerAddon))
    local changeID = change_data.changeID
    Utils.assert(changeID, string.format("Invalid changeID: '%s'", changeID))
    return State.Visuals.GetChangeRecordPath_v1(callerAddon, character_uuid, changeRecordType, changeID)
end

-- ==================================================
---@param changeRecordType string Constants.changeRecordTypes[changeRecordType]
---@param changeID string
---@param callerAddon string Identifier for the mod/addon calling the API
---@return table
function State.Visuals.CreateChangeRecordTable( changeRecordType, changeID, callerAddon )
    Utils.assert(Constants.changeRecordTypes[changeRecordType], string.format("Invalid changeRecordType: '%s'", changeRecordType))
    if not callerAddon then
        callerAddon = "KVAF"
    end
    local change_data = {}
    change_data["changeRecordType"] = changeRecordType
    change_data["addon"] = callerAddon
    change_data["changeID"] = changeID
    return change_data
end
-- ==================================================

--- Get table of all visuals used across all characters
---@param fromHistory boolean Pull from history (Config.json) if true, instead of from PVars for current save
---@return table
function State.Visuals.GetForAllCharacters( fromHistory )
    local backend = GetBackend(fromHistory)
    local configKey = CONFIG_KEY_USED_VISUALS
    local usedVisualsByCharacterByType = backend.GetValue(configKey)
    if not usedVisualsByCharacterByType then
        usedVisualsByCharacterByType = {}
        backend.SetValue(configKey, usedVisualsByCharacterByType)
    end
    return backend.GetValue(configKey)
end

--- Get table of all visuals used for one character
---@param character_uuid UUID
---@param changeRecordType string Constants.changeRecordTypes[changeRecordType]
---@param fromHistory boolean Pull from history (Config.json) if true, instead of from PVars for current save
---@return table
function State.Visuals.GetForCharacter( character_uuid, changeRecordType, fromHistory )
    Utils.assertIsStr(character_uuid, "Invalid character UUID specified - Must be a valid UUID string")
    local usedVisuals_allCharacters = State.Visuals.GetForAllCharacters(fromHistory)

    local thisChar_usedVisuals = usedVisuals_allCharacters[character_uuid]
    if not thisChar_usedVisuals then
        thisChar_usedVisuals = {}
        usedVisuals_allCharacters[character_uuid] = thisChar_usedVisuals
    end
    return thisChar_usedVisuals
end

---@param character_uuid UUID
---@param changeID string
---@param fromHistory boolean Pull from history (Config.json) if true, instead of from PVars for current save
---@return table|nil -- change_data
function State.Visuals.Get( character_uuid, changeID, fromHistory )
    local backend = GetBackend(fromHistory)
    -- local var_path = State.Visuals.GetChangeRecordPath_FromChangeData_v1(character_uuid, change_data)
    local var_path = State.Visuals.GetChangeRecordPath_v1(character_uuid, changeID)
    _DBG("State.Visuals.Record:", var_path)

    -- if fromHistory then
    --     Config.Sync()
    -- end
    return backend.GetNestedValue(var_path)
end

---@param character_uuid UUID
---@param change_data table
---@param fromHistory boolean Pull from history (Config.json) if true, instead of from PVars for current save
---@return boolean
function State.Visuals.Record( character_uuid, change_data, fromHistory ) -- > bool
    local backend = GetBackend(fromHistory)
    local var_path = State.Visuals.GetChangeRecordPath_FromChangeData_v1(character_uuid, change_data)
    -- _DBG("State.Visuals.Record:", var_path)
    backend.SetNestedValue(var_path, change_data)
    -- if fromHistory then
    --     Config.Sync()
    -- end
    return true
end


---@param character_uuid UUID
---@param changeID string
---@param fromHistory boolean Pull from history (Config.json) if true, instead of from PVars for current save
---@return boolean
function State.Visuals.Unrecord( character_uuid, changeID, fromHistory ) -- > bool
    local backend = GetBackend(fromHistory)
    local var_path = State.Visuals.GetChangeRecordPath_v1(character_uuid, changeID)
    backend.SetNestedValue(var_path, nil)
    -- if fromHistory then
    --     Config.Sync()
    -- end
    return true
end
