local Class = require("trip.Class")

local M = Class.new()

function M:init(engine, config)
  self.engine = assert(engine)

  self.body = love.physics.newBody(self.engine.world)
  local shape = love.physics.newCircleShape(0.5)
  self.fixture = love.physics.newFixture(self.body, shape)
end

function M:destroy()
  self.fixture:destroy()
  self.fixture = nil

  self.body:destroy()
  self.body = nil
end

return M
