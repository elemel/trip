local Engine = require("trip.Engine")

function love.load(arg)
  love.physics.setMeter(1)

  love.event.pump() -- Prevent freeze in LÖVE 11.3
  love.mouse.setRelativeMode(true)

  local resources = {}
  engine = Engine.new(resources, {})
end

function love.update(dt)
  engine:update(dt)
end

function love.draw()
  engine:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
  engine:mousemoved(x, y, dx, dy, istouch)
end
