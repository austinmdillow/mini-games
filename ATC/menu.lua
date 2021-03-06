-- main menu
menu = {}

local menuengine = require "lib.menuengine"
menuengine.stop_on_nil_functions = true

local mainmenu
local text = ""

-- Start Game
local function start_game()
    text = "Start Game was selected!"
    Gamestate.switch(gameplay)
end

-- Options
local function options()

end

-- Quit Game
local function quit_game()

end

function menu:draw()
    mainmenu:draw()
end

function menu:update(dt)
    mainmenu:update(dt)
end

function menu:enter(previous)
    print(VERSION)

    love.graphics.setFont(love.graphics.newFont(20))

    mainmenu = menuengine.new(300,300)
    mainmenu:addEntry("Start Game", start_game)
    mainmenu:addEntry("Options", options)
    mainmenu:addSep()
    mainmenu:addEntry("Quit Game", quit_game)
end

function menu:keypressed(key, scancode, isrepeat)
    menuengine.keypressed(scancode)

    if scancode == "escape" then
        love.event.quit()
    end
end

function menu:mousemoved(x, y, dx, dy, istouch)
    menuengine.mousemoved(x, y)
end









