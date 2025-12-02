---@namespace HorseMod

---REQUIREMENTS
local HorseUtils = require("HorseMod/Utils")
local AttachmentData = require("HorseMod/attachments/AttachmentData")

---@class ContainerInformation
---@field x number
---@field y number
---@field z number
---@field fullType string
---@field worldID number
---@field worldItem IsoWorldInventoryObject?

---@alias AnimalContainers table<AttachmentSlot, ContainerInformation?>

---Holds all the utility functions to manage containers on horses.
local ContainerManager = {
    ---@type table<IsoAnimal, AnimalContainers?>
    HORSE_CONTAINERS = {}
}
local HORSE_CONTAINERS = ContainerManager.HORSE_CONTAINERS

local function refreshInventories(player)
    local pdata = getPlayerData(player:getPlayerNum())
    pdata.playerInventory:refreshBackpacks()
    pdata.lootInventory:refreshBackpacks()
    triggerEvent("OnContainerUpdate")
end

---Transfert every items from the `srcContainer` to the `destContainer`.
---@param player IsoPlayer
---@param srcContainer ItemContainer
---@param destContainer ItemContainer
ContainerManager.transferAll = function(player, srcContainer, destContainer)
    local items = srcContainer:getItems()
    if not items then return end
    for i = items:size() - 1, 0, -1 do
        local item = items:get(i)
        ISTransferAction:transferItem(player, item, srcContainer, destContainer, nil)    
    end
end

---@param horse IsoAnimal
---@param attachmentDef AttachmentDefinition
---@param fullType string
---@param worldItem IsoWorldInventoryObject?
ContainerManager.registerContainerInformation = function(horse, attachmentDef, fullType, worldItem)
    local modData = HorseUtils.getModData(horse)
    local containers = modData.containers
    local slot = attachmentDef.slot

    -- init cache for this horse if needed
    ---@type AnimalContainers
    HORSE_CONTAINERS[horse] = HORSE_CONTAINERS[horse] or {}

    -- remove info
    if not worldItem then
        -- clear cached and saved info        
        containers[slot] = nil
        HORSE_CONTAINERS[horse][slot] = nil
    else
        local item = worldItem:getItem()

        -- init container info table
        ---@type ContainerInformation
        local containerInfo = {
            x = worldItem:getX(),
            y = worldItem:getY(),
            z = worldItem:getZ(),
            fullType = fullType,
            worldID = item:getID(),
            worldItem = worldItem,
        }

        -- store in mod data
        containers[slot] = containerInfo
        
        -- cache
        HORSE_CONTAINERS[horse][slot] = containerInfo
    end
end

---@param player IsoPlayer
---@param horse IsoAnimal
---@param attachmentDef AttachmentDefinition
---@param accessory InventoryContainer
ContainerManager.initContainer = function(player, horse, attachmentDef, accessory)
    print("Init container")
    -- retrieve the container of the accessory
    local srcContainer = accessory:getItemContainer()
    DebugLog.log(tostring(srcContainer))
    assert(srcContainer ~= nil, "Accessory has container behavior but isn't a container.")

    -- retrieve the square the horse is on
    local square = horse:getSquare()
    assert(square ~= nil, "Horse isn't on a square.")

    -- create the invisible container
    local containerBehavior = attachmentDef.containerBehavior --[[@as ContainerBehavior]]
    local containerItem = square:AddWorldInventoryItem(containerBehavior.worldItem, 0,0,0)
    assert(containerItem:IsInventoryContainer(), "Invisible container ("..containerBehavior.worldItem..") used for "..accessory:getFullType().." isn't a container.")
    ---@cast containerItem InventoryContainer

    local worldItem = containerItem:getWorldItem()
    local destContainer = containerItem:getItemContainer()

    DebugLog.log(tostring(worldItem))
    DebugLog.log(tostring(destContainer))

    -- transfer everything to the invisible container
    ContainerManager.transferAll(player, srcContainer, destContainer)

    refreshInventories(player)

    -- register in the data of the horse the container being attached
    ContainerManager.registerContainerInformation(horse, attachmentDef, accessory:getFullType(), worldItem)
