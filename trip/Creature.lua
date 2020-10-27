local Class = require("trip.Class")
local Limb = require("trip.Limb")

local cos = math.cos
local pi = math.pi
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

    local x = cos(angle)
    local y = sin(angle)

    Limb.new(self.engine, self, {
      x = x,
      y = y,
    })
  end
end

function M:destroy()
  for i = #self.limbs, 1, -1 do
    self.limbs[i]:destroy()
  end

  self.fixture:destroy()
  self.fixture = nil

  self.body:destroy()
  self.body = nil
end

return M
