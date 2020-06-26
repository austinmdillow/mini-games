

function love.load()
	curve = love.math.newBezierCurve(50,50, 60,60, 70, 70)
	index = 3
	printCurve()
	depth = 1
end

function love.draw()
	love.graphics.line(curve:render(depth))
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
   	print("etner")
      curve:insertControlPoint(470, 500, 1 + curve:getControlPointCount())
      curve:insertControlPoint(490, 500, 1 + curve:getControlPointCount())
      curve:insertControlPoint(500, 500, 1 + curve:getControlPointCount())
      print("depth ", depth)
   end
end