require("TimedActions/ISBaseTimedAction")

local MountPair = require("HorseMod/MountPair")
local AnimationVariable = require("HorseMod/AnimationVariable")
local Mounts = require("HorseMod/Mounts")
local MountingUtility = require("HorseMod/mounting/MountingUtility")


---@namespace HorseMod


---@class MountHorseAction : ISBaseTimedAction
---
---@field character IsoPlayer
---
---@field animal IsoAnimal
---
---@field mountPosition MountPosition
---
---@field hasSaddle boolean
---
---@field lockDir number
local MountHorseAction = ISBaseTimedAction:derive("HorseMod_MountHorseAction")



function MountHorseAction:isValid()
    if self.animal:isExistInTheWorld()
        and self.character:getSquare() then
        
        -- verify the player can still mount the horse
        if MountingUtility.canMountHorse(self.character, self.animal) then
            return true
        end
        return false
    else
        return false
    end
end

function MountHorseAction:waitToStart()
    -- self.character:faceThisObject(self.mount)
    self.lockDir = self.animal:getDirectionAngle()
    self.character:setDirectionAngle(self.lockDir)
	return self.character:shouldBeTurning()
end


function MountHorseAction:update()
    -- fix the mount and rider to look in the same direction for animation alignment
    self.animal:setDirectionAngle(self.lockDir)
    
    local character = self.character
    character:setIsAiming(false)
    character:setDirectionAngle(self.lockDir)

    if character:getVariableBoolean(AnimationVariable.MOUNT_FINISHED) == true then
        character:setVariable(AnimationVariable.MOUNT_FINISHED, false)
        self:forceComplete()
    end
end


function MountHorseAction:start()
    self.animal:setVariable(AnimationVariable.DYING, false)

    self.character:setVariable(AnimationVariable.MOUNTING_HORSE, true)
    self.character:setVariable(AnimationVariable.MOUNT_FINISHED, false)
    self.character:setVariable(AnimationVariable.DYING, false)

    -- start animation
    local actionAnim = ""
    if self.hasSaddle then
        actionAnim = "Bob_Mount_Saddle_"
    else
        actionAnim = "Bob_Mount_Bareback_"
    end

    actionAnim = actionAnim .. self.mountPosition.name
    self:setActionAnim(actionAnim)
end


function MountHorseAction:stop()
    local pair = MountPair.new(self.character, self.animal)
    pair:setAnimationVariable(AnimationVariable.RIDING_HORSE, false)
    self.character:setVariable(AnimationVariable.MOUNTING_HORSE, false)
    self.character:setVariable("isTurningLeft", false)
    self.character:setVariable("isTurningRight", false)
    self.character:setTurnDelta(1)

    self.character:setVariable(AnimationVariable.MOUNTING_HORSE, false)

    ISBaseTimedAction.stop(self)
end


function MountHorseAction:complete()
    Mounts.addMount(self.character, self.animal)
    return true
end


function MountHorseAction:perform()
    -- HACK: we can't require this at file load because it is in the client dir
    local HorseSounds = require("HorseMod/HorseSounds")
    HorseSounds.playSound(self.animal, HorseSounds.Sound.MOUNT)

    ISBaseTimedAction.perform(self)
end


function MountHorseAction:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end

    return -1
end


---@param character IsoPlayer
---@param animal IsoAnimal
---@param mountPosition MountPosition
---@param hasSaddle boolean
---@return self
---@nodiscard
function MountHorseAction:new(character, animal, mountPosition, hasSaddle)
    ---@type MountHorseAction
    local o = ISBaseTimedAction.new(self, character)

    o.character = character
    o.animal = animal
    o.mountPosition = mountPosition
    o.hasSaddle = hasSaddle
    o.stopOnWalk = true
    o.stopOnRun  = true

    o.maxTime = o:getDuration()

    return o
end


_G[MountHorseAction.Type] = MountHorseAction


return MountHorseAction