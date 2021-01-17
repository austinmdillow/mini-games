function drawDebugInfo()
  local start_x = FRAME_WIDTH - 80
  local fps = love.timer.getFPS()
  love.graphics.setColor(1,0,0)
  love.graphics.print("FPS " .. fps, start_x, 5)

end