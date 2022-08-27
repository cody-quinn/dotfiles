local setmetatable = setmetatable
local os = os
local textbox = require("wibox.widget.textbox")
local timer = require("gears.timer")
local gtable = require("gears.table")

local textbat = { mt = {} }

function textbat:force_update()
    self._timer:emit_signal("timeout")
end

local function calc_timeout(real_timeout)
    return real_timeout - os.time() % real_timeout
end

local function read_file(path)
    local file = io.open(path, "r")
    local content = file:read("*all")
    file:close()
    return content
end

local function new(battery, format, refresh)
    local w = textbox()
    gtable.crush(w, textbat, true)

    w._private.battery = "/sys/class/power_supply/"..battery.."/"
    w._private.format = format or " %d%% "
    w._private.refresh = refresh or 60

    function w._private.textbat_update_cb()
        local current = tonumber(read_file(w._private.battery.."energy_now"))
        local capacity = tonumber(read_file(w._private.battery.."energy_full"))
        local str = string.format(w._private.format, (current / capacity) * 100)
        w:set_markup(str)
        w._timer.timeout = calc_timeout(w._private.refresh)
        w._timer:again()
        return true -- Continue the timer
    end

    w._timer = timer.weak_start_new(refresh, w._private.textbat_update_cb)
    w:force_update()
    return w
end

function textbat.mt:__call(...)
    return new(...)
end

return setmetatable(textbat, textbat.mt)
