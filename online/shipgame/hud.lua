local ping_fade = .1
local ping_fade_dir = 1
local ping_fade_rate = 1

function drawHUD()
  local start_x = 20
  local start_y = 20
  local health_width = 150
  local text_buffer = 15
  local bar_thickness = 20
  local shield_bar_y_offset = 30
  love.graphics.setColor(.8,.8,.8)
  love.graphics.rectangle('fill', 0, 0, 200, 100)
  love.graphics.setColor(COLORS.blue)
  if game_data.local_player.shield_enabled then
    love.graphics.print(string.format("%d / %d", game_data.local_player.shield_health, game_data.local_player.shield_max), start_x + health_width / 2 - 20, start_y + 4)
    love.graphics.rectangle('line', start_x, start_y, health_width * game_data.local_player.shield_health / game_data.local_player.shield_max, bar_thickness)
  end
  love.graphics.setColor(COLORS.red)
  love.graphics.print(string.format("%d / %d", game_data.local_player.current_health, game_data.local_player.max_health), start_x + health_width / 2 - 20, start_y + shield_bar_y_offset + 4)
  love.graphics.rectangle('line', start_x, start_y + shield_bar_y_offset, health_width * game_data.local_player.current_health / game_data.local_player.max_health, bar_thickness)

  love.graphics.print(string.format("Score: %d", game_data.score), start_x, start_y + shield_bar_y_offset * 2)

  drawRadar()
end

function updateHud(dt)
  ping_fade = ping_fade + ping_fade_dir * ping_fade_rate * dt
  if ping_fade_dir == 1 and ping_fade > 1 then
    ping_fade_dir = -1
  elseif ping_fade_dir == -1 and ping_fade < 0 then
    ping_fade_dir = 1
  end
end


function drawRadar()
  local radar_size = 100
  local zoom = 1/10
  local dot_size = 3 * 1 / zoom
  love.graphics.push() -- push #1
  love.graphics.translate(FRAME_WIDTH - radar_size, FRAME_HEIGHT - radar_size)
  love.graphics.setColor(COLORS.green)
  love.graphics.circle('fill', 0, 0, radar_size)

  love.graphics.push() -- push #2
  love.graphics.scale(.1)

  love.graphics.setColor(COLORS.blue)
  love.graphics.circle('fill', 0, 0, dot_size)

  love.graphics.setColor(COLORS.red[1], COLORS.red[2], COLORS.red[3], ping_fade)
  for idx, enemy in pairs(game_data.enemy_list) do
    if game_data.local_player.coord:distanceToCoord(enemy.coord) < radar_size / zoom - dot_size then -- make sure they will land inside the radar
      love.graphics.circle('fill', enemy:getX() - game_data.local_player:getX(), enemy:getY() - game_data.local_player:getY(), dot_size)
    end
  end
  love.graphics.pop() --POP #2
  love.graphics.pop() -- pop #1

end
