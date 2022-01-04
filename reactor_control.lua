local term = require("term")
local component = require("component")
local reactor = component.reactor_chamber
local gpu = component.gpu

local WIDTH, HEIGHT = gpu.getResolution()

local BG_COLOR = 0x4B0082
local TEXT_COLOR = 0xFFD700
local MAX_HEAT = reactor.getMaxHeat()

local CHUNK_SIZE = 10

gpu.setBackground(BG_COLOR)
gpu.setForeground(TEXT_COLOR)

gpu.fill(1, 1, WIDTH, HEIGHT, " ")
gpu.set(6, 4, "REACTOR TEMPERATURE:")

function DrawChunk(value, max_value)
  ratio = value / max_value

  gpu.set(27, 4, value / 1.6 .. "T / " .. max_value / 1.6 .. "T [" .. 100 * ratio .. "%]")  
  
  gpu.setBackground(0x888888)
  gpu.fill(5, 5, WIDTH - 10, CHUNK_SIZE, " ")

  gpu.setBackground(0x4B0000)
  gpu.fill(5, 5, WIDTH * ratio - 10, CHUNK_SIZE, " ")
end

while true do
  current_heat = reactor.getHeat()
  
  DrawChunk(current_heat, MAX_HEAT)
  gpu.setBackground(BG_COLOR)
end
