round_over = {}

function round_over:draw()
  love.graphics.setColor(1,0,0)
  love.graphics.print("Press Any key to continue", 50, 50, 0, 2, 2)
  love.graphics.print("High score " .. high_score, 50, 200, 0, 2, 2)
  love.graphics.print(math.floor(high_score / 86 * 100) .. "% to final reached", 50, 300, 0, 2, 2)

  if spencer_found == true then
    spencer_draw = true
    love.graphics.print("He has been found", 50, 400, 0, 2, 2)
  end
end

function round_over.keypressed(key)
  Gamestate.switch(main_gameplay)
end

function round_over.mousepressed(key)
  Gamestate.switch(main_gameplay)
end