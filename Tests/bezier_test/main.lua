require("plane")

function love.load()
	curve = love.math.newBezierCurve(50,50, 60,60, 70, 70)
	index = 3
	printCurve()
   depth = 1
   
   p = Plane:new(101,1)
   p:print()

   p1 = Plane:new(50,50)
   p1:print()
   p:print()
end

function love.update(dt)
   --print( p.t, p1.t)
   if p1.isFlying then
      local old_t = p1.t
      p1:update(dt)
      local x_new, y_new = curve:evaluate(p1.t)

      print("Dt", dt)
      print("Current", p1.x, p1.y)
      print("New", x_new, y_new)
      dist = math.sqrt((x_new - p1.x)^2 + (y_new - p1.y)^2)
      print("dist", dist)
      print("P1 T", p1.t)
      scale = p1.speed * dt / dist
      p1.t = old_t + dt * scale
      --p1:setCoords(p1.x + (x_new - p1.x)*scale, p1.y + (y_new - p1.y)*scale)
      local x_new, y_new = curve:evaluate(p1.t)
      dist = math.sqrt((x_new - p1.x)^2 + (y_new - p1.y)^2)
      print("Final", dist/dt)
      p1:setCoords(x_new, y_new)
      
      print(p1.t, scale)
   end
end

function love.draw()
   love.graphics.line(curve:render())
   love.graphics.circle('fill', p1.x, p1.y, 10)
end

function love.mousepressed(x, y, button)
	index = index + 1
	print(x, " ", y, " ", button, " ", index)

	curve:insertControlPoint(x, y, 1 + curve:getControlPointCount())
	printCurve()
end


function printCurve()
	count = curve:getControlPointCount()

	for i=1,count do
		print(curve:getControlPoint(i))
	end
end

function love.keypressed( key )
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
      curve:insertControlPoint(470, 500, 1 + curve:getControlPointCount())
      curve:insertControlPoint(490, 500, 1 + curve:getControlPointCount())
      curve:insertControlPoint(500, 500, 1 + curve:getControlPointCount())
   end

   if key == "f" then
      print("f")
      p1.isFlying = true
   end

   if key == "escape" then
      love.event.quit()
   end
end