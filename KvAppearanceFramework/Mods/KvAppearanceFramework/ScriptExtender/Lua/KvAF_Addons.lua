local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug

local Utils = KVS.Utils
local String = KVS.String
local Table = KVS.Table

local Main = Main

-- ==================================================
local Addons = Addons
-- ==================================================

local registeredAddons = {}

---@param addonKey string Unique Key for Addon
---@param addonDisplayName string DisplayName for Addon
---@param addonAuthor string Addon Author
---@param addonDesc string Addon Description
---@param addonVersion string Addon version
---@return boolean
function Addons.Register(addonKey, addonDisplayName, addonAuthor, addonDesc, addonVersion)
    local newAddon = {}
    newAddon["key"] = addonKey
    newAddon["name"] = addonDisplayName
    newAddon["author"] = addonAuthor
    newAddon["desc"] = addonDesc
    newAddon["version"] = addonVersion

    registeredAddons[addonKey] = newAddon
    return true
end

---@return nil
function Addons.List()
    _I("================")
    _I("Registered Addons:")
    _I("============")

    local padAmt = 18
    for key, addonTable in Table.pairsByKeys(registeredAddons) do
        local addonkey = String.LeftPad( key, padAmt, " " )
        local addonName = String.LeftPad( addonTable.name, padAmt, " " )
        local addonAuthor = String.LeftPad( addonTable.author, padAmt, " " )
        local addonDesc = String.LeftPad( addonTable.desc, 30, " " )

        _I(addonkey, ":", addonName, ":", addonAuthor, ":", addonDesc)
    end
    _I("========")
end