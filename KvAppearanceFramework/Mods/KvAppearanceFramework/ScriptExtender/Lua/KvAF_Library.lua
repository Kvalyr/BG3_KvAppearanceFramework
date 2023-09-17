local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug

local Utils = KVS.Utils
local Table = KVS.Table

local Main = Main

-- ==================================================
local VisualLibrary = VisualLibrary
-- ==================================================
-- Enums

-- ========
-- Types
local optionTypes = {}
optionTypes["BEARD"] = "Beard"
optionTypes["BODY"] = "Body"
optionTypes["CLOAK"] = "Cloak"
optionTypes["DRAGONBORN_CHIN"] = "DragonbornChin"
optionTypes["DRAGONBORN_JAW"] = "DragonbornJaw"
optionTypes["DRAGONBORN_TOP"] = "DragonbornTop"
optionTypes["FOOTWEAR"] = "Footwear"
optionTypes["HAIR"] = "Hair"
optionTypes["HEAD"] = "Head"
optionTypes["HEADWEAR"] = "Headwear"
optionTypes["HORNS"] = "Horns"
optionTypes["MODESTY_LEAF"] = "ModestyLeaf"
optionTypes["PIERCING"] = "Piercing"
optionTypes["UNASSIGNED"] = "Unassigned"
optionTypes["UNDERWEAR"] = "Underwear"

optionTypes["TAIL"] = "Tail"
optionTypes["WINGS"] = "Wings"
optionTypes["TEETH"] = "Teeth"

optionTypes["INSTRUMENT"] = "Instrument"
optionTypes["LIGHT"] = "Light"
optionTypes["WEAPON"] = "Weapon"
optionTypes["OFFHAND"] = "Offhand"

optionTypes["JEWELRY"] = "Jewellery"

optionTypes["DYE"] = "Dye"
optionTypes["PRIVATES"] = "Privates"

-- ========
-- Tags
local optionTags = {}

-- ========
-- Slots
local optionSlots = {}
optionSlots["BEARD"] = "Beard"
optionSlots["BODY"] = "Body"
optionSlots["CLOAK"] = "Cloak"
optionSlots["DRAGONBORN_CHIN"] = "DragonbornChin"
optionSlots["DRAGONBORN_JAW"] = "DragonbornJaw"
optionSlots["DRAGONBORN_TOP"] = "DragonbornTop"
optionSlots["FOOTWEAR"] = "Footwear"
optionSlots["HAIR"] = "Hair"
optionSlots["HEAD"] = "Head"
optionSlots["HEADWEAR"] = "Headwear"
optionSlots["HORNS"] = "Horns"
optionSlots["MODESTY_LEAF"] = "ModestyLeaf"
optionSlots["PIERCING"] = "Piercing"
optionSlots["UNASSIGNED"] = "Unassigned"
optionSlots["UNDERWEAR"] = "Underwear"

optionSlots["TAIL"] = "Tail" -- Note: Unconfirmed
optionSlots["WINGS"] = "Wings" -- Note: Unconfirmed
optionSlots["INSTRUMENT"] = "Instrument" -- Note: Unconfirmed
optionSlots["LIGHT"] = "Light" -- Note: Unconfirmed
optionSlots["WEAPON"] = "Weapon" -- Note: Unconfirmed
optionSlots["OFFHAND"] = "Offhand" -- Note: Unconfirmed

optionSlots["TEETH"] = "Unassigned" -- Note: Unofficial
optionSlots["PRIVATES"] = "Unassigned" -- Note: Unofficial/Unconfirmed -- TODO: Same slot as ModestyLeaf?

-- ==================================================

-- ==================================================

local optionCategories = {}
local uuids = {}
local compatInfos = {}
VisualLibrary.optionCategories = optionCategories

function VisualLibrary.AddCategory( categoryKey )
    Utils.assertIsStr(categoryKey, "Invalid categoryKey specified")
    Utils.assert(not optionCategories[categoryKey], "UUIDs category already exists")
    local newCategory = {}
    optionCategories[categoryKey] = newCategory
end

for _, key in pairs(optionTypes) do
    VisualLibrary.AddCategory(key)
end

function VisualLibrary.GetCategory( categoryKey )
    Utils.assert(optionCategories[categoryKey], string.format("UUIDs category doesn't exist: '%s'", categoryKey))
    return optionCategories[categoryKey]
end

-- BodyType
-- BodyShape
-- CompatibleRace

