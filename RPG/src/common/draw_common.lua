
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
  love.graphics.setColor(.1, .1, .1)
  love.graphics.rectangle('fill', 0, frame_height, frame_width, 10)
end

function drawInventory(inventory)
  inventory:draw()
end

function resetColor()
  love.graphics.setColor(COLORS.white)
end

