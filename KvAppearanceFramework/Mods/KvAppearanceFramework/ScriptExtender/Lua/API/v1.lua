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
-- ==================================================
local API_v1 = {}
API.versions["1"] = API_v1
-- ==================================================

-- v1 API

-- ========
-- Main

--- Apply a visual override to a character
-- @param visual_uuid : string : UUID of the VisualOverride to apply
-- @param character_uuid : string : UUID of the character to affect
-- @param ignoreIncompatibility : bool : If true, warnings about visual incompatibility are NOT shown
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Apply(visual_uuid, character_uuid, ignoreIncompatibility, callerAddon)
    return Main.ApplyVisual(visual_uuid, character_uuid, ignoreIncompatibility)
end

--- Remove a visual override from a character
-- @param visual_uuid : string : UUID of the VisualOverride to remove
-- @param character_uuid : string : UUID of the character to affect
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Remove(visual_uuid, character_uuid, callerAddon)
    return Main.RemoveVisual(visual_uuid, character_uuid)
end

--- Remove ALL visual overrides from a character
-- @param character_uuid : string : UUID of the character to affect
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.RemoveAll(character_uuid, callerAddon)
    return Main.RemoveAllUsedVisualsForCharacter(character_uuid, unrecord)
end

-- ========
-- Library

--- Get a table with the names of all categories in DAF's library
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Library_GetAllCategoryNames(callerAddon)
    return VisualLibrary.GetAllCategoryNames()
end

--- Get a table with the names of call options in a category in DAF's library
-- Note: These are just the options formally known and categorized in DAF. Others can be applied by UUID.
-- @param categoryKey : string : Name of the category to list from (e.g.; 'Horns', 'Head', 'Hair')
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Library_GetAllOptions(categoryKey, callerAddon)
    return VisualLibrary.GetAllOptionKeysForCategory( categoryKey )
end

--- List all available categories in DAF's library to the console and their counts
-- Note: These are just the options formally known and categorized in DAF. Others can be applied by UUID.
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Library_ListCategories(callerAddon)
    return VisualLibrary.ReportInfo()
end

--- List all available options in a category in DAF's library to the console
-- Note: These are just the options formally known and categorized in DAF. Others can be applied by UUID.
-- @param categoryKey : string : Name of the category to list from (e.g.; 'Horns', 'Head', 'Hair')
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Library_ListOptions(categoryKey, callerAddon)
    return VisualLibrary.ReportOptionsForCategory( categoryKey )
end

--- Apply an option from DAF's library by category key and option key (instead of by UUID)
-- @param categoryKey : string : UUID of the character to affect
-- @param optionKey : string : Name of the visual option to apply
-- @param ignoreIncompatibility : bool : If true, warnings about visual incompatibility are NOT shown
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Library_ApplyByCategory(categoryKey, optionKey, ignoreIncompatibility, callerAddon)
    return VisualLibrary.ApplyVisualByCategory( categoryKey, optionKey, ignoreIncompatibility )
end

--- Apply an option from DAF's library by category key and option key (instead of by UUID)
-- @param categoryKey : string : UUID of the character to affect
-- @param optionKey : string : Name of the visual option to apply
-- @param callerAddon : string : A string identifying the mod/addon calling the API
function API_v1.Library_RemoveByCategory(categoryKey, optionKey, callerAddon)
    return VisualLibrary.RemoveVisualByCategory( categoryKey, optionKey )
end


--- Add a visual option to DAF's library
-- @param categoryKey : string : UUID of the character to affect
-- @param optionKey : string : Name of the visual option to use when applying
-- @param uuid : uuid : UUID of the Visual Override
-- @param description : string : Short description of the Visual (28 characters or less)
-- @param bodyType : string : Compatible BodyType - [Masc/Femme]
-- @param bodyShape : string : Compatible BodyShape - [Normal/Strong]
-- @param intendedRace : string : Compatible race - [Human/Elf/HalfElf/HalfDrow/Drow/Tiefling/Githyanki/Dwarf/Gnome/Halfling/HalfOrc]
-- @param noDeduplicate : bool : If true, DAF will return an error for a duplicate optionKey instead of automatically deduplicating (by appending a number)
-- @param callerAddon : string : A string identifying the mod/addon calling the API. Visuals added are categorized by addon.
function API_v1.Library_AddOption(categoryKey, optionKey, uuid, description, bodyType, bodyShape, intendedRace, noDeduplicate, callerAddon)
    return VisualLibrary.AddOptionWithCompatInfo(callerAddon, categoryKey, optionKey, description, uuid, bodyType, bodyShape, intendedRace, noDeduplicate)
end


--- Get the UUID of a visual option in DAF's library
-- @param categoryKey : string : UUID of the character to affect
-- @param optionKey : string : Name of the visual option to use when applying
-- @param callerAddon : string : A string identifying the mod/addon calling the API. Visuals added are categorized by addon.
-- @param reportOptions : bool : If true, Reports options available in category if optionKey is not found
function API_v1.Library_GetOption(categoryKey, optionKey, reportOptions, callerAddon)
    return VisualLibrary.GetOptionByCategory(categoryKey, optionKey, reportOptions)
end
-- ==================================================
