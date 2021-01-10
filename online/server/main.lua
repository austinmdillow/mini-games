--love.filesystem.setRequirePath( "..?.lua;?/init.lua" )

-- SERVER
local sock = require "lib.sock.sock"
local count = 0
local my_count = 0
local start_time = 0

Object = require "lib.mylove.classic"
Camera = require "lib.hump.camera"
require "lib.mylove.entity"
require "ship"
require "player"
require "lib.mylove.coord"
require "bullet"
require "enemy"
lovebird = require "lib.mylove.lovebird"
require "lib.mylove.colors"
require "serverCallbacks"
require("debugging")
require "hud"

game_data = {
    mode = "single",
    client_list = {},
    local_player = nil,
    score = 0,
    enemy_list = {},
    current_enemy_number = 0,
    bullet_list = {},
    map_properties = {
        width = 2000,
        height = 1000
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
end



function love.update(dt)
    --lovebird.update()
    if game_data.mode == "online" then
        server:update()
    end

    if game_data.mode == "single" then
        game_data.local_player:update(dt)
        local dx,dy = game_data.local_player.coord.x - camera.x, game_data.local_player:getY() - camera.y
        camera:move(dx/2, dy/2)
    end
    

    for idx, bullet in pairs(game_data.bullet_list) do
        bullet:update(dt)
        if outOfBounds(bullet.coord) or bullet:dead() then
            table.remove(game_data.bullet_list, idx)
        end
    end

    for key, enemy in pairs(game_data.enemy_list) do
        local result = enemy:update(dt)
        if result == "fire" then
            local tmp_bullet = Bullet(enemy.coord)
            tmp_bullet:setTeamAndSource(-1, key)
            table.insert(game_data.bullet_list, tmp_bullet)
        end
    end

    checkCollisions()
    generateEnemies(dt)
    updateHud(dt)

    if game_data.mode == "online" then
        sendclient_listData()
    end

    
end




function love.draw()
    camera:attach()

    if game_data.mode == "online" then
        for index, ship in ipairs(game_data.client_list) do
            ship:draw()
        end
    elseif game_data.mode == "single" then
        game_data.local_player:draw()
    end

    for index, enemy in pairs(game_data.enemy_list) do
        enemy:draw()
    end

    for index, bullet in pairs(game_data.bullet_list) do
        --print("bullet rpint" , index, bullet)
        if bullet ~= nil then
            bullet:draw()
        end
    end
    drawBoundaries()
    camera:detach()

    drawHUD()
    
    if game_data.mode == "server" then
        drawServerDebug()
    elseif game_data.mode == "single" then
        drawDebugInfo()
    end
    
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
    --print(end_time_col - start_time_col)
end

function generateEnemies(dt)
    local random_num = love.math.randomNormal(1/dt/3, 0)
    print(random_num, 1/dt)
    if random_num > 1 / dt then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        local tmp_enemy = Enemy(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
    end
end

function love.keypressed(key)
    if key == "e" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        local tmp_enemy = Enemy(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
    end

    if game_data.mode == "single" then
        local result = game_data.local_player:keypressed(key)
        if result == "fire" then
            local tmp_bullet = Bullet(game_data.local_player.coord)
            tmp_bullet:setTeamAndSource(game_data.local_player.team, game_data.local_player)
            table.insert(game_data.bullet_list, tmp_bullet)
        end

    end
    for idx, b in pairs(game_data.bullet_list) do
        print(idx, b)
    end
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