gameover = {}

function gameover:draw()
    love.graphics.print("GAME OVER", 300, 400, 0, 5, 5)
end

function gameover:enter(previous)
    print("Entering gameover")
end

function menu:keypressed(key)
    if key == 'return' then
        Gamestate.switch(menu)
    end
end