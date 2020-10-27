local Engine = require("trip.Engine")

function love.load(arg)
  local resources = {}
  engine = Engine.new(resources, {})
end

function love.update(dt)
  engine:update(dt)
end

function love.draw()
  engine:draw()
end
