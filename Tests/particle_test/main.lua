--copy this

function love.load()
  --it does not matter what your picture for the particle is named I just like to use index.
  local img = love.graphics.newImage("particle.png")
  
  --this is us setting our new particle system
  pSystem = love.graphics.newParticleSystem(img, 100)
  pSystem:setParticleLifetime(1, 2) -- Particles live at least 2s and at most 5s.
	pSystem:setEmissionRate(10)
  pSystem:setSizeVariation(1)
  pSystem:setSizes(5)
  pSystem:setSpeed(100,100)
  pSystem:setDirection(1)
  pSystem:setSpin(1,1)
	--pSystem:setLinearAcceleration(0, -20, 0, 200) -- Random movement in all directions.
	pSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
end

function love.draw()
  --this draws our particles
  --in just a second I will explain why we are getting the mouses position
  love.graphics.draw(pSystem, 0, 0)
end

function love.update(dt)
  --this will update our particle system
  pSystem:update(dt)
  pSystem:moveTo(love.mouse.getX(), love.mouse.getY())
end

function love.keypressed(key)
  if key == "space" then
    print("s")
    pSystem:emit(50)
  end
end