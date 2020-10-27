local M = {}

function M.debugDrawFixtures(world)
  for _, body in ipairs(world:getBodies()) do
    local angle = body:getAngle()

    for _, fixture in ipairs(body:getFixtures()) do
      local shape = fixture:getShape()
      local shapeType = shape:getType()

      if shapeType == "chain" then
        love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))

        local previousX, previousY = body:getWorldPoint(
          shape:getPreviousVertex())

        local firstX, firstY = body:getWorldPoint(shape:getPoint(1))

        local lastX, lastY = body:getWorldPoint(
          shape:getPoint(shape:getVertexCount()))

        local nextX, nextY = body:getWorldPoint(shape:getNextVertex())

        love.graphics.line(previousX, previousY, firstX, firstY)
        love.graphics.line(lastX, lastY, nextX, nextY)
      elseif shapeType == "circle" then
        local x, y = body:getWorldPoint(shape:getPoint())
        local radius = shape:getRadius()
        love.graphics.circle("line", x, y, radius)
        local directionX, directionY = body:getWorldVector(1, 0)

        love.graphics.line(
          x, y, x + directionX * radius, y + directionY * radius)
      elseif shapeType == "polygon" then
        love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
      end
    end
  end
end

function M.debugDrawJoints(world)
  for _, joint in ipairs(world:getJoints()) do
    love.graphics.line(joint:getAnchors())
  end
end

return M
