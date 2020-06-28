gameover = {}

function gameover:draw()
    love.graphics.print("GAME OVER", 100, 400, 0, 3, 3)
end

function gameover:enter(previous)
    print("Entering gameover")
end

function gameover:keypressed(key)
    if key == 'return' then
        Gamestate.switch(menu)
    end
end