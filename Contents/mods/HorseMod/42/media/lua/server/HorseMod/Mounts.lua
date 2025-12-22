if isClient() then
    return
end

local mountcommands = require("HorseMod/networking/mountcommands")
local commands = require("HorseMod/networking/commands")

local Mounts = {}


---@type table<IsoPlayer, IsoAnimal>
Mounts.playerMountMap = {}

---@type table<IsoAnimal, IsoPlayer>
Mounts.mountPlayerMap = {}


---@param player IsoPlayer
---@param animal IsoAnimal
function Mounts.addMount(player, animal)
    Mounts.playerMountMap[player] = animal
    Mounts.mountPlayerMap[animal] = player

    mountcommands.Mount:send(
        nil,
        {
            animal = commands.getAnimalId(animal),
            character = commands.getPlayerId(player),
        }
    )
end


---@param player IsoPlayer
function Mounts.removeMount(player)
    local mount = Mounts.playerMountMap[player]
    Mounts.playerMountMap[player] = nil
    Mounts.mountPlayerMap[mount] = nil
    
    mountcommands.Dismount:send(
        nil,
        {
            character = commands.getPlayerId(player)
        }
    )
end


return Mounts