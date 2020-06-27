menu = {}

function menu:draw()
    love.graphics.print("Press Enter to continue", 100, 100)
end

function menu:enter(previous)
    print("How did you get here")
    print(VERSION)
end

function menu:keypressed(key)
    if key == 'return' then
        Gamestate.switch(gameplay)
    end
end