Item = Object:extend()

function Item:new()
  self.coord = nil
  self.image = sprites.player_img -- default image for an item
  print("Item Image", self.image)
end

function Item:setPosition(x_set, y_set)
  if self.coord == nil then
    self.coord = Coord(x_set, y_set, 0)
  end
end

function Item:print()
  print(type(self), self, self.image)
end