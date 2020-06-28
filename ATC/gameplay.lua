require("plane")
gameplay = {}

local airport_x
local airport_y

local score

local plane_list = {}
local selected_plane = plane_list[1]

local path = {}
local player_action = "idle"
local plane_img = love.graphics.newImage("assets/airplane.png")
local last_plane_generated
local camera

function gameplay:draw()
    camera:attach()
    drawMap()

    for i,plane in ipairs(plane_list) do
        local img_scale = 1/15
        local img_w = plane_img:getWidth()
        local img_h = plane_img:getHeight()
        
        if plane == selected_plane then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.draw(plane_img, plane.coord.x, plane.coord.y, math.rad(plane.coord.dir + 90), img_scale, img_scale, img_w/2, img_h/2)
    end

   love.graphics.setColor(1,1,1)

    if table.getn(path) >= 4 then
      love.graphics.line(path)
    end

    if selected_plane ~= nil and table.getn(selected_plane.path) >= 4 then
      love.graphics.setColor(1,0,0)
      love.graphics.line(selected_plane.path)
    end

    camera:detach()
    drawHUD()
end

function gameplay:update(dt)
    moveCamera(dt)
    for idx,plane in ipairs(plane_list) do
        plane:update(dt)
        checkCollisions(plane)
        checkLanding(plane, idx)
    end
    makeFlightPath()
    generateAircraft(3)
end


function gameplay:enter(previous)
    airport_x = frame_width / 2
    airport_y = frame_height / 2
    camera = Camera(airport_x, airport_y)

    score = 0
    last_plane_generated = love.timer.getTime()

    p1 = Plane(50,200)
    p2 = Plane(100,50)

    plane_list = {}
    table.insert(plane_list, p1)
    table.insert(plane_list, p2)    
end

function gameplay:leave()
    total_score = total_score + score
end

function gameplay:mousereleased(x, y, button)
    if button == 2 and player_action == "drawing" then
        player_action = "idle"
        selected_plane.path = table.shallow_copy(path)
        print(path[1], path[2])
        print(p1.path[1], p1.path[2])
        path = {}
    end
end

function gameplay:mousepressed(x_cam, y_cam, button)
    local x, y = camera:worldCoords(x_cam, y_cam)
    if button == 1 then
       local min_dist = 9999
       local min_plane = nil
       if player_action == "idle" then
          print("c")
          for i,plane in ipairs(plane_list) do
             dist = plane.coord:distanceToPoint(x, y)
             if dist < min_dist then
                min_dist = dist
                min_plane = plane
             end
          end
 
          selected_plane = min_plane
       end
    end
end

function gameplay:keypressed(key)
    if key == "=" then
       camera:zoom(5/4)
    elseif key == "-" then
        camera:zoom(4/5)
    end
 
    if key == "f" then
       print("f")
       if selected_plane ~= nil then
        selected_plane.flying = true
       end
    end
 
    if key == "c" then
        if selected_plane ~= nil then
            selected_plane = nil
        end
    end
 
    if key == "escape" then
        Gamestate.switch(menu)
    end
end

function moveCamera(dt)
    local pps = 100 * 1/camera.scale-- pixels per second of moving speed
    if love.keyboard.isDown('up') then
        camera:move(0,-pps * dt)
    elseif love.keyboard.isDown('down') then
        camera.y = camera.y + pps * dt
    end

    if love.keyboard.isDown('left') then
        camera.x = camera.x - pps * dt
    elseif love.keyboard.isDown('right') then
        camera.x = camera.x + pps * dt
    end
end


 function makeFlightPath()
    if selected_plane ~= nil then -- we have selected a plane
       
       if love.mouse.isDown(2) then
          local x, y = camera:worldCoords(love.mouse.getPosition())
 
          if player_action == "idle" then
             table.insert(path, x)
             table.insert(path, y)
             player_action = "drawing"
          elseif player_action == "drawing" then
             last_x = path[#path - 1]
             last_y = path[#path]
             local dist = distance(last_x, last_y, x, y)
             --print(dist)
             if (dist > 30) then
                table.insert(path, x)
                table.insert(path, y)
             end
          end
       end
 
    end
 end

-- Create random planes on the map
function generateAircraft(period)
    if love.timer.getTime() - last_plane_generated > period then
        airport_coord = Coord(airport_x, airport_y)
        angle_tmp = love.math.random(0,360)
        local x_tmp, y_tmp = airport_coord:polarToCartesianOffset(700, angle_tmp)
        local plane_tmp = Plane(x_tmp, y_tmp)
        plane_tmp:setDirection(angle_tmp + 180)
        plane_tmp.flying = true
        table.insert(plane_list, plane_tmp)
        last_plane_generated = love.timer.getTime()
    end
end



function checkCollisions(plane)
    for j,plane2 in ipairs(plane_list) do
        if plane ~= plane2 then
            local dist = plane.coord:distanceToCoord(plane2.coord)
            if dist < plane.radius + plane2.radius then
                Gamestate.switch(gameover)
            end
        end
    end
end
 
function checkLanding(plane, idx)
    if plane.coord:distanceToPoint(airport_x, airport_y) < 50 then
       table.remove(plane_list, idx)
       score = score + 1
    end
end
 
function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
 
function table.shallow_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
end

function drawMap()
    love.graphics.setColor(0,.2,1)
    love.graphics.rectangle('fill', airport_x - 50/2, airport_y - 10/2, 50, 10)
    for r=100,800,100 do
        love.graphics.circle('line', airport_x, airport_y, r)
    end
end

function drawHUD()
    love.graphics.setColor(.1, .1, .1)
    love.graphics.rectangle('fill', 0,0, frame_width, 100)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Score: " .. score, 20, 10, 0, 2, 2)
    local id_list = ""
    for i,plane in ipairs(plane_list) do
        local tmp = id_list .. plane.tail_number .. " "
        id_list = tmp
    end
    love.graphics.printf(id_list, frame_width / 2, 30, frame_width / 2)
end