upgrade_menu = {}

local upgrade_progression = {
  speed_1 = {
    x = 100,
    y = 100,
    title = "speed number 1",
    cost = 4,
    next = "speed_2"

  },
  speed_2 = {
    x = 400,
    y = 200,
    title = "Speed number 2",
    previous = "speed_1",
    cost = 23
  },
  armor_1 = {
    x = 400,
    y = 400,
    title = "armor 1",
    previous = nil,
    next = "armor_2",
    cost = 23,
    target = "max_health",
    multiplier = 1.2
  },
  armor_2 = {
    x = 600,
    y = 200,
    title = "armor 2",
    previous = "armor_1",
    prerequisite = "crafting_1",
    cost = 23
  },
  armor_3 = {
    x = 700,
    y = 500,
    title = "armor 3",
    previous = "armor_1",
    prerequisite = "crafting_1",
    cost = 23
  },
  crafting_1 = {
    x = 800,
    y = 200,
    title = "Crafting ability",
    previous = nil,
    cost = 100
  }
}

upgrade_list = {}

function upgrade_menu:init()
  for key, progrssion in pairs(upgrade_progression) do
    local tmp_upgrade = Upgrade(progrssion.x, progrssion.y)
    tmp_upgrade:setTitle(progrssion.title)
    tmp_upgrade:setCost(progrssion.cost)
    tmp_upgrade:setResult(progrssion.target, progrssion.multiplier, progrssion.adder)
    print(progrssion.next)
    --table.insert(upgrade_list, tmp_upgrade)
    upgrade_list[key] = tmp_upgrade
  end

  for key, progrssion in pairs(upgrade_progression) do
    if progrssion.next ~= nil then
      assert(upgrade_list[progrssion.next] ~= nil) -- the next upgrade object was never created
      table.insert(upgrade_list[key].next, upgrade_list[progrssion.next]) -- add the next object to the current object
      table.insert(upgrade_list[progrssion.next].previous, upgrade_list[key])
    end
  end

  for key, upgrade in pairs(upgrade_list) do
    print(key, upgrade)
  end
end

function upgrade_menu:update(dt)
  for key, upgrade in pairs(upgrade_list) do
    upgrade:update(dt)
  end
end

function upgrade_menu:draw()
  love.graphics.setColor(COLORS.orange)
  love.graphics.print("U", 10, 10)

  for key, upgrade in pairs(upgrade_list) do
    upgrade:draw()
    love.graphics.setColor(COLORS.yellow)

    local lead_in = 50
    for _, next_upgrade in pairs(upgrade.next) do
      local start_x = upgrade:getX() + upgrade.width
      local start_y = upgrade:getY() + upgrade.height / 2
      local end_x = next_upgrade:getX()
      local end_y = next_upgrade:getY() + next_upgrade.height / 2
      local curve = love.math.newBezierCurve({start_x,start_y, start_x + lead_in,start_y, end_x - lead_in, end_y, end_x,end_y})
      love.graphics.line(curve:render())
    end
  end
end

function upgrade_menu:mousereleased(x,y, mouse_btn)
  for key, upgrade in pairs(upgrade_list) do
    upgrade:mousereleased(x,y, mouse_btn)
  end
end

function upgrade_menu:keypressed(key)
  if key == "escape" then
    Gamestate.pop()
  end
end



return upgrade_menu