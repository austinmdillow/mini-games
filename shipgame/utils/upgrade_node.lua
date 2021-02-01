Upgrade = Object:extend()


function Upgrade:new(x_home, y_home)
  self.x_home = x_home
  self.y_home = y_home
  self.x = self.x_home + 100
  self.x_vel = 0
  self.y = self.y_home
  self.previous = nil -- what is needed for this unlock
  self.nex_homet = nil -- what this upgrade will unlock
  self.cost = 100 -- how much this upgrade will cost
  self.title = "default upgrade"
  self.description = "This is a placeholder for a more detailed description"
  self.width = 100
  self.height = 150
  self.unlocked = false
  self.oscillation_offset_x = love.math.random(2 * math.pi)
  self.oscillation_offset_y = love.math.random(2 * math.pi)
  self.oscillation_amount_x = love.math.random(-10, 10)
  self.oscillation_amount_y = love.math.random(-10, 10)
end

function Upgrade:update(dt)
  if dt < 1 / 30 then -- make sure we don't do these calcs in a paused state
    self.x_vel = self.x_vel + .1*love.math.randomNormal(10, self.x_home - self.x) * dt
    --self.x = self.x + self.x_vel * dt
    self.x = self.x_home + self.oscillation_amount_x * math.cos(love.timer.getTime() + self.oscillation_offset_x)
    self.y = self.y_home + self.oscillation_amount_y * math.cos(love.timer.getTime() + self.oscillation_offset_y)
  end
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

  -- draw tex_homet
  love.graphics.setColor(COLORS.blue)
  love.graphics.print(self.title, 10, 10)
  love.graphics.pop()
end

function Upgrade:pointInBox_home()
  local tx_home, ty = love.mouse.getPosition()
  return PointWithinRectangle(self.x, self.y, self.width, self.height, tx_home, ty)
end 

function Upgrade:mousereleased(x,y, mouse_btn)
  if self:pointInBox_home() then
    print("Upgrade: mouse released inside ", self.title)
    print(self.previous, self.nex_homet)

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

function Upgrade:setNex_homet(upgrade)
  assert(upgrade:is(Upgrade))
  self.nex_homet = upgrade
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

function Upgrade:getPosition()
  return self:getX(), self:getY()
end

function Upgrade:getY()
  return self.y
end

function Upgrade:getX()
  return self.x
end