local sqrt = math.sqrt

local function distance2(x1, y1, x2, y2)
  return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
end

return {
  distance2 = distance2,
}
