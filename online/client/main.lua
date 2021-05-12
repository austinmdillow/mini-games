local count = 0
local sock = require "lib.sock.sock"

Object = require "lib.mylove.classic"

require "lib.mylove.entity"
require "lib.ship"
require "lib.mylove.player"
require "lib.mylove.coord"



local state = {
    local_player = Player(100,100),
    bullet_list = {},
    ship_list = {},
    remote_player = {0, 0, 0}
}

local FRAME_WIDTH, FRAME_HEIGHT = love.graphics.getDimensions()

-- client.lua
function love.load()
    -- Creating a new client on localhost:22122
    client = sock.newClient("192.168.0.10", 22122)
    
    
    -- Creating a client to connect to some ip address
    -- client = sock.newClient("198.51.100.0", 22122)

    -- Called when a connection is made to the server
    client:on("connect", function(data)
        print("Client connected to the server.")
    end)

    client:on("initData", onInitDataCallback)
    
    -- Called when the client disconnects from the server
    client:on("disconnect", function(data)
        print("Client disconnected from the server.")
    end)

    client:on("allShips", onAllShipsCallback)
    client:on("allBullets", onAllBulletsCallback)
    client:on("singleBullet", onSingleBulletCallback)

    client:connect()

    
end

function love.update(dt)
    state.bullet_list = {}
    client:update()

    client:send("update", {
        x = state.local_player:getX(), 
        y = state.local_player:getY(),
        t = state.local_player:getT()
    })

    state.local_player:update(dt)
end

function love.draw()
    if state.remote_player[1] ~= nil then
        love.graphics.circle('line', state.remote_player[1], state.remote_player[2], 10)
    end

    for idx, bullet in ipairs(state.bullet_list) do
        love.graphics.circle('fill', bullet.x, bullet.y, 5)
    end

    for idx, ship in ipairs(state.ship_list) do
        love.graphics.circle('line', ship.x, ship.y, 9)
    end

    drawDebug()
end

function drawDebug()
    local fps = love.timer.getFPS()

    love.graphics.setColor({.1,.1,.1})
    love.graphics.rectangle('fill',FRAME_WIDTH - 200, 0, 200, 50)
    love.graphics.setColor({1,1,1})
    love.graphics.print("State " .. client:getState(), FRAME_WIDTH - 150, 5)
    love.graphics.print("Ping (ms) " .. client:getRoundTripTime(), FRAME_WIDTH - 150, 30)
    love.graphics.print("FPS " .. fps, FRAME_WIDTH - 150, 40)
    state.local_player:draw()
    love.graphics.rectangle('fill', 400, 400, 10, 10)
end

function love.keypressed(key)
    print(key)
    if key == "space" then
        client:send("bullet", {
            x = state.local_player:getX(),
            y = state.local_player:getY(),
            t = state.local_player:getT(),
            bullet_type = 1
        })
    end
end


function onAllShipsCallback(data, client)
    if data[1] ~= nil then
        state.remote_player[1] = data[1].x
        state.remote_player[2] = data[1].y
        --print(data[1].x, data[1].y)
    end

    state.ship_list = data
end

function onAllBulletsCallback(data, client)
    state.bullet_list = data
end

function onSingleBulletCallback(data, client)
    table.insert(state.bullet_list, data)
end

function onInitDataCallback(data, client)
    print(data)
end
