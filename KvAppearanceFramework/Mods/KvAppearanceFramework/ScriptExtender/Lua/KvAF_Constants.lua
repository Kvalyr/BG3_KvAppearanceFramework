local Constants = Constants

local EQUIV_RACES_1 = "Hum/Elf/Tief/Gith"
local EQUIV_RACES_2 = "Halfling/Gnome"
local EQUIV_RACES_3 = "HalfOrc/Strong"
local compat_equivalentRaces = {}
compat_equivalentRaces["Human"] = EQUIV_RACES_1
compat_equivalentRaces["Elf"] = EQUIV_RACES_1
compat_equivalentRaces["HalfElf"] = EQUIV_RACES_1
compat_equivalentRaces["HalfDrow"] = EQUIV_RACES_1
compat_equivalentRaces["Drow"] = EQUIV_RACES_1
compat_equivalentRaces["Tiefling"] = EQUIV_RACES_1
compat_equivalentRaces["Githyanki"] = EQUIV_RACES_1 -- Debatable

compat_equivalentRaces["Gnome"] = EQUIV_RACES_2
compat_equivalentRaces["Halfling"] = EQUIV_RACES_2

compat_equivalentRaces["HalfOrc"] = EQUIV_RACES_3

Constants.compat_equivalentRaces = compat_equivalentRaces