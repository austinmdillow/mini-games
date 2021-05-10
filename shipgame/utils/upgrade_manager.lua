-- Handles all upgrades

UpgradeManager = Object:extend()


function UpgradeManager:new()
  self.unlock_flags = {}
  self.upgrade_nodes = {}
  self.messages = {}
end

function UpgradeManager:update(dt)
  for key, node in pairs(self.upgrade_nodes) do
    node:update(dt)
  end
  --self:printUnlockFlags()
end

function UpgradeManager:draw()

end

function UpgradeManager:addMessage(msg)
  table.insert(self.messages)
end

function UpgradeManager:getNodeList()
  return self.upgrade_nodes
end


-- create upgrade nodes using a given progression table
function UpgradeManager:loadUpgrades(progression_table)
  for key, progression in pairs(progression_table) do
    local tmp_upgrade = Upgrade(progression.x, progression.y)
    tmp_upgrade:setTitle(progression.title)
    tmp_upgrade:setDescription(progression.description)
    tmp_upgrade:setCost(progression.cost)
    tmp_upgrade:setResult(progression.flag, progression.multiplier, progression.increase)
    self.upgrade_nodes[key] = tmp_upgrade
  end

  for key, progression in pairs(progression_table) do
    if progression.next ~= nil then
      for _,next_key in pairs(progression.next) do
        assert(self.upgrade_nodes[next_key] ~= nil) -- the next upgrade object was never created
        table.insert(self.upgrade_nodes[key].next, self.upgrade_nodes[next_key]) -- add the next object to the current object
        table.insert(self.upgrade_nodes[next_key].previous, self.upgrade_nodes[key]) -- add the current object to the next objects previous list
      end

    end
  end

end

function UpgradeManager:mousereleased(x, y, mouse_btn)
  for key, node in pairs(self.upgrade_nodes) do
    local mouse_x, mouse_y = upgrade_menu.camera:mousePosition()
    if node:mousereleased(mouse_x, mouse_y, mouse_btn) then -- pass the released coordinates to the individual upgrade objects
      if node.flag ~= nil then
        local m_new, a_new = node:getModifiers()
        if self.unlock_flags[node.flag] ~= nil then
          self.unlock_flags[node.flag][1] = self.unlock_flags[node.flag][1] * m_new
          self.unlock_flags[node.flag][2] = self.unlock_flags[node.flag][2] + a_new
        else
          self.unlock_flags[node.flag] = {m_new, a_new}
        end
      end
    end
  end
end

function UpgradeManager:getModifiers(unlock_flag)
  local mods = self.unlock_flags[unlock_flag] or {}
  local m = mods[1] or 1
  local a = mods[2] or 0
  return m, a
end

function UpgradeManager:isUnlocked(unlock_flag)
  return self.unlock_flags[unlock_flag] ~= nil
end

function UpgradeManager:getCrafting()
  return nil
end

function UpgradeManager:printUnlockFlags()
  print("Printing Unlock flags")
  for key, val in pairs(self.unlock_flags) do
    print(key, val)
  end
end