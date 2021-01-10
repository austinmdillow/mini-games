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
end
