--love.filesystem.setRequirePath( "..?.lua;?/init.lua" )

-- SERVER
local sock = require "lib.sock.sock"
local count = 0
local my_count = 0

Object = require "lib.mylove.classic"
Camera = require "lib.hump.camera"
require "lib.mylove.player"
require "lib.mylove.coord"
require "bullet"
require "enemy"

game_data = {
    x_pos = 0,
    y_pos = 0,
    clients = {},
    enemy_list = {},
    current_enemy_number = 0,
    bullet_list = {},
    map_properties = {
        width = 2000,
        height = 1000
    }
}

local start_time = love.timer.getTime()
local FRAME_WIDTH, FRAME_HEIGHT = love.graphics.getDimensions()

function love.load()
    -- Creating a server on any IP, port 22122
    server = sock.newServer("*", 22122)
    
    -- Called when someone connects to the server
    server:on("connect", function(data, client)
        -- Send a message back to the connected client
        local index = client:getIndex()
        local msg = "Hello from the server!"
        client:send("hello", msg)
        print("Connected to a client with id ", client, index)
        game_data.clients[index] = Player(100,100)
        game_data.clients[index]:setColorRandom()
        start_time = love.timer.getTime()
    end)

    server:on("update", onUpdateCallback)

    server:on("bullet", onBulletCallback)

    server:on("disconnect", function(data, client)
        -- Send a message back to the connected client
        local msg = "failed"
    end)
    camera = Camera(400,400)
end




function onUpdateCallback(data, client)
    local index = client:getIndex()
    --print("index = ", index)
    --print("client = ", client)
    --print("connect id = ", client:getConnectId())
    game_data.clients[index]:setXYT(data.x, data.y, data.dir)
end

function onBulletCallback(data, client)
    local index = client:getIndex()
    --print("index = ", index)
    --print("client = ", client)
    --print("connect id = ", client:getConnectId())
    table.insert(game_data.bullet_list, Bullet(data.x, data.y, data.dir))
end

function love.update(dt)
    server:update()
    --server:send("hello", "it's the server")
    --server:sendToAll("gameStarting", true)
    --print("People:", dump(game_data.clients))
    local send_data = {}
    for idx, player in ipairs(game_data.clients) do
        send_data[idx] = player.coord
        local dx,dy = player.coord.x - camera.x, player.coord.y - camera.y
        camera:move(dx/2, dy/2)
    end
    server:sendToAll("allCoords", send_data)

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
            table.insert(game_data.bullet_list, Bullet(enemy.coord))
        end
    end

    server:sendToAll("allBullets", game_data.bullet_list)
    
end


function love.draw()
    camera:attach()

    for index, player in ipairs(game_data.clients) do
        love.graphics.setColor(player:getColor())
        love.graphics.circle('fill', player:getX(), player:getY(), 5)
    end

    for index, enemy in pairs(game_data.enemy_list) do
        enemy:draw()
        --print(index, enemy)
    end
    --print(#game_data.enemy_list)

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
    love.graphics.print("Count " .. server:getClientCount(), 10, 1 * spacing)
    love.graphics.print("RX (kB) " .. server:getTotalReceivedData() / 1000 .. " " .. server:getTotalReceivedData() / 1000 / (love.timer.getTime() - start_time), 10, 2 * spacing)
    love.graphics.print("Tx (kB) " .. server:getTotalSentData() / 1000 .. " " .. server:getTotalSentData() / 1000 / (love.timer.getTime() - start_time), 10, 3 * spacing)

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

function love.keypressed(key)
    if key == "e" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        game_data.enemy_list[tostring(game_data.current_enemy_number)] = Enemy(500, 500)
    end

    if key == "d" then
        game_data.enemy_list["1"] = nil
    end
end