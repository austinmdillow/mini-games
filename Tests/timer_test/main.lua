Timer = require "timer"

function love.keypressed(key)
    if key == 'p' then
        Timer.after(1, function() print("Hello, world!") end)
    end

    Timer.every(1, function() print(key) end)

    if key == 'c' then
      Timer.clear()
    end
end

function love.update(dt)
    Timer.update(dt)
end