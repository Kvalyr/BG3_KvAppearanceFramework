Dynamic Appearance Framework
by Kvalyr

Script Extender is Required for this mod

Description:
This mod is a framework for modifying character appearance dynamically. That means that it doesn't appear to do much on its own, but other mods will specify it as a requirement.

It can be used to apply any existing 'CharacterCreationSharedVisual' to a character. These are objects in the game that represent the various body parts and visual features that comprise characters.

We can make our own 'CharacterCreationSharedVisual' definitions in mods, and this means we can do things like adding Vampire Fangs to a character, adding Tiefling horns to a non-Tiefling, stacking multiple hairstyles on a character for new combinations, etc.
All existing character visuals both in the base game and in mods (with permission) can be converted to work with this system easily.


Limitations:
* This system has limitations that are still being explored. Currently, only object/mesh visuals can be added to characters.
* Future versions will support adding material overrides (dyes, colours for hair/skin/eyes, scars, tattoos, etc.)
* Options to hide existing character parts (so that they don't clip through the visuals you add) are still being explored

* In this early release, the only way to interact with the mod is via the Script Extender Console. Later versions will add in-game ways to use it.


Installation:
If you don't know how to install mods, this probably shouldn't be your first one. This mod is complex and not yet user-friendly.

* Install BG3 Mod Manager (Vortex might work, but I don't use it and can't help you with it. If you use it, you're on your own.)
* Install BG3 Script Extender  (You can install this easily using BG3 Mod Manager)
* Install it the same as any other mod that comes in a .pak file


How to add visual packs:
* Visual packs are installed like any other mod. Load order generally doesn't matter.
* Visual packs can be simple or complex, as they are effectively mods in their own right. Most visual packs added should 'just work'.


Uninstallation:
* It's almost never a good idea to remove mods from an ongoing playthrough.
* This initial release should not be uninstalled from an active game. A future version will make it safer to uninstall.


For mod developers:
* As of v0.2, DAF has a rudimentary API. You can see its docstrings here: https://github.com/Kvalyr/BG3_KvAppearanceFramework/blob/main/KvAppearanceFramework/Mods/KvAppearanceFramework/ScriptExtender/Lua/API/v1.lua
* To get an API client at runtime call `Mods.KvAppearanceFramework.API.GetClient("v1")`


FAQ:

Basics

Q: What does this mod actually do?
A: It lets you add appearance parts to your characters, such as Hair, Horns, Teeth, etc. during the game.
These options go beyond what is available in character creation, or they can even be in addition to what's already there.

Q: Is this 'character recustomization'?
A: No - This mod is for adding additional changes to your characters separately from how they look when you create them.

Q: How does this differ from Appearance Edit by Eralyne?
A: This mod complements 'Appearance Edit', it does not replace it. Where 'Appearance Edit' lets you recustomize your character from scratch, this mod allows you to add additional visual features to your character.
In theory, you should be able to use both mods together but this has not been tested yet whatsoever.

Q: Can this be used for equipment appearances? Transmog? Glamours?
A: Maybe. Watch this space. No promises, but that's the end goal of this mod in one form or another; but it's not guaranteed to be implemented any time soon or to be a smooth, polished experience.
Technically: Yes. There's nothing stopping us from using this for equipment appearances; it's just non-trivial work to set up the 'CharacterCreationSharedVisual' definitions to do it; and there's work to be done with figuring out how best to hide existing gear, etc.

Q: Technical: If I know what I'm doing, can't I just use 'Osi.AddCustomVisualOverride(character_uuid, visual_uuid)' directly in Script Extender?
A: Yes! This mod is effectively just a wrapper and management structure for visual overrides applied using stock Osiris functions exposed by Script Extender.
The plan is to build around this logic to make it easier to toggle these overrides on and off, keep track of them, manage 'slots' and additive-vs-exclusive visuals, and/or trigger them on scripted conditions in future versions.



Planned Features:
* Ease-of-Use changes - I recognize that running commands from the Script Extender console is not user-friendly. Finding in-game ways to interact with a complex system like this is not an easy task.
* 'Triggers' system - For use with adding/removing visuals based on Spells Cast, Passives on characters, Items worn, etc.


Credits:
* Norbyte for LSLib & Script Extender
* LaughingLeader for BG3 Mod Manager
* ShinyHobo for the BG3 MultiTool
* Larian Studios for the best CRPG in years