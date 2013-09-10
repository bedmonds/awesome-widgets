local widgets      = widgets
local awful        = require('awful')
local wibox        = wibox
local beautiful    = beautiful

widgets.top_bar = awful.wibox({ position = "top", screen = 1, height = beautiful.top_bar.height, border_width = beautiful.top_bar.border_width })

local sep_left = wibox.widget.imagebox()
local sep_right = wibox.widget.imagebox()

sep_left:set_image( beautiful.images.separator_left )
sep_right:set_image( beautiful.images.separator_right )

local spacer = wibox.widget.imagebox()
spacer:set_image( beautiful.images.spacers.small )

-- Widgets that are aligned to the left
local left_layout = wibox.layout.fixed.horizontal()
left_layout:add( widgets.tag_list )
left_layout:add( spacer )
left_layout:add( sep_right )
left_layout:add( widgets.layout_box )
left_layout:add( spacer )
left_layout:add( widgets.prompt_box )
left_layout:add( sep_right )

-- Widgets that are aligned to the right
local right_layout = wibox.layout.fixed.horizontal()

right_layout:add( sep_left )
right_layout:add( wibox.widget.systray() )
right_layout:add( widgets.text_clock )
right_layout:add( sep_right )

-- Now bring it all together (with the tasklist in the middle)
local layout = wibox.layout.align.horizontal()
layout:set_left(left_layout)
layout:set_right(right_layout)

widgets.top_bar:set_widget(layout)
