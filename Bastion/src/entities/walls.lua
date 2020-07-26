Wall = Object:extend()

function Wall:new(world, x, y)
  local wall_width = 50
  local wall_height = 20
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.shape = love.physics.newRectangleShape(wall_width, wall_height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setRestitution(0.3)
  self.fixture:setFriction(.7)
end