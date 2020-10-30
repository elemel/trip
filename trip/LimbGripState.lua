local Class = require("trip.Class")

local cos = math.cos
local pi = math.pi
local sin = math.sin

local M = Class.new()

function M:init(limb, targetFixture, config)
  self.limb = assert(limb)
  self.targetFixture = assert(targetFixture)
  self.creature = assert(self.limb.creature)
  self.engine = assert(self.creature.engine)

  local targetBody = targetFixture:getBody()

  local pawX, pawY = self.creature.body:getWorldPoint(
    self.limb.localPawX, self.limb.localPawY)

  local baseAngle = love.math.random() * 2 * pi
  self.distanceJoints = {}

  for i = 1, 3 do
    local anchorAngle = baseAngle + i * 2 * pi / 3

    local x1 = cos(anchorAngle) * self.creature.radius
    local y1 = sin(anchorAngle) * self.creature.radius

    x1, y1 = self.creature.body:getWorldPoint(x1, y1)

    self.distanceJoints[i] = love.physics.newDistanceJoint(
      self.creature.body, targetBody, x1, y1, pawX, pawY, true)

    self.distanceJoints[i]:setFrequency(8)
    self.distanceJoints[i]:setDampingRatio(1)
  end
end

function M:destroy()
  for i = #self.distanceJoints, 1, -1 do
    self.distanceJoints[i]:destroy()
    self.distanceJoints[i] = nil
  end
end

function M:fixedUpdateControl(dt)
end

function M:fixedUpdateCollision(dt)
end

return M
