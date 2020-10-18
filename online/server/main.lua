--love.filesystem.setRequirePath( "..?.lua;?/init.lua" )

-- SERVER
local sock = require "lib.sock.sock"
local count = 0
local my_count = 0
require "lib.mylove.player"
require "lib.mylove.coord"
require "bullet"

game_data = {
    x_pos = 0,
    y_pos = 0,
    clients = {},
    enemies = {},
    bullet_list = {}
}
local start_time = love.timer.getTime()

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
        
end




function onUpdateCallback(data, client)
    local index = client:getIndex()
    print("index = ", index)
    print("client = ", client)
    print("connect id = ", client:getConnectId())
    game_data.clients[index]:setXYT(data.x, data.y, data.dir)
end

function onBulletCallback(data, client)
    local index = client:getIndex()
    print("index = ", index)
    print("client = ", client)
    print("connect id = ", client:getConnectId())
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
    end
    server:sendToAll("allCoords", send_data)
end


function love.draw()
    local spacing = 20
    love.graphics.print("Count " .. server:getClientCount(), 10, 1 * spacing)
    love.graphics.print("RX (kB) " .. server:getTotalReceivedData() / 1000 .. " " .. server:getTotalReceivedData() / 1000 / (love.timer.getTime() - start_time), 10, 2 * spacing)
    love.graphics.print("Tx (kB) " .. server:getTotalSentData() / 1000 .. " " .. server:getTotalSentData() / 1000 / (love.timer.getTime() - start_time), 10, 3 * spacing)
    
    for index, player in ipairs(game_data.clients) do
        love.graphics.setColor(player:getColor())
        love.graphics.circle('fill', player:getX(), player:getY(), 5)
    end

    for index, bullet in ipairs(game_data.bullet_list) do
        print("bullet rpint" , index, bullet)
        if bullet ~= nil then
            love.graphics.setColor(bullet:getColor())
            bullet:draw()
        end
    end
    
end