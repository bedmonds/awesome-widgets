-- {{{ Standard libraries
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local vicious = require("vicious")
-- }}}

-- {{{ Functions
-- {{{ Autostart applications
function run_once( cmd )
   findme = cmd
   first_space = cmd:find(" ")
   if first_space then
      findme = cmd:sub(0, first_space - 1)
   end
   awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end
-- }}}
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Global variables
home_dir           = os.getenv("HOME")
config_dir         = home_dir .. "/.config/awesome"
script_dir         = config_dir .. "/scripts/"
theme_dir          = config_dir .. "/themes/"

terminal           = "roxterm"
editor             = "vim"
editor_cmd         = terminal .. " -e " .. editor
gui_editor         = "gvim"
music_player       = terminal .. " -e cmus"

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

widgets = {}
-- }}}

-- {{{ Local variables
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
}

-- }}}

-- {{{ Theme & Wallpaper
beautiful.init("/home/bedmonds/.config/awesome/themes/dark-matter/theme.lua")
beautiful.wallpaper = "/home/bedmonds/.wallpaper"

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ " WEB ", " TERMINAL ", " FILES ", " OTHER " }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

widgets.main_menu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = widgets.main_menu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Widget styling

-- Separators
spacer_left = wibox.widget.imagebox()
spacer_left:set_image( beautiful.left )
spacer = wibox.widget.imagebox()
spacer:set_image( beautiful.spr )
spacer_small = wibox.widget.imagebox()
spacer_small:set_image( beautiful.spr_small )

-- }}}

-- {{{ Wibox
-- Create a textclock widget

widgets.text_clock           = awful.widget.textclock()
widgets.tag_list             = {}
widgets.task_list            = {}
widgets.prompt_box           = awful.widget.prompt()
widgets.layout_box           = awful.widget.layoutbox(1)

widgets.tag_list.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

widgets.task_list.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
      if c == client.focus then
         c.minimized = true
      else
         -- Without this, the following
         -- :isvisible() makes no sense
         c.minimized = false
         if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
         end
         -- This will also un-minimize
         -- the client, if needed
            client.focus = c
            c:raise()
      end
   end),
   awful.button({ }, 3, function ()
      if instance then
         instance:hide()
         instance = nil
      else
         instance = awful.menu.clients({ width=250 })
      end
   end),
   awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
   end),
   awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
   end)
)

widgets.layout_box:buttons(
   awful.util.table.join(
      awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
      awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
   )
)

widgets.tag_list = awful.widget.taglist(1, awful.widget.taglist.filter.all, widgets.tag_list.buttons)

widgets.task_list = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, widgets.task_list.buttons)

-- Battery monitor
require ( 'laptop/batmon' )

-- Top bar
require( 'gui/top_bar' )

-- Bottom bar
require( 'gui/bottom_bar' )

-- }}}

-- Mouse bindings
require( 'bindings/mouse' )

-- Key bindings
require( 'bindings/keyboard' )

-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border.width,
                    border_color = beautiful.border.color_normal,
                    focus = awful.client.focus.filter,
                    keys = clientkeys,
                    buttons = clientbuttons } },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "chromium-browser" },
      properties = { tag = tags[1][1] } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    -- {{{ Title Bars
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
    -- }}}
end)

client.connect_signal("focus", function(c)
                                   c.border_color = beautiful.border.color_focus
                                   c.border_width = beautiful.border.width
                               end)
client.connect_signal("unfocus", function(c)
                                   c.border_color = beautiful.border.color_normal
                                   c.border_width = beautiful.border.width
                               end)

-- }}}
