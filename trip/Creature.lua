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

  local angle = love.math.random() * 2 * pi

  self.body = love.physics.newBody(self.engine.world, x, y, "dynamic")
  self.body:setAngle(angle)

  self.radius = config.radius or 0.5
  local shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, shape)

  self.limbs = {}

  for i = 1, 5 do
    local angle = (i + love.math.random()) * 2 * pi / 5

    local directionX = cos(angle)
    local directionY = sin(angle)

    Limb.new(self, {
      localSocketX = directionX * self.radius,
      localSocketY = directionY * self.radius,

      localPawX = directionX * 2 * self.radius,
      localPawY = directionY * 2 * self.radius,
    })
  end

  self.aimInputDx = 0
  self.aimInputDy = 0

  self.moveInputX = 0
  self.moveInputY = 0

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
  for _, limb in ipairs(self.limbs) do
    limb.state:fixedUpdateControl(dt)
  end
end

function M:fixedUpdateCollision(dt)
  for _, limb in ipairs(self.limbs) do
    limb.state:fixedUpdateCollision(dt)
  end
end

return M
