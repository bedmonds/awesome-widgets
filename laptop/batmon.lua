--
-- batmon - Battery monitor widget for Awesome WM
-- [github.com/bedmonds/awesome-widget-batmon.git]
--
local io = io
local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = beautiful
batmon = {}

batmon.config = {
   device = "BAT0",
   glyphs = {
      charging = "[+]",
      draining = "[-]",
      full     = "[*]",
      none     = "[X]",
   },
}

batmon.widget = wibox.widget.textbox()

function batmon:get_state_glyph()
   local batmon = batmon
   local file = io.open("/sys/class/power_supply/" .. batmon.config.device .. "/status", "r")

   if ( file == nil ) then
      return batmon.config.glyphs.none
   end

   local state = file:read("*line")
   file:close()

   if ( state == "Discharging" ) then
      return batmon.config.glyphs.draining
   elseif ( state == "Charging" ) then
      return batmon.config.glyphs.charging
   else
      return batmon.config.glyphs.full
   end
end


if ( beautiful.colorize_text ~= nil ) then
   vicious.register( batmon.widget, vicious.widgets.bat, beautiful:colorize_text( batmon:get_state_glyph() .. " $2%", beautiful.colors.light_blue ), 30, batmon.config.device )
else
   vicious.register( batmon.widget, vicious.widgets.bat, batmon:get_state_glyph() .. " $2%", 30, batmon.config.device )
end
