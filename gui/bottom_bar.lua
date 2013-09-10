local beautiful    = beautiful
local awful        = require( 'awful' )
local wibox        = wibox
local widgets      = widgets
local batmon       = batmon

widgets.bottom_bar = awful.wibox({
   position        = "bottom",
   screen          = 1,
   border_width    = beautiful.bottom_bar.border_width,
   height          = beautiful.bottom_bar.height
})

local batmon       = batmon
local sep_left     = wibox.widget.imagebox()
local sep_right    = wibox.widget.imagebox()

sep_right:set_image( beautiful.images.separator_right )
sep_left:set_image( beautiful.images.separator_left )

bottom_right = wibox.layout.fixed.horizontal()
bottom_right:add( sep_left )
bottom_right:add( batmon.widget )
bottom_right:add( sep_right )

bottom_layout = wibox.layout.align.horizontal()
bottom_layout:set_middle( widgets.task_list )
bottom_layout:set_right( bottom_right )

widgets.bottom_bar:set_widget( bottom_layout )
widgets.bottom_bar:set_bg( beautiful.bottom_bar.background )
