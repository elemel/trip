local Class = require("trip.Class")
local tripMath = require("trip.math")

local cos = math.cos
local distance2 = tripMath.distance2
local pi = math.pi
local sin = math.sin

local M = Class.new()

function M:init(limb, config)
  self.limb = assert(limb)
  self.creature = assert(self.limb.creature)
  self.engine = assert(self.creature.engine)

  local x, y = self.creature.body:getWorldPoint(self.limb.localPawX, self.limb.localPawY)
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

function M:fixedUpdateControl(dt)
  local dx, dy = self.creature.body:getLocalVector(self.creature.aimInputDx, self.creature.aimInputDy)

  self.limb.localPawX = self.limb.localPawX + dx
  self.limb.localPawY = self.limb.localPawY + dy

  local pawX, pawY = self.creature.body:getWorldPoint(self.limb.localPawX, self.limb.localPawY)

  for _, joint in ipairs(self.distanceJoints) do
    local anchorX, anchorY = joint:getAnchors()
    length = distance2(anchorX, anchorY, pawX, pawY)
    joint:setLength(length)
    self.body:setAwake(true)
  end
end

function M:fixedUpdateCollision(dt)
  local x1, y1 = self.creature.body:getWorldPoint(
    self.limb.localSocketX, self.limb.localSocketY)

  local x2, y2 = self.body:getPosition()

  if distance2(x1, y1, x2, y2) == 0 then
    return
  end

  local intersectionFixture, intersectionX, intersectionY

  local function callback(fixture, x, y, xn, yn, fraction)
    if fixture:getBody():getType() ~= "static" then
      return 1
    end

    intersectionFixture = fixture

    intersectionX = x
    intersectionY = y

    return fraction
  end

  self.engine.world:rayCast(x1, y1, x2, y2, callback)

  if intersectionFixture then
    self.limb.localPawX, self.limb.localPawY =
      self.creature.body:getLocalPoint(intersectionX, intersectionY)

    local LimbGripState = require("trip.LimbGripState")
    self.limb.state = LimbGripState.new(self.limb, intersectionFixture, {})
    self:destroy()
    return
  end
end

return M
