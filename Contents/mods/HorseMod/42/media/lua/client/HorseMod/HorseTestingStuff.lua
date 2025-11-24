local HorseBridleModel = {}
local HorseRiding = require("HorseMod/Riding")

local function findHorseBridle(horse)
    if horse.getAttachedItems then
        local items = horse:getAttachedItems()
        if items then
            for i = 0, items:size() - 1 do
                local attached = items:get(i)
                if attached then
                    print("Attached: ", attached)
                    local attachedItem = attached:getItem()
                    if attachedItem:getType() == "HorseBridle" then
                        return attachedItem
                    end
                end
            end
        end
    end
end

local function onKeyPressed(key)
    local player = getSpecificPlayer(0)
    if key == Keyboard.KEY_G then
        player:setIgnoreMovement(true)
        player:setBlockMovement(true)
        player:setIgnoreInputsForDirection(true)
    end
    if key == Keyboard.KEY_H then
        player:setIgnoreMovement(false)
        player:setBlockMovement(false)
        player:setIgnoreInputsForDirection(false)
    end
end

Events.OnKeyPressed.Add(onKeyPressed)

-- local function initOnStart()

--     loadStaticZomboidModel(
--         "HorseMod.Horse_BridleWalking",
--         "HorseMod/HorseReinsWalking",
--         "Items/HorseReins"
--     )
--     loadStaticZomboidModel(
--         "HorseMod.Horse_BridleRunning",
--         "HorseMod/HorseReinsRunning",
--         "Items/HorseReins"
--     )
-- end

-- Events.OnGameStart.Add(initOnStart)

return HorseBridleModel