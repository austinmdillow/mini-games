test_menu = {}

function test_menu:init()

end

function test_menu:enter()
    test_menu.enemy = Enemy(100,100,0)
    test_menu.enemy.max_speed = 100
    test_menu.enemy.rotation_speed = 1
    test_menu.mouse = HC.circle(400,300,100)

end

function test_menu:update(dt)
    test_menu.mouse:moveTo(love.mouse.getPosition())
    test_menu.enemy:update(dt)
    game_data.local_player:update(dt)
end

function test_menu:draw()
    test_menu.enemy:draw()
    game_data.local_player:draw()
    love.graphics.setColor({255,255,0})
    test_menu.mouse:draw()

end

function test_menu:keypressed(key)
    if key == "escape" then
        Gamestate.pop()
    end
end

return test_menu