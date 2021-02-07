after_action = {}

function after_action:enter(previous, level)
  after_action.level = level
  after_action.write_time = 0
  after_action.frame_time = 5

end


function after_action:draw()
  love.graphics.setFont(arcade_font)
  reflowprint(after_action.write_time / after_action.frame_time, "Level " .. after_action.level .. " completed with 5 kills", 100, 100, 500, 200, 4, 4)
end

function after_action:update(dt)
  after_action.write_time = after_action.write_time + dt

  if after_action.write_time / after_action.frame_time > 1.5 then
    Gamestate.switch(main_menu)
  end

end

return after_action