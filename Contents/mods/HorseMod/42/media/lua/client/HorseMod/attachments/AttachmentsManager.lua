---@namespace HorseMod

---REQUIREMENTS
local HorseUtils = require("HorseMod/Utils")
local Attachments = require("HorseMod/attachments/Attachments")
local ISHorseEquipGear = require("HorseMod/attachments/timedAction/ISHorseEquipGear")

---@class AttachmentsManager
local AttachmentsManager = {}

---@param player IsoPlayer
---@param horse IsoAnimal
---@param accessory InventoryItem
AttachmentsManager.equipAccessory = function(player, horse, accessory)
    local mx, my, mz = HorseUtils.getClosestMount(player, horse)
    local path = ISPathFindAction:pathToLocationF(player, mx, my, mz)

    local unlock, lockDir = HorseUtils.lockHorseForInteraction(horse)
    local function cleanupOnFail()
        unlock()
    end

    path:setOnFail(cleanupOnFail)
    function path:stop()
        cleanupOnFail()
        self:stop()
    end
    path:setOnComplete(function(p)
        p:setDir(lockDir)
    end, player)
    ISTimedActionQueue.add(path)
    ISTimedActionQueue.add(ISHorseEquipGear:new(player, horse, accessory, unlock))
end



---@param player IsoPlayer
---@param horse IsoAnimal
---@param context ISContextMenu
---@param accessories ArrayList
---@param attachedItems InventoryItem[]
AttachmentsManager.populateHorseContextMenu = function(player, horse, context, accessories, attachedItems)
    -- verify that the horse subcontext menu exists
    -- might not be necessary, but in-case another mod fucks around with it for X reasons
    local horseOption = context:getOptionFromName(horse:getFullName())
    if not horseOption or not horseOption.subOption then return end
    ---@cast horseOption umbrella.ISContextMenu.Option

    -- retrieve horse context menu
    ---@diagnostic disable-next-line
    local horseSubMenu = context:getSubMenu(horseOption.subOption) --[[@as ISContextMenu]]

    -- create gear submenu, even if no gear is available
    local gearOption = horseSubMenu:addOption(getText("ContextMenu_Horse_Gear"))
    local gearSubMenu = ISContextMenu:getNew(context)
    context:addSubMenu(gearOption, gearSubMenu)

    --- EQUIP OPTIONS
    local equipOption = gearSubMenu:addOption(getText("ContextMenu_Horse_Equip"))
    local accessoriesCount = accessories:size()
    if accessoriesCount > 0 then
        -- make it a submenu, and add each individual items
        local equipSubMenu = ISContextMenu:getNew( context)
        gearSubMenu:addSubMenu(equipOption, equipSubMenu)
        for i = 0, accessoriesCount - 1 do
            local accessory = accessories:get(i)
            equipSubMenu:addOption(
                accessory:getDisplayName(),
                player,
                AttachmentsManager.equipAccessory,
                horse,
                accessory
            )
        end
    else
        -- not item to equip
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip.description = getText("ContextMenu_Horse_No_Compatible_Gear")
        equipOption.toolTip = tooltip
        ---@diagnostic disable-next-line
        equipOption.notAvailable = true
    end


    --- UNEQUIP OPTIONS
    local attachmentsCount = #attachedItems
    if attachmentsCount > 0 then
        local unequipOption = gearSubMenu:addOption(getText("ContextMenu_Horse_Unequip"))
        local unequipSubMenu = ISContextMenu:getNew( context)
        gearSubMenu:addSubMenu(unequipOption, unequipSubMenu)
        for i = 1, attachmentsCount do
            local attachment = attachedItems[i] --[[@as InventoryItem]]
            unequipSubMenu:addOption(attachment:getDisplayName())
        end

        -- unequip option if more than one item is present
        if attachmentsCount > 1 then
            unequipSubMenu:addOption(getText("ContextMenu_Horse_Unequip_All"), player)
        end
    end
end


---@param playerNum integer
---@param context ISContextMenu
---@param animals IsoAnimal[]
AttachmentsManager.onClickedAnimalForContext = function(playerNum, context, animals)
    local player = getSpecificPlayer(playerNum)
    local accessories = Attachments.getAvailableGear(player)
    for i = 1, #animals do repeat
        local animal = animals[i]
        if HorseUtils.isHorse(animal) then
            DebugLog.log(tostring(animal))
            local attachedItems = Attachments.getAttachedItems(animal)
            AttachmentsManager.populateHorseContextMenu(player, animal, context, accessories, attachedItems)
        end
    until true end
end

Events.OnClickedAnimalForContext.Add(AttachmentsManager.onClickedAnimalForContext)