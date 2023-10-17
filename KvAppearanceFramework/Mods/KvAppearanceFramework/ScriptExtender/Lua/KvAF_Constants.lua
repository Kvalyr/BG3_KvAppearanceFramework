local Constants = Constants
local Output = KVS.Output

Constants.NULL_CCSV = "68388a7c-3a0e-430b-9078-381d8ed1d660"


local EQUIV_RACES_UNK = "Unknown"
local EQUIV_RACES_ANY = "Any"
local EQUIV_RACES_1 = "Hum/Elf/Tief/Gith"
local EQUIV_RACES_2 = "Halfl/Gnom/Dwar"
local EQUIV_RACES_3 = "HalfOrc/Strong"
local EQUIV_RACES_4 = "Dragonborn"

local EquivRacesIndices = {}
EquivRacesIndices[EQUIV_RACES_UNK] = "0"
EquivRacesIndices[EQUIV_RACES_ANY] = ""
EquivRacesIndices[EQUIV_RACES_1] = "1"
EquivRacesIndices[EQUIV_RACES_2] = "2"
EquivRacesIndices[EQUIV_RACES_3] = "3"
EquivRacesIndices[EQUIV_RACES_4] = "4"

local compat_equivalentRaces = {}
compat_equivalentRaces["Unknown"] = EQUIV_RACES_UNK
compat_equivalentRaces["Human"] = EQUIV_RACES_1
compat_equivalentRaces["Elf"] = EQUIV_RACES_1
compat_equivalentRaces["HalfElf"] = EQUIV_RACES_1
compat_equivalentRaces["HalfDrow"] = EQUIV_RACES_1
compat_equivalentRaces["Drow"] = EQUIV_RACES_1
compat_equivalentRaces["Tiefling"] = EQUIV_RACES_1
compat_equivalentRaces["Githyanki"] = EQUIV_RACES_1

compat_equivalentRaces["Dwarf"] = EQUIV_RACES_2
compat_equivalentRaces["Gnome"] = EQUIV_RACES_2
compat_equivalentRaces["Halfling"] = EQUIV_RACES_2

compat_equivalentRaces["HalfOrc"] = EQUIV_RACES_3
compat_equivalentRaces["Dragonborn"] = EQUIV_RACES_4

---@param raceStr string
---@return string
function Constants.GetRaceCompatGroup(raceStr)
    local group = compat_equivalentRaces[raceStr]
    if not group then
        if EquivRacesIndices[raceStr] then
            return raceStr
        end
        Output.Debug("GetRaceCompatGroup()", EQUIV_RACES_UNK, ":", raceStr)
        return EQUIV_RACES_UNK
    end
    return group
end

---@param raceStr string
---@return string
function Constants.GetRaceCompatGroupIndex(raceStr)
    if compat_equivalentRaces[raceStr] then
        return EquivRacesIndices[compat_equivalentRaces[raceStr]]
    end
    return EquivRacesIndices[raceStr]
end

Constants.compat_equivalentRaces = compat_equivalentRaces

-- ==================================================
-- Library Constants

local changeRecordTypes = {}
changeRecordTypes["VISUAL"] = "VISUAL"
changeRecordTypes["MATERIAL"] = "MATERIAL"
changeRecordTypes["ENTITY_VISUALS_ADD"] = "ENTITY_VISUALS_ADD"
changeRecordTypes["ENTITY_VISUALS_SWAP"] = "ENTITY_VISUALS_SWAP"
changeRecordTypes["ENTITY_VISUALS_REMOVE"] = "ENTITY_VISUALS_REMOVE"
Constants.changeRecordTypes = changeRecordTypes

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

Constants.LibraryOptionTypes = optionTypes


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


Constants.LibraryOptionSlots = optionSlots

-- ========
-- Tags
local optionTags = {}
-- TODO