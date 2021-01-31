Upgrade = Object:extend()


function Upgrade:new(x, y)
  self.x = x
  self.y = y
  self.previous = nil -- what is needed for this unlock
  self.next = nil -- what this upgrade will unlock
  self.cost = 100 -- how much this upgrade will cost
  self.title = "default upgrade"
  self.description = "This is a placeholder for a more detailed description"
  self.width = 100
  self.height = 150
  self.unlocked = false
end

function Upgrade:update(dt)
end

function Upgrade:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.setColor(.6,.6,.6)
  love.graphics.rectangle('fill', 0, 0, self.width, self.height)

  -- draw unlocked vs locked
  if self.unlocked then
    love.graphics.setColor(COLORS.green)
  else
    love.graphics.setColor(COLORS.red)
  end
  love.graphics.rectangle('line', 0, 0, self.width, self.height)

  -- draw text
  love.graphics.setColor(COLORS.blue)
  love.graphics.print(self.title, 10, 10)
  love.graphics.pop()
end

function Upgrade:pointInBox()
  local tx, ty = love.mouse.getPosition()
  return PointWithinRectangle(self.x, self.y, self.width, self.height, tx, ty)
end 

function Upgrade:mousereleased(x,y, mouse_btn)
  if self:pointInBox() then
    print("Upgrade: mouse released inside ", self.title)
    print(self.previous, self.next)

    -- check if unlock is available
    if self.previous == nil or self.previous:isUnlocked() then
      local title = "Confirm Upgrade"
      local message = "Are you sure you want to spend " .. self.cost .. " coins to upgrade?"
      local buttons = {"Hell yeah!", "No thanks", escapebutton = 0, enterbutton = 0}
      local pressedbutton = love.window.showMessageBox(title, message, buttons, "warning")
      print(pressedbutton)
      if pressedbutton == 1 then
        self.unlocked = true
      end
    end
  end
end

function Upgrade:setTitle(title)
  assert(type(title) == "string")
  self.title = title
end

function Upgrade:setCost(cost)
  assert(type(cost) == "number")
  self.cost = cost
end

function Upgrade:setPrevious(upgrade)
  assert(upgrade:is(Upgrade))
  self.previous = upgrade
end

function Upgrade:setNext(upgrade)
  assert(upgrade:is(Upgrade))
  self.next = upgrade
end

function Upgrade:setResult(target, multiplier, adder)
  if target ~= nil then
    local m = multiplier or 1
    local a = adder or 0
    print(target, m, a)
    game_data.local_player[target] = game_data.local_player[target] * m + a
  end
end

function Upgrade:isUnlocked()
  return self.unlocked
end