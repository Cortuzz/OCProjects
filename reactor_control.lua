local term = require("term")
local component = require("component")
local reactor = component.reactor_chamber
local note = require("note")
local gpu = component.gpu

local WIDTH, HEIGHT = gpu.getResolution()

local WARNING_LEVEL = 0.75
local CRITICAL_LEVEL = 0.95

local CHUNK_SIZE = 8
local BG_COLOR = 0x4B0082
local TEXT_COLOR = 0xFFD700
local MAX_HEAT = reactor.getMaxHeat()

function drawChunk(chunk_number, value, max_value, units)
  local ratio = value / max_value
  local chunk_height = 5 + 2 * chunk_number * CHUNK_SIZE

  gpu.set(27, 4, value .. units .. " / " .. max_value .. units .. " [" .. 100 * ratio .. "%]")  
  
  gpu.setBackground(0x888888)
  gpu.fill(5, chunk_height, WIDTH - 10, CHUNK_SIZE, " ")

  gpu.setBackground(0x4B0000)
  gpu.fill(5, chunk_height, WIDTH * ratio - 10, CHUNK_SIZE, " ")

  gpu.setBackground(BG_COLOR)
end

function drawScale(chunk_number, first_threshold, second_threshold)
  local chunk_height = CHUNK_SIZE + 4 + 2 * chunk_number * CHUNK_SIZE

  local first_threshold_position = first_threshold * WIDTH - 10
  local second_threshold_position = second_threshold * WIDTH - 10

  write(first_threshold_position + 1, chunk_height + 1, "OVERHEAT", 0xFF8C00)
  write(second_threshold_position + 1, chunk_height + 1, "AUTO OFF", 0x8B0000)

  gpu.setBackground(0x8B0000)
  gpu.fill(5, chunk_height, WIDTH - 10, 1, " ")

  gpu.setBackground(0xFF8C00)
  gpu.fill(5, chunk_height, second_threshold_position, 1, " ")

  gpu.setBackground(0x006400)
  gpu.fill(5, chunk_height, first_threshold_position, 1, " ")

  gpu.setBackground(BG_COLOR)
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
gpu.set(6, 4, "REACTOR TEMPERATURE:")

while true do
  local current_chunk = 0
  local current_heat = reactor.getHeat()
  local heat_ratio = current_heat / MAX_HEAT

  if heat_ratio > WARNING_LEVEL and heat_ratio < CRITICAL_LEVEL then
    note.play(83, 1.05 - heat_ratio)
  end
  
  if heat_ratio > CRITICAL_LEVEL then
    note.play(83, 0.2)
    note.play(88, 0.25)
  end
  
  drawChunk(current_chunk, current_heat / 1.6, MAX_HEAT / 1.6, "T")
  drawScale(current_chunk, WARNING_LEVEL, CRITICAL_LEVEL)
end
