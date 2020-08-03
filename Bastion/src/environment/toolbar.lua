Toolbar = Object:extend()
local dummy_world = love.physics.newWorld(0, 0, true)
material_options = {
  wood_3x1 = 0,
  steel_3x1 = 1,
  wood = Wall(dummy_world, 0, 0),
  steel = Steel_3x1(dummy_world, 0, 0),
}

function Toolbar:new()
  
  self.materials = {
    wood_3x1 = {
      x = frame_width - 40,
      y = 40,
      width = 20, 
      height = 20,
      color = COLORS.red,
    },
    steel_3x1 = {
      x = frame_width - 40,
      y = 80,
      width = 20, 
      height = 20,
      color = COLORS.green,
    }
  }
  self.selection = nil
end

function Toolbar:getSelection()
  return self.selection
end

function Toolbar:setSelection(sel)
  self.selection = sel

end

function Toolbar:draw()
  local width = 40
  local x_loc = frame_width - width
  love.graphics.setColor(.6,.6, .6)
  love.graphics.rectangle('fill', x_loc, 0, width, frame_height)

  for k,material in pairs(self.materials) do
    love.graphics.setColor(material.color)
    love.graphics.rectangle('fill', material.x, material.y, material.width, material.height)
  end
end

function Toolbar:mousepressed(x, y, button, istouch, presses)
  if PointWithinRectangle(self.materials.wood_3x1.x, self.materials.wood_3x1.y, self.materials.wood_3x1.width, self.materials.wood_3x1.height, x, y) then
    self.selection = material_options.wood_3x1
    return true
  elseif PointWithinRectangle(self.materials.steel_3x1.x, self.materials.steel_3x1.y, self.materials.steel_3x1.width, self.materials.steel_3x1.height, x, y) then
    self.selection = material_options.steel_3x1
    return true
  end
  return false
end