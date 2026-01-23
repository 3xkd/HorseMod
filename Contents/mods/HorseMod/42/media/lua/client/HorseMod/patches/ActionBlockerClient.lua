---REQUIREMENTS
local Mounts = require("HorseMod/Mounts")

local ActionBlocker = require("HorseMod/patches/ActionBlocker")

--[[
This patch prevents players from performing certain timed actions while mounted on a horse.
]]
local ActionBlockerClient = {}

ActionBlockerClient.addAfter = ISTimedActionQueue.addAfter
function ISTimedActionQueue.addAfter(action, after)
    if not ActionBlocker.validActions[action.Type] then
        if Mounts.hasMount(action.character) then
            return
        end
    end
    ActionBlockerClient.addAfter(action, after)
end

ActionBlockerClient.add = ISTimedActionQueue.add
function ISTimedActionQueue.add(action)
    if action and not ActionBlocker.validActions[action.Type] then
        if Mounts.hasMount(action.character) then
            return
        end
    end
    ActionBlockerClient.add(action)
end

return ActionBlockerClient