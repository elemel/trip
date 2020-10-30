local Class = require("trip.Class")
local LimbSensorState = require("trip.LimbSensorState")
local tripTable = require("trip.table")

local insert = table.insert
local removeLast = tripTable.removeLast

local M = Class.new()

function M:init(creature, config)
  self.creature = assert(creature)
  self.engine = assert(creature.engine)

  self.localSocketX = config.localSocketX or 0
  self.localSocketY = config.localSocketY or 0

  self.localPawX = config.localPawX or self.localSocketX
  self.localPawY = config.localPawY or self.localSocketY

  insert(self.creature.limbs, self)
  self.state = LimbSensorState.new(self, {})
end

function M:destroy()
  self.state:destroy()
  self.state = nil

  removeLast(self.creature.limbs, self)
end

return M
