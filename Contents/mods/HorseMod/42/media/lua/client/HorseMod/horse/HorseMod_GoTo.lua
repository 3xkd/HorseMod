local HorseRiding = require("HorseMod/shared/HorseMod_Riding")
require "TimedActions/ISPathFindAction"
local core = getCore()
local HorseUtils = require("HorseMod/HorseMod_Utils")

local currentOffset = nil

local DEST_X = 10615
local DEST_Y = 9807

local lastHorse = {}

Events.OnPlayerUpdate.Add(function(player)
    if not player then return end
    local pid = player:getPlayerNum()
    local h = HorseRiding.getMountedHorse and HorseRiding.getMountedHorse(player)
    if h and h.isExistInTheWorld and h:isExistInTheWorld() then
        lastHorse[pid] = h
    end
end)

local function commandHorseTo(horse, tx, ty, tz)
    if not (horse and horse.isExistInTheWorld and horse:isExistInTheWorld()) then
        return
    end

    local z = tz or horse:getZ()

    if horse.getBehavior then horse:getBehavior():setBlockMovement(false) end
    if horse.stopAllMovementNow then horse:stopAllMovementNow() end
    if horse.getPathFindBehavior2 then horse:getPathFindBehavior2():reset() end

    local ad = horse.getData and horse:getData() or nil
    local attachedPlayer = ad and ad.getAttachedPlayer and ad:getAttachedPlayer() or nil
    if attachedPlayer and attachedPlayer.getAttachedAnimals and ad then
        attachedPlayer:getAttachedAnimals():remove(horse)
        ad:setAttachedPlayer(nil)
    end

    local pfb = horse.getPathFindBehavior2 and horse:getPathFindBehavior2() or nil
    local ok = false
    if pfb and pfb.pathToLocationF then
        pfb:pathToLocationF(tx + 0.5, ty + 0.5, z)
        ok = true
    elseif horse.pathToLocation then
        horse:pathToLocation(tx, ty, z)
        ok = true
    end

    if horse.setVariable then
        horse:setVariable("bPathfind", ok)
        horse:setVariable("animalWalking", true)
        horse:setVariable("animalRunning", false)
    end
end

local function logHorseTarget(horse)
    local pfb = horse:getPathFindBehavior2()
    if pfb then
        print("Should move: ", pfb:shouldBeMoving())
        print(
            pfb:getTargetX(), pfb:getTargetY(), pfb:getTargetZ()
        )
    else
        print("Horse is not currently pathing.")
    end
end

local lookaroundDir = 0

Events.OnKeyPressed.Add(function(key)
    local player = getSpecificPlayer(0)
    local horse = HorseRiding.getMountedHorse and HorseRiding.getMountedHorse(player)
    if not player then return end
    local debugChunkState = DebugChunkState.checkInstance();
    -- if not (horse and horse:isExistInTheWorld()) then
    --     horse = lastHorse[player:getPlayerNum()]
    -- end
    if key ~= Keyboard.KEY_G then return end
        print("Horse: ", horse)
        horse:setAttachedItem("ManeTop", instanceItem("HorseMod.HorseBackpack"))
        horse:setAttachedItem("ManeMid", instanceItem("HorseMod.HorseBackpack"))
        horse:setAttachedItem("ManeBottom", instanceItem("HorseMod.HorseBackpack"))
    -- player:setIgnoreAimingInput(false)
        -- player:setHeadLookAround(true)
        -- -- print("lookaroundDir: ", lookaroundDir)
        -- player:setHeadLookAroundDirection(lookaroundDir + 90, lookaroundDir + 135)
        -- lookaroundDir = lookaroundDir + 20
        -- if currentOffset then
        --     -- Restore original camera position by dragging back.
        --     debugChunkState:fromLua2('dragCamera', -currentOffset.dx, -currentOffset.dy)
        --     currentOffset = nil
        -- else
        --     -- Calculate the offset for shifting the camera to the left.
        --     local zoom = HorseUtils.calculateCurrentZoom()
        --     local sw = core:getScreenWidth()
        --     local dx, dy = HorseUtils.toIsoPlayerRelative((-sw / 4.0) * zoom, 0)
        --     debugChunkState:fromLua2('dragCamera', dx, dy)
        --     currentOffset = {dx = dx, dy = dy}
        -- end
        -- local horseData = horse:getData()
        -- local sq = player:getCurrentSquare()
        -- local objs = sq:getObjects()
        -- if objs then
        --     for i=0, objs:size()-1 do
        --         local o = objs:get(i)
        --         print("Object: ", o:getSpriteName())
        --         if o:getSpriteName() == "lighting_outdoor_01_3" then
        --             sq:AddSpecialObject(o)
        --             horseData:setAttachedTree(o)              -- maintain the field locally
        --             player:removeAttachedAnimal(horse)
        --             horseData:setAttachedPlayer(nil)
        --             sendAttachAnimalToTree(horse, player, o, false) -- sends the network packet
        --         end
        --     end
        -- end
        -- print("Attached Tree: ", horseData:getAttachedTree())
        -- local itemVisuals = horse:getItemVisuals()
        -- print("itemVisuals: ", itemVisuals)
        -- local itemVisual = ItemVisual.new()
        -- itemVisual:setItemType("Hat_Bandana") -- <itemType> is the clothing item ID in the script
        -- itemVisual:setClothingItemName("Hat_Bandana")

        -- -- append the ArrayList with the new ItemVisual
        -- itemVisuals:add(itemVisual)

        -- reset the model to apply the changes
        -- local emitter = horse:getEmitter()
        -- local ref = horse:getAnimalSoundState("hoof"):getEventInstance()
        -- emitter:setVolume(ref, 0.01)
        -- emitter:stopAll()
        -- emitter:stopOrTriggerSoundByName("HorseGallopConcrete")
        -- local sound = emitter:playSound('HorseWalkConcrete')
        -- print("Sound: ", sound)
        -- local epsilon = math.rad(1)              -- 1° bias to break the tie
        -- local base    = horse:getDirectionAngle()         -- current facing

        -- -- choose +179° (clockwise) or –179° (counter‑clockwise)
        -- local target  = base + (true and (math.pi - epsilon)
        --                                 or -(math.pi - epsilon))
        -- local animplayer = horse:getAnimationPlayer()
        -- print("Animplayer: ", animplayer)
        -- animplayer:setTargetAngle(target)
    if key == Keyboard.KEY_H then
        -- print("animset: ", horse:GetAnimSetName())
        -- print("Twist: ", player:getTargetTwist())
    end
    -- -- commandHorseTo(horse, DEST_X, DEST_Y, 0)
    -- local Seat = require("HorseMod/HorseSeat")
    -- -- seat 1 near the player within 2 tiles:
    -- Seat.seatLastMountedHorseSeat1(getSpecificPlayer(0))

end)
