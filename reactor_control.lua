local term = require("term")
local component = require("component")
local reactor = component.reactor_chamber
local gpu = component.gpu

local WIDTH, HEIGHT = gpu.getResolution()

local BG_COLOR = 0x4B0082
local TEXT_COLOR = 0xFFD700
local MAX_HEAT = reactor.getMaxHeat()

function DrawChunk(chunk_number, value, max_value, units)
  local CHUNK_SIZE = 10
  local ratio = value / max_value

  gpu.set(27, 4, value .. units .. " / " .. max_value .. units .. " [" .. 100 * ratio .. "%]")  
  
  gpu.setBackground(0x888888)
  gpu.fill(5, 5 + 2 * chunk_number * CHUNK_SIZE, WIDTH - 10, CHUNK_SIZE, " ")

  gpu.setBackground(0x4B0000)
  gpu.fill(5, 5 + 2 * chunk_number * CHUNK_SIZE, WIDTH * ratio - 10, CHUNK_SIZE, " ")
end

--------
--MAIN--
--------
gpu.setBackground(BG_COLOR)
gpu.setForeground(TEXT_COLOR)

gpu.fill(1, 1, WIDTH, HEIGHT, " ")
gpu.set(6, 4, "REACTOR TEMPERATURE:")

while true do
  local current_heat = reactor.getHeat()
  local current_chunk = 0
  
  DrawChunk(current_chunk, current_heat / 1.2, MAX_HEAT / 1.2, "T")
  gpu.setBackground(BG_COLOR)
end
