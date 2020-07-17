
COLORS = {
  red = {1, 0, 0},
  white = {1,1,1}
}
-- draws common elements that are needed during gameplay
function drawCommon()
  drawUI()
  if player.inventory:getActive() then
    drawInventory(player.inventory)
  end


  if DEBUG_FLAGS.print_debug == true then
    drawDebugInfo()
  end
end

function drawUI()
  local bar_height = 50
  love.graphics.setColor(.3, .3, .3)
  love.graphics.rectangle('fill', 0, frame_height - bar_height, frame_width, bar_height)

  -- draw the score
  love.graphics.setColor(COLORS.white)
  love.graphics.print("Wallet " .. GAME_DATA.money .. ", Kills " .. GAME_DATA.kills .. ", XP " .. GAME_DATA.xp, 10, frame_height - bar_height / 2)
end

function drawInventory(inventory)
  inventory:draw()
end

function resetColor()
  love.graphics.setColor(COLORS.white)
end

