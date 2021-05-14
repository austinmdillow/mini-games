--[[ A library for logging output for consumption by the dev or the game
{
    message,
    timestamp,
    level
}


print level is the level at which logged output will print to the terminal
 ]]

Logger = Object:extend()
function Logger:new(print_level)
    self.print_level = print_level or 1
    self.log_table = {}
    print("Starting logger with log level " .. self.print_level)
end


function Logger:log(msg, lev)
    local msg_level = lev or self.print_level
    print(lev, msg, "pdpspd")
    local tmp_message = {timestamp = love.timer.getTime(), message = msg, level = msg_level}

    if type(tmp_message.level) == "number" then
        if tmp_message.level <= self.print_level then
            self:_printMessage(tmp_message)
        end
    end
    table.insert(self.log_table, tmp_message)
end

-- prints all logged events from first to last
-- if no type is given, all are printed
function Logger:printAll(type_name)
    for i = #self.log_table, 1, -1 do
        entry = self.log_table[i]
        if type_name == nil or type_name == entry.level then
            self:_printMessage(entry)
        end
    end
end

function Logger:print(type_name)
    for i = #self.log_table, 1, -1 do
        entry = self.log_table[i]
        if type_name == nil or type_name == entry.level then
            self:_printMessage(entry)
            return
        end
        
    end
end

function Logger:_printMessage(msg)
    print(msg.timestamp, msg.level, msg.message)
end

function Logger:get(type_name)
    for i = #self.log_table, 1, -1 do
        entry = self.log_table[i]
        if type_name == nil or type_name == entry.level then
            return entry
        end
    end
end