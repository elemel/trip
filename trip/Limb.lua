local Class = require("trip.Class")
local LimbFeelerState = require("trip.LimbFeelerState")
local tripTable = require("trip.table")

local insert = table.insert
local removeLast = tripTable.removeLast

local M = Class.new()

function M:init(creature, config)
  self.creature = assert(creature)
  self.engine = assert(creature.engine)

  self.localX = config.localX or 0
  self.localY = config.localY or 0

  self.localTargetX = 0
  self.localTargetY = 0

  insert(self.creature.limbs, self)

  self.state = LimbFeelerState.new(self, {})
end

function M:destroy()
  self.state:destroy()
  self.state = nil

  removeLast(self.creature.limbs, self)
end

return M
