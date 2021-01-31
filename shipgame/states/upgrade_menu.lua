upgrade_menu = {}

upgrade_progression = {
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
  }
}

upgrade_list = {}

function upgrade_menu:init()
  for key, attributes in pairs(upgrade_progression) do
    local tmp_upgrade = Upgrade(attributes.x, attributes.y)
    tmp_upgrade:setTitle(attributes.title)
    tmp_upgrade:setCost(attributes.cost)
    print(attributes.next)
    --table.insert(upgrade_list, tmp_upgrade)
    upgrade_list[key] = tmp_upgrade
  end

  for key, attributes in pairs(upgrade_progression) do
    if attributes.next ~= nil then
      assert(upgrade_list[attributes.next] ~= nil) -- the next upgrade object was never created
      upgrade_list[key].next = upgrade_list[attributes.next]
    end
    if attributes.previous ~= nil then
      assert(upgrade_list[attributes.previous] ~= nil) -- the previous upgrade object was never created
      upgrade_list[key].previous = upgrade_list[attributes.previous]
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
  love.graphics.print("Upgrades People", 10, 10)

  for key, upgrade in pairs(upgrade_list) do
    upgrade:draw()
    love.graphics.setColor(COLORS.yellow)

    local lead_in = 50
    if upgrade.next ~= nil then
      local start_x = upgrade.x + upgrade.width
      local start_y = upgrade.y + upgrade.height / 2
      local end_x = upgrade.next.x
      local end_y = upgrade.next.y + upgrade.next.height / 2
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