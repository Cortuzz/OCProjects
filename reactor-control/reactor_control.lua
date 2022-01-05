local term = require("term")
local component = require("component")
local reactor = component.reactor_chamber
local note = require("note")
local transposer = component.transposer
thresholds = require("thresholds")
local gpu = component.gpu

local WIDTH, HEIGHT = gpu.getResolution()

local REACTOR_SIDE = 2
local CHUNK_SIZE = 8
local BG_COLOR = 0x4B0082
local TEXT_COLOR = 0xFFD700
local MAX_HEAT = reactor.getMaxHeat()

local COOLANT_CAPACITY = transposer.getFluidInTank(REACTOR_SIDE, 1).capacity
local HOT_COOLANT_CAPACITY = transposer.getFluidInTank(REACTOR_SIDE, 2).capacity

function drawChunk(chunk_number, value, max_value, text, units, color)
  local ratio = value / max_value
  local chunk_height = 5 + 1.5 * chunk_number * CHUNK_SIZE

  local information = text .. ": " .. value .. units .. " / " .. max_value .. units .. " [" .. 100 * ratio .. "%]"

  gpu.fill(5, chunk_height - 1, WIDTH - 10, 1, " ")
  gpu.set(5, chunk_height - 1, information)  
  
  gpu.setBackground(0x888888)
  gpu.fill(5, chunk_height, WIDTH - 10, CHUNK_SIZE, " ")

  gpu.setBackground(color)
  gpu.fill(5, chunk_height, WIDTH * ratio - 10, CHUNK_SIZE, " ")

  gpu.setBackground(BG_COLOR)
end

function drawScale(chunk_number, intervals)
  local chunk_height = CHUNK_SIZE + 4 + 1.5 * chunk_number * CHUNK_SIZE
  local color = nil
  local text = nil
  
  for index, value in pairs(intervals) do
    local threshold_position = value:getBorder() * WIDTH - 10
    
    local interval_color = value:getColor()

    if color then
      write(threshold_position + 1, chunk_height + 1, text, color)
    end

    gpu.setBackground(interval_color)
    gpu.fill(5, chunk_height, threshold_position, 1, " ")
  
    color = value:getTextColor()
    text = value:getText()
    gpu.setBackground(BG_COLOR)
  end
end

function write(first_position, second_position, text, color)
  gpu.setForeground(color)
  gpu.set(first_position, second_position, text)

  gpu.setForeground(TEXT_COLOR)
end

--------
--MAIN--
--------
gpu.setBackground(BG_COLOR)
gpu.setForeground(TEXT_COLOR)

gpu.fill(1, 1, WIDTH, HEIGHT, " ")

while true do
  local current_chunk = 0

  local current_heat = reactor.getHeat()
  local heat_ratio = current_heat / MAX_HEAT

  local coolant_level = transposer.getFluidInTank(REACTOR_SIDE, 1).amount
  local hot_coolant_level = transposer.getFluidInTank(REACTOR_SIDE, 2).amount
  
  drawChunk(current_chunk, current_heat / 1.6, MAX_HEAT / 1.6, "REACTOR TEMPERATURE", "T", 0xF0E68C)
  drawScale(current_chunk, temperature_control)

  drawChunk(1, coolant_level, COOLANT_CAPACITY, "COOLANT LEVEL", "mB", 0x008B8B)
  drawScale(1, coolant_control)
  
  --0xDC143C
  drawChunk(2, hot_coolant_level, HOT_COOLANT_CAPACITY, "HOT COOLANT LEVEL", "mB", 0xB22222)
  drawScale(2, hot_coolant_control)

  --write(40, 40, reactor.getReactorEUOutput() .. "", 0xB22222)
  --write(40, 41, reactor.getReactorEnergyOutput() .. "", 0xB22222)
end
