
COLORS = {
  red = {1, 0, 0},
  white = {1,1,1},
  green = {0, 1, 0}
}
-- draws common elements that are needed during gameplay
function drawCommon()
  drawUI()


  if DEBUG_FLAGS.print_debug == true then
    drawDebugInfo()
  end
end

function drawUI()
  local bar_height = 50
  love.graphics.setColor(.3, .3, .3)
  love.graphics.rectangle('fill', 0, 0, frame_width, bar_height)

  -- draw the score
  love.graphics.setColor(COLORS.white)
  love.graphics.print("Wallet " .. GAME_DATA.money .. ", Kills " .. GAME_DATA.kills .. ", XP " .. GAME_DATA.xp, 10, bar_height / 2)

end

function drawInventory(inventory)
  inventory:draw()
end

function resetColor()
  love.graphics.setColor(COLORS.white)
end

