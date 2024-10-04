local component = require("component")
local gpu = component.gpu
local debug = component.debug

local players = debug.getPlayers()

local WIDTH, HEIGHT = gpu.getResolution()
local GPU_CENTRE_X = WIDTH / 2
local GPU_CENTRE_Y = HEIGHT / 2

local CHUNK_SIZE = 8
local CENTRE_COORDINATE_X = 50
local CENTRE_COORDINATE_Z = 900

local BG_COLOR = 0x4B0082


function checkOutOfScreen(coordinate, max_coordinate)
  if coordinate > max_coordinate then
    coordinate = max_coordinate

  elseif coordinate < 1 then
    coordinate = 1
  end

  return coordinate
end


function getNativePosition(pos_x, pos_z)
  local dif_z = pos_z - CENTRE_COORDINATE_Z
  local dif_x = pos_x - CENTRE_COORDINATE_X

  local native_x = dif_x / CHUNK_SIZE + GPU_CENTRE_X
  local native_y = dif_z / CHUNK_SIZE + GPU_CENTRE_Y

  native_x = checkOutOfScreen(native_x, WIDTH)
  native_y = checkOutOfScreen(native_y, HEIGHT)

  return native_x, native_y
end


function drawPlayer(player_position_x, player_position_z)
  local native_x, native_y = getNativePosition(player_position_x, player_position_z)

  gpu.setBackground(0x888888)
  gpu.fill(native_x, native_y, 2, 1, " ")
  gpu.setBackground(BG_COLOR)
end


function checkName(name)
  if not name or name == 1 then
    return false
  end

  return true
end


gpu.setBackground(BG_COLOR)

while true do
  gpu.fill(1, 1, WIDTH, HEIGHT, " ")

  for index, nickname in pairs(players) do
    if not checkName(nickname) then
      break
    end

    local player_data = debug.getPlayer(nickname)
    local x, y, z = player_data.getPosition()

    drawPlayer(x, z)
  end
    os.sleep(1)
end
