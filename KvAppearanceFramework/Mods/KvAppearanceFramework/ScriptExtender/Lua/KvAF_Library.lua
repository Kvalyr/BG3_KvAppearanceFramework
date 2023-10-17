local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug
local Utils = KVS.Utils
local String = KVS.String
local Table = KVS.Table
-- ==================================================
local Main = Main
-- ==================================================
local VisualLibrary = VisualLibrary
-- ==================================================

local optionCategories = {}
-- local uuids = {}
local compatInfos = {}
VisualLibrary.optionCategories = optionCategories

-- ==================================================
---@param categoryKey string
function VisualLibrary.AddCategory( categoryKey )
    Utils.assertIsStr(categoryKey, "Invalid categoryKey specified")
    Utils.assert(not optionCategories[categoryKey], "UUIDs category already exists")
    local newCategory = {}
    optionCategories[categoryKey] = newCategory
end

for _, key in pairs(Constants.LibraryOptionTypes) do
    VisualLibrary.AddCategory(key)
end

---@param categoryKey string
---@return table
function VisualLibrary.GetCategory( categoryKey )
    Utils.assert(optionCategories[categoryKey], string.format("UUIDs category doesn't exist: '%s'", categoryKey))
    return optionCategories[categoryKey]
end

-- _D(Mods.KvAppearanceFramework.VisualLibrary.GetAllCategoryNames())
---@return nil
function VisualLibrary.GetAllCategoryNames()
    local ret = {}
    for key in pairs(optionCategories) do
        table.insert(ret, key)
    end
    return ret
end

-- ==================================================
-- Compatiblity Info
function VisualLibrary.AddCompatibilityInfo( optionUUID, bodyType, bodyShape, intendedRace )
    local info = {}
    info["bodyType"] = bodyType
    info["bodyShape"] = bodyShape
    info["intendedRace"] = intendedRace
    compatInfos[optionUUID] = info
end

---@param optionUUID UUID Visual Override
---@return table
function VisualLibrary.GetCompatibilityInfo( optionUUID )
    return compatInfos[optionUUID]
end

---@param sourceAddonKey string Identifier for the mod/addon adding the option
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param optionDesc string Short description of the Visual (28 characters or less)
---@param optionUUID UUID Visual Override
---@param noDeduplicate boolean If true, return an error for a duplicate optionKey instead of automatically deduplicating (by appending a number)
function VisualLibrary.AddOption( sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID, noDeduplicate ) -- , tags, compatibleRaces, compatibleBodies)
    local categoryTab = VisualLibrary.GetCategory(categoryKey)
    Utils.assertIsStr(optionKey, "Invalid optionKey specified")
    if noDeduplicate then
        Utils.assert(not categoryTab[optionKey], string.format("Option '%s' already exists in category '%s'", optionKey, categoryKey))
    else
        if categoryTab[optionKey] then
            local currentTabSize = Table.Size(categoryTab)
            local newKey = optionKey .. "_" .. tostring(currentTabSize)
            _DBG(string.format("Duplicate entry at optionKey: %s (Category: %s) - New key: %s", optionKey, categoryKey, newKey))
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

    -- uuids[optionUUID] = optionTable

    categoryTab[optionKey] = optionTable
end

---@param sourceAddonKey string Identifier for the mod/addon adding the option
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param optionDesc string Short description of the Visual (28 characters or less)
---@param optionUUID UUID Visual Override
---@param bodyType string Compatible BodyType - [Masc/Femme]
---@param bodyShape string Compatible BodyShape - [Normal/Strong]
---@param intendedRace string Compatible race - [Human/Elf/HalfElf/HalfDrow/Drow/Tiefling/Githyanki/Dwarf/Gnome/Halfling/HalfOrc]
---@param noDeduplicate boolean If true, return an error for a duplicate optionKey instead of automatically deduplicating (by appending a number)
---@return nil
function VisualLibrary.AddOptionWithCompatInfo(sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID, bodyType, bodyShape, intendedRace,
    noDeduplicate )
    VisualLibrary.AddOption(sourceAddonKey, categoryKey, optionKey, optionDesc, optionUUID, noDeduplicate)
    VisualLibrary.AddCompatibilityInfo(optionUUID, bodyType, bodyShape, intendedRace)
