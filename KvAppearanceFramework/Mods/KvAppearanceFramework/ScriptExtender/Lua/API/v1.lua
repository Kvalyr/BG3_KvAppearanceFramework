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
---@param visual_uuid UUID VisualOverride to apply
---@param character_uuid UUID Character to affect
---@param ignoreIncompatibility boolean If true, warnings about visual incompatibility are NOT shown
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Apply_VisualOverride( visual_uuid, character_uuid, ignoreIncompatibility, callerAddon )
    return Main.Apply_VisualOverride(visual_uuid, character_uuid, ignoreIncompatibility, callerAddon)
end

--- Apply a material override to a character
---@param visual_uuid UUID VisualOverride to apply
---@param character_uuid UUID Character to affect
---@param ignoreIncompatibility boolean If true, warnings about visual incompatibility are NOT shown
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Apply_MaterialOverride( visual_uuid, character_uuid, ignoreIncompatibility, callerAddon )
    return Main.Apply_MaterialOverride(visual_uuid, character_uuid, ignoreIncompatibility, callerAddon)
end

--- Add a visual to a character entity's CharacterCreationAppearance.Visuals table
---@param visual_uuid UUID VisualOverride to apply
---@param character_uuid UUID Character to affect
---@param ignoreIncompatibility boolean If true, warnings about visual incompatibility are NOT shown
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Apply_EntityVisual_Add( visual_uuid, character_uuid, ignoreIncompatibility, callerAddon )
    return Main.Apply_EntityVisual_Add(visual_uuid, character_uuid, ignoreIncompatibility, callerAddon)
end

--- Swap an existing visual in a character entity's CharacterCreationAppearance.Visuals table for another
---@param visual_uuid UUID VisualOverride to apply
---@param character_uuid UUID Character to affect
---@param ignoreIncompatibility boolean If true, warnings about visual incompatibility are NOT shown
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Apply_EntityVisual_Swap( visual_uuid, character_uuid, ignoreIncompatibility, callerAddon )
    return Main.Apply_EntityVisual_Swap(visual_uuid, character_uuid, ignoreIncompatibility, callerAddon)
end

--- Remove a visual override from a character
---@param visual_uuid UUID VisualOverride to apply
---@param character_uuid UUID Character to affect
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Remove_VisualOverride( visual_uuid, character_uuid, callerAddon )
    return Main.Remove_VisualOverride(visual_uuid, character_uuid, callerAddon)
end

--- Remove a material override from a character
---@param visual_uuid UUID VisualOverride to apply
---@param character_uuid UUID Character to affect
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Remove_MaterialOverride( visual_uuid, character_uuid, callerAddon )
    return Main.Remove_MaterialOverride(visual_uuid, character_uuid, callerAddon)
end

--- Remove a change from a character's visuals directly at the entity level
---@param visual_uuid UUID VisualOverride to apply
---@param character_uuid UUID Character to affect
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Remove_EntityVisualChange( visual_uuid, character_uuid, callerAddon )
    return Main.Remove_EntityVisualChange(visual_uuid, character_uuid, callerAddon)
end

--- Remove ALL visual overrides from a character
---@param character_uuid UUID Character to affect
---@param callerAddon string Identifier for the mod/addon calling the API
---@param unrecord boolean
function API_v1.RemoveAll( character_uuid, callerAddon, unrecord )
    return Main.RemoveAllUsedVisualsForCharacter(character_uuid, unrecord, callerAddon)
end

-- ========
-- Library

--- Get a table with the names of all categories in DAF's library
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Library_GetAllCategoryNames( callerAddon )
    return VisualLibrary.GetAllCategoryNames()
end

--- Get a table with the names of call options in a category in DAF's library
-- Note: These are just the options formally known and categorized in DAF. Others can be applied by UUID.
---@param categoryKey string
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Library_GetAllOptions( categoryKey, callerAddon )
    return VisualLibrary.GetAllOptionKeysForCategory(categoryKey, callerAddon)
end

--- List all available categories in DAF's library to the console and their counts
-- Note: These are just the options formally known and categorized in DAF. Others can be applied by UUID.
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Library_ListCategories( callerAddon )
    return VisualLibrary.ReportInfo(callerAddon)
end

--- List all available options in a category in DAF's library to the console
-- Note: These are just the options formally known and categorized in DAF. Others can be applied by UUID.
---@param categoryKey string
function API_v1.Library_ListOptions( categoryKey )
    return VisualLibrary.ReportOptionsForCategory(categoryKey)
end

--- Get the UUID of a visual option in DAF's library
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param reportOptions boolean If true, Reports options available in category if optionKey is not found
function API_v1.Library_GetOption( categoryKey, optionKey, reportOptions )
    return VisualLibrary.GetOptionByCategory(categoryKey, optionKey, reportOptions)
end

--- Apply an option from DAF's library by category key and option key (instead of by UUID)
---@param character_uuid UUID Character to affect
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param ignoreIncompatibility boolean If true, warnings about visual incompatibility are NOT shown
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Library_ApplyByCategory( character_uuid, categoryKey, optionKey, ignoreIncompatibility, callerAddon )
    return VisualLibrary.ApplyVisualByCategory(character_uuid, categoryKey, optionKey, ignoreIncompatibility, callerAddon)
end

--- Apply an option from DAF's library by category key and option key (instead of by UUID)
---@param character_uuid UUID Character to affect
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Library_RemoveByCategory( character_uuid, categoryKey, optionKey, callerAddon )
    return VisualLibrary.RemoveVisualByCategory(character_uuid, categoryKey, optionKey, callerAddon)
end

--- Add a visual option to DAF's library
---@param categoryKey string
---@param optionKey string Name of the visual option to use when applying
---@param uuid UUID Visual Override
---@param description string Short description of the Visual (28 characters or less)
---@param bodyType string Compatible BodyType - [Masc/Femme]
---@param bodyShape string Compatible BodyShape - [Normal/Strong]
---@param intendedRace string Compatible race - [Human/Elf/HalfElf/HalfDrow/Drow/Tiefling/Githyanki/Dwarf/Gnome/Halfling/HalfOrc]
---@param noDeduplicate boolean If true, DAF will return an error for a duplicate optionKey instead of automatically deduplicating (by appending a number)
---@param callerAddon string Identifier for the mod/addon calling the API
function API_v1.Library_AddOption( categoryKey, optionKey, uuid, description, bodyType, bodyShape, intendedRace, noDeduplicate, callerAddon )
    return VisualLibrary.AddOptionWithCompatInfo(
        callerAddon, categoryKey, optionKey, description, uuid, bodyType, bodyShape, intendedRace, noDeduplicate
    )
end

-- ==================================================
