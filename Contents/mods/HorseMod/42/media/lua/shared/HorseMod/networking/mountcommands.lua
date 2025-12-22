---@namespace HorseMod

local commands = require("HorseMod/networking/commands")

local mountcommands = {}

---@class MountArguments
---@field character integer
---@field animal integer

---@class DismountArguments
---@field character integer

mountcommands.Mount = commands.registerServerCommand--[[@<MountArguments>]]("Mount")
mountcommands.Dismount = commands.registerServerCommand--[[@<DismountArguments>]]("Dismount")

return mountcommands