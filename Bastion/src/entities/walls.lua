Wall = Object:extend()
WoodWall = Wall:extend()
Steel_3x1 = Wall:extend()

function Wall:new(world, x, y, w, h)
  local wall_width = 50
  local wall_height = 20
  self.color = COLORS.red
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.shape = love.physics.newRectangleShape(wall_width, wall_height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setRestitution(0.3)
  self.fixture:setFriction(.7)
end

function Wall:draw()
  local x, y = self.body:getPosition()
  love.graphics.setColor(self.color)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  self:drawOutline()
end

function Wall:drawOutline()
  love.graphics.setColor(COLORS.black)
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

function WoodWall:new(world, x, y)
  WoodWall.super.new(self, world, x, y)
  self.color = COLORS.green
  self.fixture:setFriction(.5)
end

function Steel_3x1:new(world, x, y)
  WoodWall.super.new(self, world, x, y)
  self.color = COLORS.green
  self.fixture:setFriction(.1)
end
