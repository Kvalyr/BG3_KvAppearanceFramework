local VisualLibrary = VisualLibrary

local baseGameOptions = {}

-- ==================================================
local Output = KVS.Output
local Static = KVS.Static
local String = KVS.String
local Utils = KVS.Utils
local Constants = Constants
-- ==================================================
local API = API
-- ==================================================

-- ==================================================
-- TODO: move to kvaf library
local VisualResource_Usages = {}
function StoreUsage_VisualResource( VisualResourceUUID, UsageParentType, UsageParentUUID, UsageParentName )
    if not VisualResource_Usages[VisualResourceUUID] then
        VisualResource_Usages[VisualResourceUUID] = {}
    end
    if not VisualResource_Usages[VisualResourceUUID][UsageParentType] then
        VisualResource_Usages[VisualResourceUUID][UsageParentType] = {}
    end

    VisualResource_Usages[VisualResourceUUID][UsageParentType][UsageParentUUID] = UsageParentName
end

-- ==================================================

-- CCSV_Usages[VisualResourceUUID][

local CCSV_Usages = {}
function StoreUsage_CCSV( CCSV_uuid, UsageParentType, UsageParentUUID, UsageParentName )
    if not CCSV_Usages[CCSV_uuid] then
        CCSV_Usages[CCSV_uuid] = {}
    end
    if not CCSV_Usages[CCSV_uuid][UsageParentType] then
        CCSV_Usages[CCSV_uuid][UsageParentType] = {}
    end

    CCSV_Usages[CCSV_uuid][UsageParentType][UsageParentUUID] = UsageParentName
end

-- ==================================================
Static.VisualResource_Usages = VisualResource_Usages
Static.CCSV_Usages = CCSV_Usages
-- ==================================================
local function GetRacesThatUseCCSV( CCSV_uuid )
    local usages = CCSV_Usages[CCSV_uuid]
    if not usages then
        return {}
    end
    return usages["Race"]
end

-- ==================================================
-- ==================================================
Ext.StaticData.Get("4f5d1434-5175-4fa9-b7dc-ab24fba37929", "Race")
-- ==================================================
for _, race_uuid in pairs(Static.GetAllUUIDsForType("Race")) do
    local race_data = Ext.StaticData.Get(race_uuid, "Race")
    local race_name = race_data["Name"]
    local visuals = race_data["Visuals"]
    for _, VisualResourceUUID in pairs(visuals) do
        StoreUsage_CCSV(VisualResourceUUID, "Race", race_uuid, race_name)
    end
end

local hardcoded = {}
hardcoded["9e5d3b73-30b9-4ac1-b6e3-a69f433d87c9"] = {
    SlotName = "Hair",
    BodyType = "Femme",
    BodyShape = "Normal",
    Name = "Shadowheart_Hair",
    CompatibleRaces = Constants.GetRaceCompatGroup("HalfElf"),
    SourceRace = "HalfElf",
    Description = "Shadowheart's Hair",
}
hardcoded["7d1c551c-1c2a-4a45-8af8-bec1d3dbd05e"] = {
    SlotName = "Hair",
    BodyType = "Masc",
    BodyShape = "Normal",
    Name = "Astarion_Hair",
    CompatibleRaces = Constants.GetRaceCompatGroup("Elf"),
    SourceRace = "Elf",
    Description = "Astarion's Hair",
}
hardcoded["b24d2bbc-f40a-4c61-a8c5-6575d78be612"] = {
    SlotName = "Hair",
    BodyType = "Masc",
    BodyShape = "Normal",
    Name = "Gale_Hair",
    CompatibleRaces = Constants.GetRaceCompatGroup("Human"),
    SourceRace = "Human",
    Description = "Gale's Hair",
}
hardcoded["c7780e63-8176-4056-9c8b-d0562319fe78"] = {
    SlotName = "Hair",
    BodyType = "Femme",
    BodyShape = "Normal",
    Name = "Laezel_Hair",
    CompatibleRaces = Constants.GetRaceCompatGroup("Githyanki"),
    SourceRace = "Githyanki",
    Description = "Lae'zel's Hair",
}
hardcoded["672fb3ec-34fd-414f-b541-cee5178c774d"] = {
    SlotName = "Hair",
    BodyType = "Masc",
    BodyShape = "Normal",
    Name = "Wyll_Hair",
    CompatibleRaces = Constants.GetRaceCompatGroup("Human"),
    SourceRace = "Human",
    Description = "Wyll's Hair",
}
hardcoded["e05b0f79-d3af-41eb-b0b2-1164b6f0debf"] = {
    SlotName = "Hair",
    BodyType = "Femme",
    BodyShape = "Normal",
    Name = "Shar_Wrath_Hair",
    CompatibleRaces = Constants.GetRaceCompatGroup("HalfElf"),
    SourceRace = "HalfElf",
    Description = "Shar Wrath Hair",
}

local seenUUIDs = {}

local function Init( CCSV_key, sourceAddonKey )
    -- local CCSV_key = "CharacterCreationSharedVisual"
    local CCSVData_uuids = Static.GetAllUUIDsForType(CCSV_key)
    -- local CCSV_Names = {}
    -- local CCSV_dicts = {}

    local APIClient = API.GetClient("v1", sourceAddonKey)

    -- Output.DebugVerbose("BG3-DAF-CCSV", "Init")

    for _, ccsv_uuid in pairs(CCSVData_uuids) do

        if hardcoded[ccsv_uuid] then
            baseGameOptions[ccsv_uuid] = hardcoded[ccsv_uuid]

        elseif ccsv_uuid ~= Constants.NULL_UUID then

            local ccsv_name = Static.GetNameForUUIDOfType(ccsv_uuid, CCSV_key, "DisplayName", false)
            -- CCSV_Names[ccsv_uuid] = ccsv_name

            local ccsv_data = Ext.StaticData.Get(ccsv_uuid, CCSV_key)
            local SlotName = ccsv_data["SlotName"]
            local VisualResource = ccsv_data["VisualResource"]
            local Tags = ccsv_data["Tags"]
            -- local UUID = ccsv_data["ResourceUUID"]
            -- local BoneName = ccsv_data["BoneName"]

            local BodyType = "Unknown"
            local BodyShape = "Unknown"
            local races_str = "Unknown"
            local orig_race = "Unknown"

            if CCSV_key == "CharacterCreationAppearanceVisual" then
                BodyShape = KVS.Constants.GetBodyShapeString(ccsv_data["BodyShape"])
                BodyType = KVS.Constants.GetBodyTypeString(ccsv_data["BodyType"])
                races_str = KVS.Constants.GetRace_Name_By_UUID(ccsv_data["RaceUUID"])
                orig_race = races_str

            elseif CCSV_key == "CharacterCreationSharedVisual" then
                local races = GetRacesThatUseCCSV(ccsv_uuid)
                for _, v in pairs(races) do
                    races_str = Constants.GetRaceCompatGroup(v)
                    break
                end

                if SlotName == "Hair" or SlotName == "Piercing" then
                    BodyType = "Any"
                    BodyShape = "Any"
                elseif SlotName == "Beard" then
                    BodyType = "Masc"
                    BodyShape = "Any"
                else
                    BodyType = "Unknown"
                    BodyShape = "Any"
                end

            end

            Utils.assert(ccsv_data["ResourceUUID"] == ccsv_uuid)

            baseGameOptions[ccsv_uuid] = {
                SlotName = SlotName,
                BodyType = BodyType,
                BodyShape = BodyShape,
                Name = ccsv_name,
                CompatibleRaces = races_str,
                SourceRace = orig_race,
                Description = nil, -- TODO?
            }
        end
    end

    local count = 0

    for k, v in pairs(baseGameOptions) do
        local optionUUID = k
        local categoryKey = v.SlotName
        local optionDesc = v.Description or v.Name
        local bodyType = v.BodyType
        local bodyShape = v.BodyShape
        local compatibleRaces = v.CompatibleRaces
        local sourceRace = v.SourceRace

        local name_no_spaces = string.gsub(v.Name, "%s+", "_")
        local bodyType_char1 = String.GetFirstChar(bodyType)
        local bodyShape_char1 = String.GetFirstChar(bodyShape)

        Output.DebugVerbose("BG3-DAF-CCSV", k, v)

        if bodyType_char1 == "N" or bodyType_char1 == "A" then
            bodyType_char1 = ""
        end
        if bodyShape_char1 == "N" or bodyShape_char1 == "A" then
            bodyShape_char1 = ""
        end
        local bodyStr = ""
        if bodyShape_char1 ~= "" or bodyType_char1 ~= "" then
            bodyStr = string.format("%s%s_", bodyType_char1, bodyShape_char1)
        end

        local racePrefix = sourceRace
        if sourceRace ~= compatibleRaces then
            racePrefix = Constants.GetRaceCompatGroupIndex(compatibleRaces)
        end

        local optionKey = string.format("%s_%s%s", racePrefix, bodyStr, name_no_spaces)

        APIClient.Library_AddOption(
            categoryKey, optionKey, optionUUID, optionDesc, bodyType, bodyShape, compatibleRaces, false, sourceAddonKey
        )

        table.insert(seenUUIDs, optionUUID)
        count = count + 1
    end
    return count
end

local function Init_CCSV()
    local countAdded = Init("CharacterCreationSharedVisual", "BG3-DAF-CCSV")
    Output.Debug("BG3-DAF-CCSV", "Init_CCSV", "Count:", countAdded)
    Output.Debug("BG3-DAF-CCSV", "Init_CCSV", "seenUUIDs:", #seenUUIDs)
end

local function Init_CCAV()
    local countAdded = Init("CharacterCreationAppearanceVisual", "BG3-DAF-CCAV")
    Output.Debug("BG3-DAF-CCSV", "Init_CCAV", "Count:", countAdded)
    Output.Debug("BG3-DAF-CCSV", "Init_CCAV", "seenUUIDs:", #seenUUIDs)
end

CCSV_Init = Init

BG3_DAF_CCSV.Init_CCSV = Init_CCSV
BG3_DAF_CCSV.Init_CCAV = Init_CCAV

KVS.Events.Register_Osiris("LevelGameplayStarted", 2, "after", Init_CCSV)
KVS.Events.Register_Osiris("LevelGameplayStarted", 2, "after", Init_CCAV)

-- Mods.KvAppearanceFramework.VisualLibrary.ReportInfo()
-- Mods.KvAppearanceFramework.VisualLibrary.ReportOptionsForCategory("Head")
-- Mods.KvAppearanceFramework.VisualLibrary.ReportOptionsForCategory("Hair")
-- Mods.KvAppearanceFramework.VisualLibrary.ReportOptionsForCategory("Horns")
-- Mods.KvAppearanceFramework.VisualLibrary.ReportOptionsForCategory("Teeth")

-- Mods.KvAppearanceFramework.BG3_DAF_CCSV.Init_CCSV()
-- Mods.KvAppearanceFramework.BG3_DAF_CCSV.Init_CCAV()
