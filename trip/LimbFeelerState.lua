local Class = require("trip.Class")

local cos = math.cos
local pi = math.pi
local sin = math.sin

local M = Class.new()

function M:init(limb, config)
  self.limb = assert(limb)
  self.creature = assert(self.limb.creature)
  self.engine = assert(self.creature.engine)

  local x, y = self.creature.body:getWorldPoint(self.limb.localX, self.limb.localY)
  self.body = love.physics.newBody(self.engine.world, x, y, "dynamic")
  self.body:setFixedRotation(true)

  local shape = love.physics.newCircleShape(0.125)
  self.fixture = love.physics.newFixture(self.body, shape)
  self.fixture:setSensor(true)

  local baseAngle = love.math.random() * 2 * pi
  self.distanceJoints = {}

  for i = 1, 3 do
    local anchorAngle = baseAngle + i * 2 * pi / 3

    local x1 = cos(anchorAngle) * self.creature.radius
    local y1 = sin(anchorAngle) * self.creature.radius

    x1, y1 = self.creature.body:getWorldPoint(x1, y1)

    self.distanceJoints[i] = love.physics.newDistanceJoint(
      self.creature.body, self.body, x1, y1, x, y)

    self.distanceJoints[i]:setFrequency(8)
    self.distanceJoints[i]:setDampingRatio(1)
  end
end

function M:destroy()
  for i = #self.distanceJoints, 1, -1 do
    self.distanceJoints[i]:destroy()
    self.distanceJoints[i] = nil
  end

  self.fixture:destroy()
  self.fixture = nil

  self.body:destroy()
  self.body = nil
end

return M
