settings_menu = {}

function settings_menu:init()

end

function settings_menu:enter()
    logger:log("Entering settings menu", 2)
    settings_menu.volume_slider = {
        value = dj:getVolume(),
        max = 1,
        min = 0,
    }
end

function settings_menu:update(dt)
    suit.layout:reset(100, 100)
    suit.layout:padding(10, 10)
    
    if suit.Button("Go Back (Esc)", 0,0,150,30).hit then
        Gamestate.pop()
    end

    local god_button_text = "Off"
    if game_data.god_mode then
        god_button_text = "On"
    end
    local god_button = suit.Button("God Mode " .. god_button_text, suit.layout:row(300, 30))
    if god_button.hit then
        game_data.god_mode = not game_data.god_mode
        print("jit")
    end
    suit.Label("Music Volume", {}, suit.layout:row(300,30))
    suit.Slider(settings_menu.volume_slider, suit.layout:col(300,30))
    local music_volume = settings_menu.volume_slider.value
    suit.Label(tostring(music_volume), {align = "left"}, suit.layout:col(50,30))
    dj:setVolume(music_volume)
end

function settings_menu:draw()
    suit.draw()

end

function settings_menu:keypressed(key)
    if key == "escape" then
        Gamestate.pop()
    end

    suit.keypressed(key)
end

return settings_menu