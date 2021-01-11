function drawDebugInfo()
  local start_x = FRAME_WIDTH - 200
  local fps = love.timer.getFPS()
  love.graphics.setColor(1,0,0)
  love.graphics.print(fps, start_x, 20)

end