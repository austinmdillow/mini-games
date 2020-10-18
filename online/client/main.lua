local count = 0
local sock = require "lib.sock.sock"
 
-- client.lua
function love.load()
    -- Creating a new client on localhost:22122
    client = sock.newClient("localhost", 22122)
    FRAME_WIDTH, FRAME_HEIGHT = love.graphics.getDimensions()
    
    -- Creating a client to connect to some ip address
    -- client = sock.newClient("198.51.100.0", 22122)

    -- Called when a connection is made to the server
    client:on("connect", function(data)
        print("Client connected to the server.")
    end)
    
    -- Called when the client disconnects from the server
    client:on("disconnect", function(data)
        print("Client disconnected from the server.")
    end)

    client:connect()
    
end

function love.update(dt)
    client:update()
    print("Status ", client:getState())    --print("updated")
    local mouseY = love.mouse.getY()
    local mouseX = love.mouse.getX()
    if mouseY == nil then
        mouseY = 0
    end
    if mouseX == nil then
        mouseX = 0
    end

    print(mouseX, mouseY)
    --client:send("hi", "msg")
    client:send("update", {x = mouseX, 
        y = mouseY,
    })
    --print(mouseY)
end

function love.draw()
    love.graphics.setColor({.1,.1,.1})
    love.graphics.rectangle('fill',FRAME_WIDTH - 200, 0, 200, 50)
    love.graphics.setColor({1,1,1})
    love.graphics.print("State " .. client:getState(), FRAME_WIDTH - 150, 5)
    love.graphics.print("Ping (ms) " .. client:getRoundTripTime(), FRAME_WIDTH - 150, 30)
end

function love.keyPressed(key)
    client:send("hi", "msg")
    count = count + 1
    client:send("count", count)
    print("down")
end