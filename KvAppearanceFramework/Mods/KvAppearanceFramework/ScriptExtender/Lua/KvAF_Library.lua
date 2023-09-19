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
optionTypes["PIERCING"] = "Piercing"
optionTypes["UNASSIGNED"] = "Unassigned"
optionTypes["UNDERWEAR"] = "Underwear"

optionTypes["TAIL"] = "Tail"
optionTypes["WINGS"] = "Wings"
optionTypes["TEETH"] = "Teeth"
optionTypes["MOUTH"] = "Mouth"

optionTypes["INSTRUMENT"] = "Instrument"
optionTypes["LIGHT"] = "Light"
optionTypes["WEAPON"] = "Weapon"
optionTypes["OFFHAND"] = "Offhand"

optionTypes["JEWELRY"] = "Jewellery"

optionTypes["DYE"] = "Dye"
optionTypes["MODESTY_LEAF"] = "ModestyLeaf"
optionTypes["PRIVATE_PARTS"] = "Private Parts"

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

function VisualLibrary.GetAllCategoryNames()
    local ret = {}
    for key in pairs(optionCategories) do
        table.insert(ret, key)
    end
    return ret
end

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

function VisualLibrary.AddOption( sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID, noDeduplicate ) -- , tags, compatibleRaces, compatibleBodies)
    local categoryTab = VisualLibrary.GetCategory(categoryKey)
    Utils.assertIsStr(optionKey, "Invalid optionKey specified")
    if noDeduplicate then
        Utils.assert(not categoryTab[optionKey], string.format("Option '%s' already exists in category '%s'", optionKey, categoryKey))
    else
        if categoryTab[optionKey] then
            local currentTabSize = Table.Size(categoryTab)
            local newKey = optionKey .. "_" .. tostring(currentTabSize)
            _DBG(string.format("Duplicate entry at optionKey: %s - New key: %s", optionkey, newKey))
            optionKey = newKey
        end
    end
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

function VisualLibrary.AddOptionWithCompatInfo(sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID, bodyType, bodyShape, intendedRace, noDeduplicate )
    VisualLibrary.AddOption(sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID, noDeduplicate)
    VisualLibrary.AddCompatibilityInfo(optionUUID, bodyType, bodyShape, intendedRace)
end

-- Mods.KvAppearanceFramework.Library.ReportInfo()
function VisualLibrary.ReportInfo()
    local function rowConcat( arg1, arg2, arg3, agr4, arg5, arg6 )

        local maxChars = 120 -- Default Script Extender window columns

        local tab = {
            Utils.LeftPad(arg1 or "", 36),
            Utils.LeftPad(arg2 or "", 8),
            -- Utils.LeftPad(arg3 or "", 8),
            -- Utils.LeftPad(agr4 or "", 12),
            -- Utils.LeftPad(arg5 or "", 14),
            -- Utils.LeftPad(arg6 or "", 28),
        }
        return table.concat(tab)
    end
    _P("----------------------------------------------------------------------------------------------------------------")
    _P(rowConcat("[Category]", "[# of Options]"))
    _P("----------------------------------------------------------------------------------------------------------------")
    for k, v in Table.pairsByKeys(optionCategories) do
        _P(rowConcat(k, Table.Size(v)))
    end
end

function VisualLibrary.GetAllOptionKeysForCategory( categoryKey )
    local categoryTab = VisualLibrary.GetCategory(categoryKey)
    local ret = {}
    for key in Table.pairsByKeys(categoryTab) do
        table.insert(ret, key)
    end
    return ret
end

-- Mods.KvAppearanceFramework.Library.ReportOptionsForCategory("Head")
-- Mods.KvAppearanceFramework.Library.ReportOptionsForCategory("Horns")
function VisualLibrary.ReportOptionsForCategory( categoryKey, categoryTab )
    local categoryTab = categoryTab or VisualLibrary.GetCategory(categoryKey)
    _P("================")
    _P(string.format("Options in '%s' Category:", categoryKey))
    _P("============")

    local function rowConcat( index, optionkey, bodyType, bodyShape, intendedRace, sourceAddon, optionDesc, optionUUID )

        local maxChars = 120 -- Default Script Extender window columns

        local tab = {
            Utils.LeftPad(index, 4),
            Utils.LeftPad(optionkey, 36),
            Utils.LeftPad(bodyType, 8),
            Utils.LeftPad(bodyShape, 8),
            Utils.LeftPad(intendedRace, 19),
            Utils.LeftPad(sourceAddon, 14),
            Utils.LeftPad(optionDesc, 28),
            Utils.LeftPad(optionUUID, 36),
        }
        return table.concat(tab)
    end

    local function printHeader()
        _P("----------------------------------------------------------------------------------------------------------------")
        _P(rowConcat("#", "[Option Key]", "[Type]", "[Shape]", "[Intended Race]", "[Source]", "[Description]", "[UUID]"))
        _P("----------------------------------------------------------------------------------------------------------------")
    end

    printHeader()
    local count = 0
    local prevRace = None
    for key, optionTable in Table.pairsByKeys(categoryTab) do
        count = count + 1
        local sourceAddon = optionTable.sourceAddon
        local uuid = optionTable.uuid
        local desc = optionTable.desc
        local compatInfoTable = VisualLibrary.GetCompatibilityInfo(uuid) or {}
        local bodyType = compatInfoTable.bodyType or "Unknown"
        local bodyShape = compatInfoTable.bodyShape or "Unknown"
        local intendedRace = compatInfoTable.intendedRace or "Unknown"

        intendedRace = Constants.GetRaceCompatGroup(intendedRace) or intendedRace

        if prevRace and prevRace ~= intendedRace then
            printHeader()
        end
        _P(rowConcat(string.format("%03d", count), key, bodyType, bodyShape, intendedRace, sourceAddon, desc, uuid))
        prevRace = intendedRace

    end
    _P("========")
    Ext.Utils.PrintWarning(
        "Reminder: Applying options that don't match [Body Type] or [Body Shape] will usually result in misplaced parts or clipping."
    )
    print("Applying options that don't match the [Intended Race] can sometimes result in misplaced parts or clipping.")
    _P("========")
end

-- Mods.KvAppearanceFramework.Library.GetOptionByCategory("Hair", "Unknown_M__Shadowheart_Hair")
function VisualLibrary.GetOptionByCategory( categoryKey, optionKey, reportOptions )
    local categoryTab = VisualLibrary.GetCategory(categoryKey)
    local optionTable = categoryTab[optionKey]
    if not optionTable then
        _W("GetOptionByCategory() Invalid option:", optionKey)
        if reportOptions then
            VisualLibrary.ReportOptionsForCategory(categoryKey, categoryTab)
        end
        return
    end
    return optionTable["uuid"]
end

function VisualLibrary.ApplyVisualByCategory( categoryKey, optionKey, ignoreIncompatibility )
    local visual_uuid = VisualLibrary.GetOptionByCategory(categoryKey, optionKey, false)
    if visual_uuid then
        Main.ApplyVisual(visual_uuid, character_uuid, ignoreIncompatibility)
    end
end

function VisualLibrary.RemoveVisualByCategory( categoryKey, optionKey )
    local visual_uuid = VisualLibrary.GetOptionByCategory(categoryKey, optionKey, false)
    if visual_uuid then
        Main.RemoveVisual(visual_uuid, character_uuid)
    end
end

-- ==================================================
