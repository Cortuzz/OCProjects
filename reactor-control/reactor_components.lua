local component = require("component")
local transposer = component.transposer
local gpu = component.gpu

local WIDTH, HEIGHT = gpu.getResolution()
local REACTOR_SIDE = 2
local CHUNK_SIZE = 5

local FACTOR = CHUNK_SIZE + 1

local BG_COLOR = 0x483D8B

local REACTOR_WIDTH = 9
local REACTOR_HEIGHT = 6

--3, 7 for chunksize 5
local DELTA_Y = 3
local DELTA_X = 7

local FUEL_COLOR = 0x4B0082

function drawChunk(x_coord, y_coord, color, is_fuel)
  if is_fuel then
    gpu.setBackground(FUEL_COLOR)
    gpu.fill(x_coord, y_coord, 2 * CHUNK_SIZE, CHUNK_SIZE, " ")

    gpu.setBackground(color)
    gpu.fill(x_coord + 2, y_coord + 1, 2 * CHUNK_SIZE - 4, CHUNK_SIZE - 2, " ")    

    gpu.setBackground(FUEL_COLOR)
    gpu.fill(x_coord + 4, y_coord + 2, 2 * CHUNK_SIZE - 8, CHUNK_SIZE - 4, " ")
  else
    gpu.setBackground(color)
    gpu.fill(x_coord, y_coord, 2 * CHUNK_SIZE, CHUNK_SIZE, " ")
  end

  gpu.setBackground(BG_COLOR)
end


function materialsColoring(materials)
  for index, material in pairs(materials) do
    local name = material.name

    if name == "minecraft:air" then
      materials[index].color = 0xC0C0C0

    else
      if string.find(name, "fuel") then
        materials[index].fuel = true
      end

      local damage_ratio = material.damage / material.maxDamage
    
      if damage_ratio < 0.2 then
        materials[index].color = 0x006400

      elseif damage_ratio < 0.5 then
        materials[index].color = 0xFFD700

      elseif damage_ratio < 0.7 then
        materials[index].color = 0xFF8C00

      elseif damage_ratio < 0.85 then
        materials[index].color = 0xFF4500

      elseif damage_ratio < 0.95 then
        materials[index].color = 0xDC143C

      else
        materials[index].color = 0x800000
      end
    end
  end
end


--------
--MAIN--
--------

gpu.setBackground(BG_COLOR)

gpu.fill(1, 1, WIDTH, HEIGHT, " ")

while true do
  local data = transposer.getAllStacks(REACTOR_SIDE).getAll()
  materialsColoring(data)

  for i=1, REACTOR_WIDTH do
    for j=1, REACTOR_HEIGHT do
      local pos_x = DELTA_X + 2 * FACTOR * i
      local pos_y = DELTA_Y + FACTOR * j
      
      local current_chunk = data[i + (j - 1) * REACTOR_WIDTH]

      drawChunk(pos_x, pos_y, current_chunk.color, current_chunk.fuel)
    end
  end
end