end

---@param player IsoPlayer
---@param horse IsoAnimal
---@param attachmentDef AttachmentDefinition
---@param accessory InventoryContainer
ContainerManager.removeContainer = function(player, horse, attachmentDef, accessory)
    -- retrieve the world container
    local fullType = accessory:getFullType()
    local worldItem = ContainerManager.getContainer(horse, attachmentDef, fullType)
    assert(worldItem ~= nil, "worldItem container not found.")
    
    -- retrieve the inventory container
    local container = accessory:getItemContainer()
    assert(container ~= nil, "Accessory doesn't have an ItemContainer. ("..tostring(accessory)..")")

    -- retrieve the InventoryItem of worldItem
    local containerItem = worldItem:getItem() --[[@as InventoryContainer]]
    assert(containerItem:IsInventoryContainer(), "worldItem isn't an InventoryContainer. ("..tostring(containerItem)..")")

    -- transfer items from world to inventory container
    ContainerManager.transferAll(player, containerItem:getItemContainer(), container)
    
    -- delete world item
    local square = horse:getSquare()
    assert(square ~= nil, "Horse isn't on a square.")

    square:transmitRemoveItemFromSquare(worldItem)
    worldItem:removeFromWorld()
    worldItem:removeFromSquare()
    worldItem:setSquare(nil)

    refreshInventories(player)

    -- sync cached and saved informations
    ContainerManager.registerContainerInformation(horse, attachmentDef, fullType, nil)
end

---@param horse IsoAnimal
---@param attachmentDef AttachmentDefinition
---@param fullType string
ContainerManager.findContainer = function(horse, attachmentDef, fullType)
    ---@TODO to implement

    -- ContainerManager.registerContainerInformation(horse, attachmentDef, worldItem)
end

---@param horse IsoAnimal
---@param attachmentDef AttachmentDefinition
---@param fullType string
---@return IsoWorldInventoryObject?
ContainerManager.getContainer = function(horse, attachmentDef, fullType)
    local slot = attachmentDef.slot

    --  verify horse should have a container there
    local modData = HorseUtils.getModData(horse)
    local containers = modData.containers
    local containerInfo = containers[slot]
    if not containerInfo then return end

    -- init cache for this horse if needed
    ---@type AnimalContainers
    HORSE_CONTAINERS[horse] = HORSE_CONTAINERS[horse] or {}
    local horseContainers = HORSE_CONTAINERS[horse]

    -- find from cache
    local containerInfo = horseContainers[slot]

    -- if container not cached, find it
    if not containerInfo then
        local item = ContainerManager.findContainer(horse, attachmentDef, fullType)
        return item
    end

    return containerInfo.worldItem
end


---@param horses IsoAnimal[]
ContainerManager.track = function(horses)
    for i = 1, #horses do repeat
        local horse = horses[i]
        local squareHorse = horse:getSquare()
        if not squareHorse then break end -- horse is flying ?

        -- get containers linked to the horse
        local modData = HorseUtils.getModData(horse)
        local containers = modData.containers

        -- for each container, retrieve its worldItem
        for slot, containerInfo in pairs(containers) do repeat
            local fullType = containerInfo.fullType
            local attachmentDef = AttachmentData.items[fullType]
            local worldItem = ContainerManager.getContainer(horse, attachmentDef, fullType)
            if worldItem then
                -- update its position if the square is different
                local square = worldItem:getRenderSquare()
                if square and square ~= squareHorse then
                    local item = worldItem:getItem()
                    worldItem:removeFromSquare()
                    worldItem:removeFromWorld()
                    local worldItem = squareHorse:AddWorldInventoryItem(item, 0, 0, 0):getWorldItem()
                    ContainerManager.registerContainerInformation(horse, attachmentDef, fullType, worldItem)
                end
            end
        until true end
    until true end    
end


return ContainerManager
