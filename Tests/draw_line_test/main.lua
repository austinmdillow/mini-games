require("plane")

function love.load()
   frame_width, frame_height = love.graphics.getDimensions()
   airport_x = frame_width / 2
   airport_y = frame_height / 2

   score = 10

   p1 = Plane:new(50,200)
   p2 = Plane:new(100,50)
   p1:print()
   plane_list = {}
   table.insert(plane_list, p1)
   table.insert(plane_list, p2)

   selected_plane = plane_list[1]

   path = {}
   game_state = "play"
   player_action = "idle"
   path = {}
end

function love.update(dt)

   if game_state == "play" then

      for idx,plane in ipairs(plane_list) do
         plane:update(dt)
         checkCollisions(plane)
         checkLanding(plane, idx)
      end

      makeFlightPath()
   elseif game_state == "fail" then
      print(3)
   end

   --generateAircraft(dt)

end

function love.draw()
   love.graphics.setColor(1,1,1)
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

   if game_state == "fail" then
      love.graphics.print("GAME OVER", 300, 400, 0, 5, 5)
   end
end

function love.mousepressed(x, y, button)
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

function love.mousereleased(x, y, button)
   if button == 2 and player_action == "drawing" then
      player_action = "idle"
      selected_plane.path = table.shallow_copy(path)
      print(path[1], path[2])
      print(p1.path[1], p1.path[2])
      path = {}
   end
end


function love.keypressed(key)
   if key == "=" then
      depth = depth + 1
      print("depth ", depth)
   end

   if key == "-" then
      depth = depth - 1
      print("depth ", depth)
   end

   if key == "return" then
   	print("enter")

   end

   if key == "f" then
      print("f")
      selected_plane.flying = true
   end

   if key == "c" then
      selected_plane = nil
   end

   if key == "escape" then
      love.event.quit()
   end
end


function checkCollisions(plane)
   for j,plane2 in ipairs(plane_list) do
      if plane ~= plane2 then
         local dist = plane.coord:distanceToCoord(plane2.coord)
         if dist < plane.radius + plane2.radius then
            print("FAIL")
            game_state = "fail"
         end
      end
   end
end

function checkLanding(plane, idx)
   if plane.coord:distanceToPoint(airport_x, airport_y) < 50 then
      table.remove(plane_list, idx)
   end
end


function distance(x1, y1, x2, y2)
   return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
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

function table.shallow_copy(t)
   local t2 = {}
   for k,v in pairs(t) do
     t2[k] = v
   end
   return t2
 end
