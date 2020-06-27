gameplay = {}

local airport_x
local airport_y

local score = 10

local plane_list = {}
local selected_plane = plane_list[1]

local path = {}
local player_action = "idle"

function gameplay:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.print("Score: " .. score, 20, 10, 0, 3, 3)

    for i,plane in ipairs(plane_list) do
        if plane == selected_plane then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.circle('fill', plane.coord.x, plane.coord.y, 10)
    end

   love.graphics.setColor(1,1,1)

    if table.getn(path) >= 4 then
      love.graphics.line(path)
    end

    love.graphics.rectangle('fill', airport_x, airport_y, 50, 10)

    if selected_plane ~= nil and table.getn(selected_plane.path) >= 4 then
      love.graphics.setColor(1,0,0)
      love.graphics.line(selected_plane.path)
    end
end

function gameplay:update(dt)
    for idx,plane in ipairs(plane_list) do
        plane:update(dt)
        checkCollisions(plane)
        checkLanding(plane, idx)
    end

    makeFlightPath()
    generateAircraft(dt)
end


function gameplay:enter(previous)
    print("You came here from", previous)
    print("can you see me", boop)

    airport_x = frame_width / 2
    airport_y = frame_height / 2

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

function gameplay:mousepressed(x, y, button)
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
       depth = depth + 1
       print("depth ", depth)
    end
 
    if key == "-" then
       depth = depth - 1
       print("depth ", depth)
    end
 
    if key == "f" then
       print("f")
       selected_plane.flying = true
    end
 
    if key == "c" then
       selected_plane = nil
    end
 
    if key == "escape" then
        Gamestate.switch(menu)
    end
 end


 function makeFlightPath()
    if selected_plane ~= nil then -- we have selected a plane
       
       if love.mouse.isDown(2) then
          local x, y = love.mouse.getPosition()
 
          if player_action == "idle" then
             table.insert(path, x)
             table.insert(path, y)
             player_action = "drawing"
          elseif player_action == "drawing" then
             last_x = path[#path - 1]
             last_y = path[#path]
             local dist = distance(last_x, last_y, x, y)
             print(dist)
             if (dist > 10) then
                table.insert(path, x)
                table.insert(path, y)
             end
          end
       end
 
    end
 end


 function generateAircraft(dt)
    local rand = love.math.random(0,10/dt)
    if rand < .01 then
       local plane_temp = Plane:new(0,love.math.random(0,frame_height))
       plane_temp.path[1] = 500
       plane_temp.path[2] = 500
       plane_temp.flying = true
       table.insert(plane_list, plane_temp)
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