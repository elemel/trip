local Class = require("trip.Class")
local Limb = require("trip.Limb")
local tripMath = require("trip.math")
local tripTable = require("trip.table")

local cos = math.cos
local distance2 = tripMath.distance2
local insert = table.insert
local pi = math.pi
local removeLast = tripTable.removeLast
local sin = math.sin

local M = Class.new()

function M:init(engine, config)
  self.engine = assert(engine)

  local x = config.x or 0
  local y = config.y or 0

  self.body = love.physics.newBody(self.engine.world, x, y, "dynamic")

  self.radius = config.radius or 0.5
  local shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, shape)

  self.limbs = {}

  for i = 1, 5 do
    local angle = (i + love.math.random()) * 2 * pi / 5

    local localX = cos(angle)
    local localY = sin(angle)

    Limb.new(self, {
      localX = localX,
      localY = localY,
    })
  end

  insert(self.engine.creatures, self)
end

function M:destroy()
  removeLast(self.engine.creatures, self)

  for i = #self.limbs, 1, -1 do
    self.limbs[i]:destroy()
  end

  self.fixture:destroy()
  self.fixture = nil

  self.body:destroy()
  self.body = nil
end

function M:fixedUpdateControl(dt)
  local mouseSensitivity = 1 / 256

  local dx = self.engine.accumulatedMouseDx
  local dy = self.engine.accumulatedMouseDy

  self.engine.accumulatedMouseDx = 0
  self.engine.accumulatedMouseDy = 0

  dx = dx * mouseSensitivity
  dy = dy * mouseSensitivity

  dx, dy = self.body:getLocalVector(dx, dy)

  local limb = self.limbs[1]

  limb.localTargetX = limb.localTargetX + dx
  limb.localTargetY = limb.localTargetY + dy

  local targetX, targetY = self.body:getWorldPoint(limb.localTargetX, limb.localTargetY)

  for _, joint in ipairs(limb.state.distanceJoints) do
    local anchorX, anchorY = joint:getAnchors()
    length = distance2(anchorX, anchorY, targetX, targetY)
    joint:setLength(length)
    limb.state.body:setAwake(true)
  end
end

return M
