local Class = require("trip.Class")
local tripMath = require("trip.math")
local tripTable = require("trip.table")

local insert = table.insert
local removeLast = tripTable.removeLast

local M = Class.new()

function M:init(creature, inputDevice, config)
  self.creature = assert(creature)
  self.inputDevice = assert(inputDevice)
  self.engine = assert(creature.engine)

  insert(self.engine.players, self)
end

function M:destroy()
  removeLast(self.engine.players, self)
  self.engine = nil
end

function M:fixedUpdateInput(dt)
  local mouseSensitivity = 1 / 256

  local mouseDx = self.engine.accumulatedMouseDx
  local mouseDy = self.engine.accumulatedMouseDy

  self.engine.accumulatedMouseDx = 0
  self.engine.accumulatedMouseDy = 0

  self.creature.aimInputDx = mouseDx * mouseSensitivity
  self.creature.aimInputDy = mouseDy * mouseSensitivity

  self.creature.moveInputX, self.creature.moveInputY =
    self.inputDevice:getMoveInput()
end

return M
