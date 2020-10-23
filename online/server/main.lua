--love.filesystem.setRequirePath( "..?.lua;?/init.lua" )

-- SERVER
local sock = require "lib.sock.sock"
local count = 0
local my_count = 0

Object = require "lib.mylove.classic"
Camera = require "lib.hump.camera"
require "lib.mylove.entity"
require "lib.mylove.player"
require "lib.mylove.coord"
require "bullet"
require "enemy"
lovebird = require "lib.mylove.lovebird"
require "lib.mylove.colors"

local game_data = {
    client_list = {},
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
local FRAME_WIDTH, FRAME_HEIGHT = love.graphics.getDimensions()

function love.load()
    -- Creating a server on any IP, port 22122
    server = sock.newServer("*", 22122)
    
    -- Called when someone connects to the server
    server:on("connect", onNewConnectionCallback)

    server:on("update", onUpdateCallback)

    server:on("bullet", onBulletCallback)

    server:on("disconnect", function(data, client)
        -- Send a message back to the connected client
        local msg = "failed"
    end)
    camera = Camera(400,400)
end


function onUpdateCallback(data, client)
    --print(#game_data.client_list)
    local index = client:getIndex()
    if game_data.client_list[index] ~= nil then
        game_data.client_list[index]:setXYT(data.x, data.y, data.t)
    else
        print("NIL")
    end
end

function onBulletCallback(data, client)
    local index = client:getIndex()
    local tmp_bullet = Bullet(data.x, data.y, data.t)
    tmp_bullet.setId(client:getConnectId())
    table.insert(game_data.bullet_list, tmp_bullet)
end

function onNewConnectionCallback(data, client)
    -- Send a message back to the connected client
    local index = client:getIndex()
    local msg = "Hello from the server!"
    client:send("initData", msg)
    print("Connected to a client with id ", client:getConnectId(), client:getAddress(), index)
    game_data.client_list[index] = Player(100,100)
    game_data.client_list[index]:setColorRandom()
    start_time = love.timer.getTime()
end

function love.update(dt)
    lovebird.update()
    server:update()
    local tmp_player = game_data.client_list[1]
    --local dx,dy = tmp_player.coord.x - camera.x, tmp_player.coord.y - camera.y
    --camera:move(dx/2, dy/2)

    for idx, bullet in ipairs(game_data.bullet_list) do
        bullet:update(dt)
        if outOfBounds(bullet.coord) then
            table.remove(game_data.bullet_list, idx)
            --print("removed")
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
    sendclient_listData()

    --server:sendToAll("allBullets", game_data.bullet_list)
    
end

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


function love.draw()
    camera:attach()

    for index, player in ipairs(game_data.client_list) do
        player:draw()
    end

    for index, enemy in pairs(game_data.enemy_list) do
        enemy:draw()
    end

    for index, bullet in ipairs(game_data.bullet_list) do
        --print("bullet rpint" , index, bullet)
        if bullet ~= nil then
            bullet:draw()
        end
    end
    drawBoundaries()
    camera:detach()
    
    drawDebug()
    
end

function drawDebug()
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
    for idx_bullet, bullet in ipairs(game_data.bullet_list) do
        local bullet_x, bullet_y = bullet:getXY()
        for idx, player in ipairs(game_data.client_list) do
            if player.coord:distanceToPoint(bullet_x, bullet_y) < player.size then
                --print("Collision")
            end
        end

        for idx, enemy in pairs(game_data.enemy_list) do
            if enemy.team ~= bullet.team and enemy.coord:distanceToPoint(bullet_x, bullet_y) < enemy.size then
                if enemy:damage(bullet.damage) then -- the bullet killed the enemy
                    --table.remove(game_data.enemy_list, idx)
                    for player in client_list do
                        if player:getConnectId() == 
                    game_data.enemy_list[idx] = nil
                    print("KILLLLEEDDD")
                end
            end
        end

    end
    local end_time_col = love.timer.getTime()
    --print(end_time_col - start_time_col)
end

function love.keypressed(key)
    if key == "e" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        local tmp_enemy = Enemy(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
    end

    if key == "d" then
        game_data.enemy_list["1"] = nil
    end
end