local Class = require("trip.Class")
local Creature = require("trip.Creature")
local KeyboardMouseDevice = require("trip.KeyboardMouseDevice")
local Player = require("trip.Player")
local physics = require("trip.physics")

local M = Class.new()

function M:init(resources, config)
  self.fixedDt = config.fixedDt or 1 / 60
  self.accumulatedDt = 0

  self.accumulatedMouseDx = 0
  self.accumulatedMouseDy = 0

  local gravityX = config.gravityX or 0
  local gravityY = config.gravityY or 16

  self.world = love.physics.newWorld(gravityX, gravityY)

  self.body = love.physics.newBody(self.world)
  local shape = love.physics.newRectangleShape(0, 2, 8, 0.5)
  self.fixture = love.physics.newFixture(self.body, shape)

  self.creatures = {}
  self.keyboardMouseDevices = {}
  self.players = {}

  local creature = Creature.new(self, {
    x = 0,
    y = -2,
  })

  local inputDevice = KeyboardMouseDevice.new(self, {})
  Player.new(creature, inputDevice, {})
end

function M:update(dt)
  self.accumulatedDt = self.accumulatedDt + dt

  while self.accumulatedDt >= self.fixedDt do
    self.accumulatedDt = self.accumulatedDt - self.fixedDt
    self:fixedUpdate(self.fixedDt)
  end
end

function M:fixedUpdate(dt)
  for _, player in ipairs(self.players) do
    player:fixedUpdateInput(dt)
  end

  for _, creature in ipairs(self.creatures) do
    creature:fixedUpdateControl(dt)
  end

  self.world:update(dt)

  for _, creature in ipairs(self.creatures) do
    creature:fixedUpdateCollision(dt)
  end
end

function M:draw()
  local width, height = love.graphics.getDimensions()
  love.graphics.translate(0.5 * width, 0.5 * height)
  local scale = height * 1 / 8
  love.graphics.scale(scale)
  love.graphics.setLineWidth(1 / scale)

  physics.debugDrawFixtures(self.world)
  physics.debugDrawJoints(self.world)
end

function M:mousemoved(x, y, dx, dy, istouch)
  self.accumulatedMouseDx = self.accumulatedMouseDx + dx
  self.accumulatedMouseDy = self.accumulatedMouseDy + dy
end

return M
