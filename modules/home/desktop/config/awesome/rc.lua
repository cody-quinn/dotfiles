-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty") -- Notification library

-- Widgets I plan on using
local textbat = require("libs.textbat")
local textclock = wibox.widget.textclock

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical, title = "Oops, there were errors during startup!", text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical, title = "Oops, an error happened!", text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
browser = "qutebrowser"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = { awful.layout.suit.tile }
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function(c) c:emit_signal("request::activate", "tasklist", {raise = true}) end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.centered(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            textbat("BAT0", "%d%%  "),
            textclock(" %a %b %d, %I:%M:%S %p ", 1),
        },
    }
end)
-- }}}

function spawn_proc(s)
    return function() 
        awful.spawn(s)
    end
end

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- AwesomeWM Specific
    awful.key({ modkey, "Control", "Shift" }, "r", awesome.restart),
    awful.key({ modkey, "Control", "Shift" }, "q", awesome.quit),

    -- Brightness & media controls
    awful.key({ }, "XF86MonBrightnessUp",      spawn_proc("brightnessctl set +5%")),
    awful.key({ }, "XF86MonBrightnessDown",    spawn_proc("brightnessctl set 5%-")),

    awful.key({ }, "XF86AudioMute",            spawn_proc("pamixer -t")),
    awful.key({ }, "XF86AudioRaiseVolume",     spawn_proc("pamixer -i 5")),
    awful.key({ }, "XF86AudioLowerVolume",     spawn_proc("pamixer -d 5")),
    awful.key({ }, "XF86AudioMicMute",         spawn_proc("pamixer --default-source -t")),

    awful.key({ }, "XF86AudioPrev",            spawn_proc("playerctl previous")),
    awful.key({ }, "XF86AudioNext",            spawn_proc("playerctl next")),
    awful.key({ }, "XF86AudioPlay",            spawn_proc("playerctl play-pause")),
    awful.key({ }, "XF86AudioPause",           spawn_proc("playerctl play-pause")),

    -- Media controls for keyboards without dedicated keys
    awful.key({ modkey,           }, "Left",   spawn_proc("playerctl previous")),
    awful.key({ modkey,           }, "Right",  spawn_proc("playerctl next")),
    awful.key({ modkey,           }, "Down",   spawn_proc("playerctl play-pause")),

    -- Focused window changing
    awful.key({ modkey,           }, "j",      function () awful.client.focus.byidx( 1) end),
    awful.key({ modkey,           }, "k",      function () awful.client.focus.byidx(-1) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",      function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k",      function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j",      function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k",      function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u",      awful.client.urgent.jumpto),

    -- Standard programs
    awful.key({ modkey, "Shift"   }, "Return", spawn_proc(terminal)),
    awful.key({ modkey, "Shift"   }, "h",      spawn_proc(terminal.." -e htop")),
    awful.key({ modkey, "Shift"   }, "p",      spawn_proc(terminal.." -e python")),
    awful.key({ modkey, "Shift"   }, "e",      spawn_proc(browser)),
    awful.key({ modkey, "Shift"   }, "s",      spawn_proc("flameshot gui")),
    awful.key({ modkey, "Shift"   }, "d",      spawn_proc("discord")),
    awful.key({ modkey, "Shift"   }, "l",      spawn_proc("slock")),
    awful.key({ modkey, "Shift"   }, "m",      spawn_proc("polymc")),
    awful.key({ modkey, "Shift"   }, "f",      spawn_proc("nautilus")),
    awful.key({ modkey, "Shift"   }, "n",      spawn_proc("neovide")),

    awful.key({ modkey            }, "p",      spawn_proc("rofi -show drun")),
    awful.key({ modkey            }, "o",      spawn_proc("rofi -show run")),
    awful.key({ modkey            }, "e",      spawn_proc("rofimoji -a copy")),

    -- Master/stack sizing manipulation
    awful.key({ modkey,           }, "l",      function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey,           }, "h",      function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Mod1"    }, "h",      function () awful.tag.incnmaster( 1, nil, true) end),
    awful.key({ modkey, "Mod1"    }, "l",      function () awful.tag.incnmaster(-1, nil, true) end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1, nil, true) end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1, nil, true) end)
)

clientkeys = gears.table.join(
    awful.key({ modkey, "Control" }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill() end),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "space",  awful.client.floating.toggle),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen() end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
function tag_view(i, inner) 
    return function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            inner(tag)
        end
    end
end

function tag_move(i, inner) 
    return function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                inner(tag)
            end
        end
    end
end

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey                     }, "#" .. i + 9, tag_view(i, function(tag) tag:view_only() end)),
        awful.key({ modkey, "Control"          }, "#" .. i + 9, tag_view(i, function(tag) awful.tag.viewtoggle(tag) end)),
        awful.key({ modkey, "Shift"            }, "#" .. i + 9, tag_move(i, function(tag) client.focus:move_to_tag(tag) end)),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function() client.focus:move_to_screen(i) end)
    )
end

clientbuttons = gears.table.join(
    awful.button({        }, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
    awful.button({ modkey }, 2, awful.client.floating.toggle),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    { 
        rule = { },
        properties = { 
            border_width = 0,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            titlebars_enabled = false 
        } 
    },
    { 
        rule_any = { role = { "pop-up" } },
        properties = { floating = true }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then 
        awful.client.setslave(c) 
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)
-- }}}