end

-- ========
-- Mods.KvAppearanceFramework.VisualLibrary.ReportInfo()
---@return nil
function VisualLibrary.ReportInfo()
    local function rowConcat( arg1, arg2, arg3, agr4, arg5, arg6 )

        local maxChars = 120 -- Default Script Extender window columns

        local tab = {
            String.LeftPad(arg1 or "", 36),
            String.LeftPad(arg2 or "", 8),
            -- String.LeftPad(arg3 or "", 8),
            -- String.LeftPad(agr4 or "", 12),
            -- String.LeftPad(arg5 or "", 14),
            -- String.LeftPad(arg6 or "", 28),
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

---@param categoryKey string
---@return table
function VisualLibrary.GetAllOptionKeysForCategory( categoryKey )
    local categoryTab = VisualLibrary.GetCategory(categoryKey)
    local ret = {}
    for key in Table.pairsByKeys(categoryTab) do
        table.insert(ret, key)
    end
    return ret
end

-- Mods.KvAppearanceFramework.VisualLibrary.ReportOptionsForCategory("Head")
-- Mods.KvAppearanceFramework.VisualLibrary.ReportOptionsForCategory("Horns")
---@param categoryKey string
---@param categoryTab? table
---@return nil
function VisualLibrary.ReportOptionsForCategory( categoryKey, categoryTab )
    local categoryTab = categoryTab or VisualLibrary.GetCategory(categoryKey)
    _P("================")
    _P(string.format("Options in '%s' Category:", categoryKey))
    _P("============")

    local function rowConcat( index, optionkey, bodyType, bodyShape, intendedRace, sourceAddon, optionDesc, optionUUID )

        local maxChars = 120 -- Default Script Extender window columns

        local tab = {
            String.LeftPad(index, 4),
            String.LeftPad(optionkey, 36),
            String.LeftPad(bodyType .. "-" .. bodyShape, 15),
            -- String.LeftPad(bodyShape, 8),
            String.LeftPad(intendedRace, 19),
            String.LeftPad(sourceAddon, 14),
            String.LeftPad(optionDesc, 44),
            String.LeftPad(optionUUID, 36),
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
    -- print("Applying options that don't match the [Intended Race] can sometimes result in misplaced parts or clipping.")
    _P("========")
end

-- Mods.KvAppearanceFramework.Library.GetOptionByCategory("Hair", "Unknown_M__Shadowheart_Hair")
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param reportOptions boolean
---@return UUID|nil
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

---@param character_uuid UUID
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param ignoreIncompatibility boolean If true, warnings about visual incompatibility are NOT shown
---@param callerAddon string Identifier for the mod/addon calling the API
function VisualLibrary.ApplyVisualByCategory( character_uuid, categoryKey, optionKey, ignoreIncompatibility, callerAddon )
    local new_visual = VisualLibrary.GetOptionByCategory(categoryKey, optionKey, false)
    if new_visual then
        _I(string.format("Adding visual option: '%s[%s]'", categoryKey, optionKey))
        Main.Apply_EntityVisual_Add(character_uuid, new_visual, ignoreIncompatibility, callerAddon)
    end
end

---@param character_uuid UUID
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param callerAddon string Identifier for the mod/addon calling the API
function VisualLibrary.RemoveVisualByCategory( character_uuid, categoryKey, optionKey, callerAddon )
    local visual_uuid = VisualLibrary.GetOptionByCategory(categoryKey, optionKey, false)
    if visual_uuid then
        Main.Remove_EntityVisual(character_uuid, visual_uuid, callerAddon)
    end
end

-- ==================================================
