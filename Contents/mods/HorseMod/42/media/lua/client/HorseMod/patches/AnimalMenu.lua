local Mounts = require("HorseMod/Mounts")
local HorseUtils = require("HorseMod/Utils")
local AnimalMenu = {}

AnimalMenu._originalOnPetAnimal = AnimalContextMenu.onPetAnimal
AnimalContextMenu.onPetAnimal = function(animal, chr)
    local mountedHorse = Mounts.getMount(chr)
    if mountedHorse and HorseUtils.isHorse(animal) and mountedHorse == animal then
        ISTimedActionQueue.add(ISPetAnimal:new(chr, animal))
        return
    elseif mountedHorse then
        return
    end
    AnimalMenu._originalOnPetAnimal(animal, chr)
end

AnimalMenu._originalOnFeedAnimalFood = AnimalContextMenu.onFeedAnimalFood
AnimalContextMenu.onFeedAnimalFood = function(player, animal, food)
    local mountedHorse = Mounts.getMount(player)
    if mountedHorse and HorseUtils.isHorse(animal) and mountedHorse == animal then
        ISTimedActionQueue.add(ISFeedAnimalFromHand:new(player, animal, food))
        return
    elseif mountedHorse then
        return
    end
    AnimalMenu._originalOnFeedAnimalFood(player, animal, food)
end

return AnimalMenu