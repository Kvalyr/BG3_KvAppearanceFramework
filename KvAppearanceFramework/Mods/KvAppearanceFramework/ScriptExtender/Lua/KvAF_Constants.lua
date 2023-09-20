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

function Constants.GetRaceCompatGroupIndex(raceStr)
    if compat_equivalentRaces[raceStr] then
        return EquivRacesIndices[compat_equivalentRaces[raceStr]]
    end
    return EquivRacesIndices[raceStr]
end

Constants.compat_equivalentRaces = compat_equivalentRaces


-- local