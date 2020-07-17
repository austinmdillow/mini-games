Inventory = Object:extend()

function Inventory:new()
  self.slots = 4
  self.capacity_weight = 100
  self.item_list = {}
  self.active = false
  self.holding = nil
  self.holding_index = nil
end

function Inventory:addItem(item, index)
  -- check reasons why we shouldn't put the item here
  if index < 0 or index > self.slots then
    LOG_ERROR("index out of range on inventory")
    return false
  elseif self:hasItem(item) then
    print("item is in inventory")
    return false
  elseif self.item_list[index] ~= nil then
    print("this slot is full")
    return false
  elseif type(item) ~= type(Item) then
    print(type(item) , type(Item))
  else -- if all is well
    self.item_list[index] = item
    print("added", item, item.image)
    return true
  end

  return false -- not sure how we would get here so ...
end

function Inventory:removeItem(item) -- TODO
  for idx=1,self.slots do
    itm = self.item_list[idx]
    if itm == item then
      self.item_list[idx] = nil
      return true -- item removed
    end
  end
  return false -- we didn't remove the item
end

function Inventory:hasItem(item)
  for idx=1,self.slots do
    itm = self.item_list[idx]
    if itm == item then
      return true
    end
  end
  return false
end


function Inventory:update(dt)
  -- not sure if this is needed
  

end

function Inventory:mousepressed(x, y, key)
  local slot_spacing = 10
  if self:getActive() then
    if self.holding == nil then
      local x_start = frame_width / 2 - self.slots / 2 * ITEM_PIX_WIDTH + slot_spacing
      local y_start = frame_height - 80
      for idx=1,self.slots do
        if PointWithinRectangle(x_start, y_start, ITEM_PIX_WIDTH, ITEM_PIX_WIDTH, x, y) then
          print(idx)
          self.holding = self.item_list[idx]
          self.holding_index = idx
          self.item_list[idx] = nil
          return
        end
        x_start = x_start + slot_spacing + ITEM_PIX_WIDTH
      end
        
    else -- currently holding
      print("termination click")
      local x_start = frame_width / 2 - self.slots / 2 * ITEM_PIX_WIDTH + slot_spacing
      local y_start = frame_height - 80
      for idx=1,self.slots do
        if PointWithinRectangle(x_start, y_start, ITEM_PIX_WIDTH, ITEM_PIX_WIDTH, x, y) then
          print(idx)
          
          if self:addItem(self.holding, idx) then
            self.holding = nil
          end

        end
        x_start = x_start + slot_spacing + ITEM_PIX_WIDTH
      end

    end
  end

end

-- draw the inventory graphics and the items in the inventory
function Inventory:draw()
  local slot_spacing = 10
  

  -- draw the inventory items and background
  love.graphics.setColor(COLORS.white)
  local x_start = frame_width / 2 - self.slots / 2 * ITEM_PIX_WIDTH + slot_spacing
  local y_start = frame_height - 80
  for idx=1,self.slots do
    local item = self.item_list[idx]
    love.graphics.setColor(.7,.7,.7)
    love.graphics.rectangle('fill', x_start, y_start, ITEM_PIX_WIDTH, ITEM_PIX_WIDTH)
    love.graphics.setColor(.3,.3,.3)
    love.graphics.rectangle('line', x_start, y_start, ITEM_PIX_WIDTH, ITEM_PIX_WIDTH)
    resetColor()
    if item ~= nil then
      if item.image ~= nil then -- make sure that there is an item to draw
        love.graphics.draw(item.image, x_start, y_start)
      end
      --print(item.image, x_start)
    end
    x_start = x_start + slot_spacing + ITEM_PIX_WIDTH
  end

  -- draw item if it's being held
  if self.holding ~= nil then
    local x_img, y_img = love.mouse.getPosition()
    x_img = x_img - ITEM_PIX_WIDTH / 2
    y_img = y_img - ITEM_PIX_WIDTH / 2
    love.graphics.draw(self.holding.image, x_img, y_img)
  end


end

function Inventory:drawUI()
  -- TODO
end

function Inventory:getActive()
  return self.active
end

function Inventory:setActive(active)
  if type(active) == "boolean" then
    self.active = active
    --print(active)
  else
    LOG_ERROR("wrong type passed to Inventory:setActive(active)")
  end
end