--love.filesystem.setRequirePath( "..?.lua;?/init.lua" )

-- SERVER
local sock = require "lib.sock.sock"
local count = 0
local my_count = 0
require "player"

game_data = {
    x_pos = 0,
    y_pos = 0,
    clients = {}
}

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
    end)

    server:on("greeting", function(msg, client)
        print("what") 
    end )

    server:on("count", onCountFunction)

    server:on("update", onUpdateCallback)

    server:on("disconnect", function(data, client)
        -- Send a message back to the connected client
        local msg = "failed"
    end)

    function newBall(x, y)
        return {
            x = x,
            y = y,
            vx = 150,
            vy = 150,
            w = 15,
            h = 15,
        }
    end

    local marginX = 50

    scores = {0, 0}

    ball = newBall(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
        
end



function onCountFunction(data, client)
    -- print(data)
    count = count + 1
    print("local Count ", count)
    print("remote count ", data)
end

function onUpdateCallback(data, client)
    local index = client:getIndex()
    print("index = ", index)
    print("client = ", client)
    print("connect id = ", client:getConnectId())
    print(data.x, data.y)
    game_data.clients[index]:setXY(data.x, data.y)
    print(game_data.clients[index]:getX())


end


function love.update(dt)
    server:update()
    --server:send("hello", "it's the server")
    --server:sendToAll("gameStarting", true)
    --print("People:", dump(game_data.clients))
end

function love.draw()
    local spacing = 20
    love.graphics.print("Count " .. server:getClientCount(), 10, 1 * spacing)
    love.graphics.print("RX " .. server:getTotalSentData(), 10, 2 * spacing)
    love.graphics.print("Tx " .. server:getTotalReceivedData(), 10, 3 * spacing)
    
    for index, player in ipairs(game_data.clients) do
        print("printed coords", player:getX(), player:getY(), index)
        print(index)
        love.graphics.setColor(player:getColor())
        love.graphics.circle('fill', player:getX(), player:getY(), 5)
    end
    
end