function table_count(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end