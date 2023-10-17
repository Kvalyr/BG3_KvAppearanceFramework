local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug

local Utils = KVS.Utils
local Table = KVS.Table
local String = KVS.String

local Main = Main
local Library = VisualLibrary

-- ==================================================
local API = API
API.versions = {}
-- ==================================================

--- Get a client object for interacting with DAF
---@param version string A string in the form of "N" or "vN" where N is the version number of the API required
---@param callerAddon string Identifier for the mod/addon calling the API
function API.GetClient(version, callerAddon)
    version = tostring(version)
    if String.StartsWith(version, "v") then
        version = String.RemoveFirst(version)
    end
    local client = API.versions[version]
    if not client then
        _E(string.format("No DAF client available for version specified: %s", version))
        return
    end
    return client
end
