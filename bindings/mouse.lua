local awful        = require( 'awful' )
local widgets      = widgets
local root         = root

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () widgets.main_menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
