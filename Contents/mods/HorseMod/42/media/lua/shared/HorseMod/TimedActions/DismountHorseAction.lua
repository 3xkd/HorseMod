require("TimedActions/ISBaseTimedAction")

local AnimationVariable = require("HorseMod/AnimationVariable")
local Mounts = require("HorseMod/Mounts")


---@namespace HorseMod


---@class DismountHorseAction : ISBaseTimedAction
---
---@field character IsoPlayer
---
---@field animal IsoAnimal
---
---@field mount Mount
---
---@field mountPosition MountPosition
---
---@field hasSaddle boolean
local DismountHorseAction = ISBaseTimedAction:derive("HorseMod_DismountHorseAction")


---@return boolean
function DismountHorseAction:isValid()
    return self.animal:isExistInTheWorld()
end


function DismountHorseAction:update()
    -- keep the horse locked facing the stored direction
    local animal = self.animal
    animal:setDirectionAngle(self.lockDir)
    animal:getPathFindBehavior2():reset()

    -- complete when dismount is finished
    if self.character:getVariableBoolean(AnimationVariable.DISMOUNT_FINISHED) == true then
        self.character:setVariable(AnimationVariable.DISMOUNT_FINISHED, false)
        self:forceComplete()
    end
end


function DismountHorseAction:start()
    self.lockDir = self.animal:getDirectionAngle()
    self.character:setVariable(AnimationVariable.DISMOUNT_STARTED, true)

    -- start animation
    local actionAnim = ""
    if self.hasSaddle then
        actionAnim = "Bob_Dismount_Saddle_"
    else
        actionAnim = "Bob_Dismount_Bareback_"
    end

    actionAnim = actionAnim .. self.mountPosition.name
    self:setActionAnim(actionAnim)
end


function DismountHorseAction:stop()
    self.character:setVariable(AnimationVariable.DISMOUNT_STARTED, false)
    ISBaseTimedAction.stop(self)
end


function DismountHorseAction:complete()
    -- TODO: this might take a bit to inform the client, so we should consider faking it in perform()
    Mounts.removeMount(self.character)
    return true
end


function DismountHorseAction:perform()
    local mountPosition = self.mountPosition
    self.character:setX(mountPosition.x)
    self.character:setY(mountPosition.y)

    ISBaseTimedAction.perform(self)
end


function DismountHorseAction:getDuration()
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
function DismountHorseAction:new(character, animal, mountPosition, hasSaddle)
    ---@type DismountHorseAction
    local o = ISBaseTimedAction.new(self, character)

    o.character = character
    o.animal = animal
    o.mountPosition = mountPosition
    o.hasSaddle = hasSaddle
    o.stopOnWalk = true
    o.stopOnRun = true

    o.maxTime = o:getDuration()

    return o
end


_G[DismountHorseAction.Type] = DismountHorseAction


return DismountHorseAction