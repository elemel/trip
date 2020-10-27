local function findLast(t, v)
  for i = #t, 1, -1 do
    if t[i] == v then
      return i
    end
  end

  return nil
end

local function removeLast(t, v)
  local i = findLast(t, v)

  if i then
    remove(t, i)
  end
end

return {
  findLast = findLast,
  removeLast = removeLast,
}
