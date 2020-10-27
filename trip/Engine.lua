local Class = require("trip.Class")
local Creature = require("trip.Creature")
local physics = require("trip.physics")

local M = Class.new()

function M:init(resources, config)
  self.fixedDt = config.fixedDt or 1 / 60
  self.accumulatedDt = 0

  local gravityX = config.gravityX or 0
  local gravityY = config.gravityY or 16

  self.world = love.physics.newWorld(gravityX, gravityY)

  self.body = love.physics.newBody(self.world)
  local shape = love.physics.newRectangleShape(0, 2, 8, 0.5)
  self.fixture = love.physics.newFixture(self.body, shape)

  Creature.new(self, {
    x = 0,
    y = -2,
  })
end

function M:update(dt)
  self.accumulatedDt = self.accumulatedDt + dt

  while self.accumulatedDt >= self.fixedDt do
    self.accumulatedDt = self.accumulatedDt - self.fixedDt
    self:fixedUpdate(self.fixedDt)
  end
end

function M:fixedUpdate(dt)
  self.world:update(dt)
end

function M:draw()
  local width, height = love.graphics.getDimensions()
  love.graphics.translate(0.5 * width, 0.5 * height)
  local scale = height * 1 / 8
  love.graphics.scale(scale)
  love.graphics.setLineWidth(1 / scale)
  physics.debugDrawFixtures(self.world)

end

return M
