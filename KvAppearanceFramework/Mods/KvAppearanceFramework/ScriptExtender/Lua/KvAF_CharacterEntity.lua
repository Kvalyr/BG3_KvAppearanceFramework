local _E = KVS.Output.Error
local _W = KVS.Output.Warning
local _I = KVS.Output.Info
local _DBG = KVS.Output.Debug
local _DBGV = KVS.Output.DebugVerbose

local Events = KVS.Events
local String = KVS.String
local Table = KVS.Table
local Utils = KVS.Utils
local Entity = KVS.Entity

local Constants = Constants
local Library = VisualLibrary
local Main = Main
local State = State

-- ==================================================
local CharacterEntity = CharacterEntity
-- ==================================================
function CharacterEntity.RepTest()
    -- Mods.KvAppearanceFramework.CharacterEntity.RepTest()
    local entity_uuid = GetHostCharacter()
    local visuals = Entity.CCA.GetVisualsTable(entity_uuid)
    visuals[2] = "1c5edab7-b996-4a9c-b332-2588a7b93944"
    CharacterEntity.RefreshVisuals(entity_uuid)

    -- Mods.KvAppearanceFramework.Entity.RefreshVisuals()
    -- Ext.Entity.Get(GetHostCharacter()).CharacterCreationAppearance.Visuals[2] = "1c5edab7-b996-4a9c-b332-2588a7b93944"
    -- CharacterEntity.RefreshVisuals(entity_uuid)
end
-- ==================================================

---@param entity_uuid UUID Character to affect
---@return table
function CharacterEntity.GetVisualsTable( entity_uuid )
    return Entity.CCA.GetVisualsTable(entity_uuid)
end

---@param entity_uuid UUID Character to affect
function CharacterEntity.RefreshVisuals( entity_uuid )
    -- Mods.KvAppearanceFramework.CharacterEntity.RefreshVisuals()
    return Entity.CCA.Replicate(entity_uuid)
end

---@param entity_uuid UUID Character to affect
---@param index integer Table index of existing visual/part to replace
---@param visual_uuid UUID New visual/part to apply
---@return boolean
function CharacterEntity.ModifyVisualsByIndex(entity_uuid, index, visual_uuid)
    local visuals = CharacterEntity.GetVisualsTable( entity_uuid )
    visuals[index] = visual_uuid
    CharacterEntity.RefreshVisuals(entity_uuid)
    State.VisualsUsed_Record()
    return true
end

-- M Head 4: bdd13d4c-82f2-4dc2-960a-19a144e7b179
-- M Hair: 3191a567-fbec-4c40-bc5e-4abae2253b5f
-- M Beard: 546f55e1-efb7-46d0-b29e-490278a53274
-- M Horns: f1a651d6-522d-4237-9a22-d6fa2d23bb5e

-- MS Head 5: 6dfe4304-5c52-4539-8bae-47c1371e0304
-- MS Hair: 2768eb7b-abb5-47cd-92bc-e4a8caf2521a

-- Mods.KvAppearanceFramework.KVS.Entity.CCA.GetAllVisualsOfSlot(GetHostCharacter(), "Hair")
-- Mods.KvAppearanceFramework.CharacterEntity.ReplaceVisualByUUID(GetHostCharacter(), "e15cdc99-71e9-484a-87de-c845452c8a55", "4aac9b41-75f7-4724-b3cd-e6ca810092a7")
-- Replace M Head 4 with MS Head 5
-- Mods.KvAppearanceFramework.CharacterEntity.ReplaceVisualByUUID(GetHostCharacter(), "bdd13d4c-82f2-4dc2-960a-19a144e7b179", "6dfe4304-5c52-4539-8bae-47c1371e0304")
---@param entity_uuid UUID Character to affect
---@param uuid_to_replace UUID Existing visual/part to replace
---@param visual_uuid UUID New visual/part to apply
---@return boolean
function CharacterEntity.ReplaceVisualByUUID( entity_uuid, uuid_to_replace, visual_uuid )
    local visuals = CharacterEntity.GetVisualsTable( entity_uuid )
    local idxFoundAt
    for idx, v in pairs(visuals) do
        if v == uuid_to_replace then
            -- _DBG("found:", v)
            idxFoundAt = idx
        else
            -- __DBG("not found:", k, v)
        end
    end
    if not idxFoundAt then
        _W("ReplaceVisualByUUID() - uuid_to_replace not found")
        return false
    end
    visuals[idxFoundAt] = visual_uuid
    CharacterEntity.RefreshVisuals(entity_uuid)
    return true
end

-- function CharacterEntity.ModifyVisuals( entity_uuid, visual_index, new_visual_uuid )
--     -- Mods.KvAppearanceFramework.CharacterEntity.ModifyVisuals(GetHostCharacter(), "2", "2fe0cab2-ab4b-4fad-b4a3-d4c16efa3ef3")
--     if Ext.IsClient() then
--         -- TODO: error
--         return
--     end
--     local changes_dict = {}
--     changes_dict["entity_uuid"] = entity_uuid
--     changes_dict["visual_index"] = visual_index
--     changes_dict["new_visual_uuid"] = new_visual_uuid

--     Ext.Entity.Get(entity_uuid).CharacterCreationAppearance.Visuals[visual_index] = new_visual_uuid

--     Net.Server.WriteMessage(Net.CHANNEL_KEY_ENTITY_VISUALS, changes_dict)

--     -- TODO: Delay this
--     CharacterEntity.RefreshVisuals(entity_uuid)
-- end

-- -- ==================================================
-- -- Client
-- -- ==================================================

-- function CharacterEntity.Client_ReplicateVisualChange( changes_dict )
--     if not Ext.IsClient() then
--         -- TODO: err
--         return
--     end
--     -- _DBG("Client_ReplicateVisualChange()")

--     local entity_uuid = changes_dict["entity_uuid"]
--     local visual_index = changes_dict["visual_index"]
--     local new_visual_uuid = changes_dict["new_visual_uuid"]

--     Ext.Entity.Get(entity_uuid).CharacterCreationAppearance.Visuals[visual_index] = new_visual_uuid
-- end

-- -- ==================================================
