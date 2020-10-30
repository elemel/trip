local sqrt = math.sqrt

local function length2(x, y)
  return sqrt(x * x + y * y)
end

local function distance2(x1, y1, x2, y2)
  return length2(x2 - x1, y2 - y1)
end

return {
  distance2 = distance2,
  length2 = length2,
}
