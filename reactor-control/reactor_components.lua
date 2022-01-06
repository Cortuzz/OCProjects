local component = require("component")
local transposer = component.transposer
local gpu = component.gpu

local WIDTH, HEIGHT = gpu.getResolution()
local REACTOR_SIDE = 2
local CHUNK_SIZE = 5

local FACTOR = CHUNK_SIZE + 1

local BG_COLOR = 0x483D8B
local TEXT_COLOR = 0xFFD700

local REACTOR_WIDTH = 9
local REACTOR_HEIGHT = 6

local DELTA_Y = 3
local DELTA_X = 17


function drawChunk(x_coord, y_coord, color)
  gpu.setBackground(color)
  gpu.fill(x_coord, y_coord, 2 * CHUNK_SIZE, CHUNK_SIZE, " ")

  gpu.setBackground(BG_COLOR)
end


function materialsColoring(materials)
  for index, material in pairs(materials) do
    local name = material.name

    if name == "minecraft:air" then
      materials[index].color = 0xC0C0C0

    elseif string.find(name, "fuel") then
      materials[index].color = 0x4B0082

    else
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
gpu.setForeground(TEXT_COLOR)

gpu.fill(1, 1, WIDTH, HEIGHT, " ")

while true do
  local data = transposer.getAllStacks(REACTOR_SIDE).getAll()
  materialsColoring(data)

  for i=1, REACTOR_WIDTH do
    for j=1, REACTOR_HEIGHT do
      local pos_x = DELTA_X + 2 * FACTOR * i
      local pos_y = DELTA_Y + FACTOR * j

      drawChunk(pos_x, pos_y, data[i + (j - 1) * REACTOR_WIDTH].color)
    end
  end
end