function VisualLibrary.AddCompatibilityInfo( optionUUID, bodyType, bodyShape, intendedRace )
    local info = {}
    info["bodyType"] = bodyType
    info["bodyShape"] = bodyShape
    info["intendedRace"] = intendedRace
    compatInfos[optionUUID] = info
end

function VisualLibrary.GetCompatibilityInfo( optionUUID )
    return compatInfos[optionUUID]
end

function VisualLibrary.AddOption( sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID ) -- , tags, compatibleRaces, compatibleBodies)
    local categoryTab = VisualLibrary.GetCategory(categoryKey)
    Utils.assert(not categoryTab[optionKey], string.format("Option '%s' already exists in category '%s'", optionKey, categoryKey))
    Utils.assertIsStr(optionKey, "Invalid optionKey specified")
    Utils.assertIsStr(optionUUID, "Invalid optionUUID specified")

    local optionTable = {}
    optionTable["sourceAddon"] = sourceAddonKey
    optionTable["categoryKey"] = categoryKey
    optionTable["key"] = optionKey
    optionTable["desc"] = optionDesc or ""
    optionTable["uuid"] = optionUUID

    uuids[optionUUID] = optionTable

    categoryTab[optionKey] = optionTable
end

function VisualLibrary.AddOptionWithCompatInfo( sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID, bodyType, bodyShape, intendedRace )
    VisualLibrary.AddOption(sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID)
    VisualLibrary.AddCompatibilityInfo(optionUUID, bodyType, bodyShape, intendedRace)
end

-- Mods.KvAppearanceFramework.Library.ReportOptionsForCategory("Head")
-- Mods.KvAppearanceFramework.Library.ReportOptionsForCategory("Horns")
function VisualLibrary.ReportOptionsForCategory( categoryKey, categoryTab )
    local categoryTab = categoryTab or VisualLibrary.GetCategory(categoryKey)
    _P("================")
    _P(string.format("Options in '%s' Category:", categoryKey))
    _P("============")

    local function rowConcat(optionkey, bodyType, bodyShape, intendedRace, sourceAddon, optionDesc)

        local maxChars = 120 -- Default Script Extender window columns
        local function leftPad(str, len)

        end

        local tab = {
            Utils.LeftPad(optionkey, 34),
            Utils.LeftPad(bodyType, 8),
            Utils.LeftPad(bodyShape, 8),
            Utils.LeftPad(intendedRace, 12),
            Utils.LeftPad(sourceAddon, 14),
            Utils.LeftPad(optionDesc, 28),
        }
        return table.concat(tab)
    end

    local function printHeader()
        _P("----------------------------------------------------------------------------------------------------------------")
        _P(rowConcat("[Option Key]", "[Type]", "[Shape]", "[Race]", "[Source]", "[Description]"))
        _P("----------------------------------------------------------------------------------------------------------------")
    end

    printHeader()
    local count = 0
    local prevRace = None
    for key, optionTable in Table.pairsByKeys(categoryTab) do
        local sourceAddon = optionTable.sourceAddon
        local uuid = optionTable.uuid
        local desc = optionTable.desc
        local compatInfoTable = VisualLibrary.GetCompatibilityInfo(uuid) or {}
        local bodyType = compatInfoTable.bodyType or "Unknown"
        local bodyShape = compatInfoTable.bodyShape or "Unknown"
        local intendedRace = compatInfoTable.intendedRace or "Unknown"

        if prevRace and prevRace ~= intendedRace then
            printHeader()
        end
        -- _I(Utils.LeftPad(key, 30, " "), ":", desc)
        _P(rowConcat(key, bodyType, bodyShape, intendedRace, sourceAddon, desc))
        prevRace = intendedRace

        -- Print header every X rows
        -- count = count + 1
        -- if count % 30 == 0 then
        --     printHeader()
        -- end
    end
    _P("========")
    Ext.Utils.PrintWarning("Reminder: Applying options that don't match the [Body Type] or [Body Shape] will almost always result in misplaced parts or clipping.")
    print("Applying options that don't match the [Intended Race] can sometimes result in misplaced parts or clipping.")
    _P("========")
end

function VisualLibrary.GetOptionFromCategory( categoryKey, optionKey, reportOptions )
    local categoryTab = VisualLibrary.GetCategory(categoryKey)
    local optionTable = categoryTab[optionKey]
    if not optionTable then
        _W("GetOptionFromCategory() Invalid option:", optionKey)
        if reportOptions then
            VisualLibrary.ReportOptionsForCategory(categoryKey, categoryTab)
        end
        return
    end
    return optionTable["uuid"]
end

-- ==================================================
