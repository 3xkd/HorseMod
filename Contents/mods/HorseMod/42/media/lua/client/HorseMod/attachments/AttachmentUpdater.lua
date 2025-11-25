---@namespace HorseMod

---REQUIREMENTS
local HorseManager = require("HorseMod/HorseManager")
local HorseUtils = require("HorseMod/Utils")

---@class AttachmentUpdater
---@field PENDING_HORSES IsoAnimal[]
local AttachmentUpdater = {
    PENDING_HORSES = {}
}
local PENDING_HORSES = AttachmentUpdater.PENDING_HORSES


---@param animal IsoAnimal
AttachmentUpdater.reapplyFor = function(animal)
    if true then return end

    if not HorseUtils.isHorse(animal) then
        return
    end
    local bySlot, ground = AttachmentUtils.ensureHorseModData(animal)
    if not bySlot then
        return
    end

    local inv = animal:getInventory()

    for slot, fullType in pairs(bySlot) do
        if fullType and fullType ~= "" then
            local cur = AttachmentUtils.getAttachedItem(animal, slot)
            if cur and cur:getFullType() == fullType then
                AttachmentUtils.setAttachedItem(animal, slot, cur)
            else
                local found = inv:FindAndReturn(fullType)
                if found then
                    AttachmentUtils.setAttachedItem(animal, slot, found)
                    ground[slot] = nil
                else
                    local g = ground[slot]
                    if g and g.x and g.y and g.z then
                        local wo, sq = AttachmentUtils.findWorldItemOnSquare(g.x, g.y, g.z, fullType, g.id)
                        if wo then
                            local picked = AttachmentUtils.takeWorldItemToInventory(wo, sq, inv)
                            if picked then
                                AttachmentUtils.setAttachedItem(animal, slot, picked)
                                ground[slot] = nil
                            end
                        end
                    end

                    if not AttachmentUtils.getAttachedItem(animal, slot) then
                        if fullType ~= HorseAttachmentSaddlebags.SADDLEBAG_CONTAINER_TYPE then
                            inv:AddItem(fullType)
                            local fetched = inv:FindAndReturn(fullType)
                            if fetched then
                                AttachmentUtils.setAttachedItem(animal, slot, fetched)
                            end
                        end
                    end
                end
            end
            if slot == HorseAttachmentSaddlebags.SADDLEBAG_SLOT then
                if fullType == HorseAttachmentSaddlebags.SADDLEBAG_FULLTYPE then
                    HorseAttachmentSaddlebags.ensureSaddlebagContainer(animal, nil)
                else
                    HorseAttachmentSaddlebags.removeSaddlebagContainer(nil, animal)
                end
            end
        end
    end
    if not bySlot[HorseAttachmentSaddlebags.SADDLEBAG_SLOT] then
        HorseAttachmentSaddlebags.removeSaddlebagContainer(nil, animal)
    end
end




---Handle horse death.
---@param character IsoGameCharacter
AttachmentUpdater.onCharacterDeath = function(character)
    if not character:isAnimal() or not HorseUtils.isHorse(character) then
        return
    end
    ---@cast character IsoAnimal

    HorseAttachmentGear.dropHorseGearOnDeath(character)
end

Events.OnCharacterDeath.Add(AttachmentUpdater.onCharacterDeath)


local UPDATE_RATE = 8
local TICK_AMOUNT = 0
local checked = {}
AttachmentUpdater.updateHorses = function(ticks)
    -- apply attachments to new horses
    for i = #PENDING_HORSES, 1, -1 do
        local horse = PENDING_HORSES[i]
        if horse:isOnScreen() then
            table.remove(PENDING_HORSES, i)
            AttachmentUpdater.reapplyFor(horse)
            -- HorseAttachmentManes.ensureManesPresentAndColored(horse)
        end
    end

    -- check UPDATE_RATE-th IsoMovingObjects per tick
    local isoMovingObjects = getCell():getObjectList()
    local size = isoMovingObjects:size()
    local updateRate = math.min(UPDATE_RATE,size)
    TICK_AMOUNT = TICK_AMOUNT < updateRate - 1 and TICK_AMOUNT + 1 or 0

    for i = TICK_AMOUNT, size - 1, updateRate do repeat
        local isoMovingObject = isoMovingObjects:get(i)

        -- verify it's a horse
        if not instanceof(isoMovingObject, "IsoAnimal") 
            or HorseUtils.isHorse(isoMovingObject)
            then break end
        ---@cast isoMovingObject IsoAnimal

        if isoMovingObject:isDead() then
            local md = HorseUtils.getModData(isoMovingObject)
            local already = md and md.HM_Attach and md.HM_Attach.DroppedOnDeath
            if not already then
                HorseAttachmentGear.dropHorseGearOnDeath(isoMovingObject)
            end
        elseif isoMovingObject:isOnScreen() then
            AttachmentUpdater.reapplyFor(isoMovingObject)
            HorseAttachmentManes.ensureManesPresentAndColored(isoMovingObject)
        end
    until true end
end

Events.OnTick.Add(AttachmentUpdater.updateHorses)


HorseManager.onHorseAdded:add(function(horse)
    PENDING_HORSES[#PENDING_HORSES + 1] = horse
end)


HorseManager.onHorseRemoved:add(function(horse)
    for i = 1, #PENDING_HORSES do
        if PENDING_HORSES[i] == horse then
            table.remove(PENDING_HORSES, i)
            break
        end
    end
end)


return AttachmentUpdater