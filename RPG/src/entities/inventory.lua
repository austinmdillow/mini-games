Inventory = Object:extend()

function Inventory:new()
  self.slots = 4
  self.capacity_weight = 100
  self.item_list = {}
  self.active = false
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

function Inventory:removeItem() -- TODO
end

function Inventory:hasItem(item)
  for index, itm in ipairs(self.item_list) do
    if itm == item then
      return true
    end
  end
  return false
end


function Inventory:update(dt)
  -- not sure if this is needed
end

-- draw the inventory graphics and the items in the inventory
function Inventory:draw()
  love.graphics.setColor(COLORS.white)
  local x_start = 50
  local y_start = 200
  for idx=1,self.slots do
    local item = self.item_list[idx]
    if item.image ~= nil then -- make sure that there is an item to draw
      love.graphics.draw(item.image, x_start, y_start)
    end
    print(item.image, x_start)
    x_start = x_start + 100
  end
end

function Inventory:getActive()
  return self.active
end

function Inventory:setActive(active)
  if type(active) == "boolean" then
    self.active = active
    print(active)
  else
    LOG_ERROR("wrong type passed to Inventory:setActive(active)")
  end
end