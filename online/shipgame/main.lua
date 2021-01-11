--love.filesystem.setRequirePath( "..?.lua;?/init.lua" )

-- SERVER
local sock = require "lib.sock.sock"
local count = 0
local my_count = 0
local start_time = 0

Object = require "lib.mylove.classic"
Camera = require "lib.hump.camera"
Gamestate = require "lib.hump.gamestate"
SaveData = require("lib.savedata.saveData")
lovebird = require "lib.mylove.lovebird"

require "lib.hump.gamestate"
require "lib.mylove.entity"
require "lib.menuengine"
require "entities.ship"
require "entities.player"
require "lib.mylove.coord"
require "entities.bullet"
require "entities.enemy"
require "entities.gun"
require "lib.mylove.colors"
require "utils.serverCallbacks"
require "utils.debugging"
require "utils.hud"

local main_menu = require("states.main_menu")
local gameplay = require("states.gameplay")
local death_screen = require("states.death_screen")

game_data = {
    mode = "single",
    client_list = {},
    local_player = nil,
    score = 0,
    level_score = 0,
    enemy_list = {},
    current_enemy_number = 0,
    bullet_list = {},
    map_properties = {
        width = 2000,
        height = 1000
    }
}

-- default save values that will be loaded and written
save_data = {
    score = 0,
    level_stats = {
        {0, 0, 0}
    }
}

local debug_data = {
    rxtx_alpha = .1,
    last_rx = 0,
    rx_rate = 0,
    last_tx = 0,
    tx_rate = 0
}

local start_time = love.timer.getTime()
FRAME_WIDTH, FRAME_HEIGHT = love.graphics.getDimensions()

function love.load()
    if game_data.mode == "single" then
        game_data.local_player = Player(200, 200)
    elseif game_data.mode == "online" then
        -- Creating a server on any IP, port 22122
        server = sock.newServer("192.168.0.10", 22122)
        
        -- Called when someone connects to the server
        server:on("connect", onNewConnectionCallback)

        server:on("update", onUpdateCallback)

        server:on("bullet", onBulletCallback)

        server:on("disconnect", function(data, client)
            -- Send a message back to the connected client
            local msg = "failed"
        end)
    end
    camera = Camera(400,400)
    Gamestate.registerEvents()
    Gamestate.switch(main_menu)
end



function love.update(dt)
     
end




function love.draw()

end



function drawBoundaries()
    love.graphics.setColor(1,1,1)
    love.graphics.polygon('line', 0,0, game_data.map_properties.width,0, game_data.map_properties.width,game_data.map_properties.height, 0,game_data.map_properties.height)
end


function outOfBounds(coord)
    if coord.x < 0 or coord.x > game_data.map_properties.width then
        return true
    end

    if coord.y < 0 or coord.y > game_data.map_properties.height then
        return true
    end

    return false
end

function checkCollisions()
    local start_time_col = love.timer.getTime()
    for idx_bullet, bullet in pairs(game_data.bullet_list) do
        local bullet_x, bullet_y = bullet:getXY()

        for idx, player in ipairs(game_data.client_list) do
            if player.coord:distanceToPoint(bullet_x, bullet_y) < player.size then
                print("Collision")
                game_data.bullet_list[idx_bullet] = nil
            end
        end

        if bullet.source ~= game_data.local_player then
            if game_data.local_player.coord:distanceToPoint(bullet_x, bullet_y) < game_data.local_player.hitbox + bullet.size then
                game_data.local_player:damage(bullet.damage)
                game_data.bullet_list[idx_bullet] = nil
            end 
        end

        for idx, enemy in pairs(game_data.enemy_list) do
            if enemy.team ~= bullet.team and enemy.coord:distanceToPoint(bullet_x, bullet_y) < enemy.hitbox + bullet.size then
                if enemy:damage(bullet.damage) then -- the bullet killed the enemy
                    game_data.enemy_list[idx] = nil
                    game_data.bullet_list[idx_bullet] = nil
                    print("KILLLLEEDDD")
                    game_data.score = game_data.score + enemy.difficulty
                end
            end
        end

    end
    local end_time_col = love.timer.getTime()
end

function generateEnemies(dt)
    local random_num = love.math.randomNormal(1/dt/3, 0)
    if random_num > 1 / dt then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        local tmp_enemy = Enemy(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
    end
end

-- Global actions for a key press
function love.keypressed(key)

end



-- server functions

function sendclient_listData()
    local send_ships = {}
    -- loop through players
    for idx, player in ipairs(game_data.client_list) do
        local packet = {
            team = player.team,
            x = player.coord:getX(),
            y = player.coord:getY(),
            color = player.color
        }
        table.insert(send_ships, packet)
    end

    for idx, enemy in pairs(game_data.enemy_list) do
        local packet = {
            team = enemy.team,
            x = enemy.coord:getX(),
            y = enemy.coord:getY(),
            color = enemy.color
        }
        table.insert(send_ships, packet)
    end

    server:sendToAll("allShips", send_ships)

    local send_bullets = {}


    -- loop through bullets
    for idx, bullet in ipairs(game_data.bullet_list) do
        local packet = {
            x = bullet.coord:getX(), --x
            y = bullet.coord:getY(), --y
            color = bullet.color --color
        }
        table.insert(send_bullets, packet)
        --server:sendToAll("singleBullet", packet)
    end
    server:sendToAll("allBullets", send_bullets)
end


function drawServerDebug()
    love.graphics.setColor(1,1,1)
    local spacing = 20
    local new_rx_rate = ((server:getTotalReceivedData() - debug_data.last_rx) / 60 ) / 1000 -- calclate instant rate
    local new_tx_rate = ((server:getTotalSentData() - debug_data.last_tx) / 60 ) / 1000
    debug_data.rx_rate = new_rx_rate  * debug_data.rxtx_alpha + debug_data.rx_rate * (1 - debug_data.rxtx_alpha) -- moving average
    debug_data.tx_rate = new_tx_rate  * debug_data.rxtx_alpha + debug_data.tx_rate * (1 - debug_data.rxtx_alpha)

    love.graphics.print("Count " .. server:getClientCount(), 10, 1 * spacing)
    love.graphics.print("RX (kB) " .. server:getTotalReceivedData() / 1000 .. " " .. debug_data.rx_rate, 10, 2 * spacing)
    love.graphics.print("Tx (kB) " .. server:getTotalSentData() / 1000 .. " " .. server:getTotalSentData() / 1000 / (love.timer.getTime() - start_time), 10, 3 * spacing)

    debug_data.last_rx = server:getTotalReceivedData() -- update the amount of sent/received data
    debug_data.last_tx = server:getTotalSentData()

    local x_offest = 100
    love.graphics.print("# bullets " .. #game_data.bullet_list, FRAME_WIDTH - x_offest, 1 * spacing)
end