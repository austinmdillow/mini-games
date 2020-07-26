Item = Object:extend()

function Item:new()
  self.coord = nil
  self.image = sprites.player_img -- default image for an item
  self.isGarbage = false -- if true, it will be garbage collected in the map
  --print("Item Image", self.image)
end

function Item:setImage(im)
  self.image = im
end

function Item:update()
end

function Item:garbage()
  return self.isGarbage
end

function Item:cleanMe()
  self.isGarbage = true
end

function Item:draw()
  if self.coord ~= nil and self.image ~= nil then
    img_width, img_height = self.image:getDimensions()
    love.graphics.setColor(COLORS.white)
    love.graphics.draw(self.image, self.coord.x - img_width / 2, self.coord.y - img_height / 2)
  end
end

function Item:setPosition(x_set, y_set)
  if self.coord == nil then
    self.coord = Coord(x_set, y_set, 0)
  end
end

function Item:print()
  print(type(self), self, self.image)
end