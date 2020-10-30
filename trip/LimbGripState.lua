local Class = require("trip.Class")

local cos = math.cos
local insert = table.insert
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

    local localX1 = cos(anchorAngle) * self.creature.radius
    local localY1 = sin(anchorAngle) * self.creature.radius

    local x1, y1 = self.creature.body:getWorldPoint(localX1, localY1)

    local distanceJoint = love.physics.newDistanceJoint(
      self.creature.body, targetBody, x1, y1, pawX, pawY, true)

    distanceJoint:setFrequency(8)
    distanceJoint:setDampingRatio(1)

    insert(self.distanceJoints, distanceJoint)
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
