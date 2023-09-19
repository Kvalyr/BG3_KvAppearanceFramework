local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug

local Utils = KVS.Utils
local Table = KVS.Table

local Main = Main

-- ==================================================
local Addons = Addons
-- ==================================================

local registeredAddons = {}

function Addons.Register(addonKey, addonName, addonAuthor, addonDesc, addonVersion)
    local newAddon = {}
    newAddon["key"] = addonKey
    newAddon["name"] = addonName
    newAddon["author"] = addonAuthor
    newAddon["desc"] = addonDesc
    newAddon["version"] = addonVersion

    registeredAddons[addonKey] = newAddon
end

function Addons.List()
    _I("================")
    _I("Registered Addons:")
    _I("============")

    local padAmt = 18
    for key, addonTable in Table.pairsByKeys(registeredAddons) do
        local addonkey = Utils.LeftPad( key, padAmt, " " )
        local addonName = Utils.LeftPad( addonTable.name, padAmt, " " )
        local addonAuthor = Utils.LeftPad( addonTable.author, padAmt, " " )
        local addonDesc = Utils.LeftPad( addonTable.desc, 30, " " )

        _I(addonkey, ":", addonName, ":", addonAuthor, ":", addonDesc)
    end
    _I("========")
end