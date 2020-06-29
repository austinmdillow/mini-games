



function love.load()
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81 * love.physics.getMeter(), 0)

  character_body = love.physics.newBody(world, 100,100, "dynamic")
  character_shape = love.physics.newCircleShape(10)
  character_fixture = love.physics.newFixture(character_body, character_shape)
  character_body:setMassData(0,0,1,0)
  character_fixture:setRestitution(.5)
  character_fixture:setFriction(.9)

  myEdgeBody2 = love.physics.newBody( world, 0,0 ,"static")
  myEdgeShape2 = love.physics.newEdgeShape(10, 500, 490, 505)
  myEdgeFixture2 = love.physics.newFixture(myEdgeBody2, myEdgeShape2)
  myEdgeFixture2:setUserData("edge2")

end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.line(myEdgeBody2:getWorldPoints(myEdgeShape2:getPoints()))
  love.graphics.circle("line", character_body:getX(), character_body:getY(),character_shape:getRadius())
end