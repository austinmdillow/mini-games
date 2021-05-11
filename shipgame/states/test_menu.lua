test_menu = {}

function test_menu:init()

end

function test_menu:enter()
    test_menu.animation_manager = AnimationManager()
    test_menu.animation_manager:addAnimation(effects.explosion_5, 400, 100)
    test_menu.animation_manager:addAnimation(effects.explosion_6, 100, 100)
end

function test_menu:update(dt)
    test_menu.animation_manager:update(dt)
end

function test_menu:draw()
    love.graphics.setColor(COLORS.green)
    love.graphics.rectangle('line', 100, 100, 300, 300)
    love.graphics.setColor(COLORS.white)
    test_menu.animation_manager:draw()

end

function test_menu:keypressed(key)
    if key == "escape" then
        Gamestate.pop()
    end
end

return test_menu