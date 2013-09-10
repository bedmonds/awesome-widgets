--
-- Dark Matter - Awesome WM 3.5+ Theme
-- [github.com/bedmonds/awesome-dark-matter.git]
--

local os = os

theme = {}

theme.image_dir = os.getenv('HOME') .. "/.config/awesome/themes/dark-matter/images"
-- theme.wallpaper_dir          = OS.getenv('HOME') .. "/.config/awesome/themes/dark-matter/wallpaper"

theme.font                   = "Liberation Sans 9"
theme.taglist_font           = "Liberation Sans 8"

theme.fg_normal              = "#FFFFFF"
theme.fg_focus               = "#0099CC"
theme.bg_normal              = "#242424"
theme.fg_urgent              = "#FF0000"
theme.bg_urgent              = "#FFFFFF"

theme.border = {
   width                     = 1,
   color_normal              = "#252525",
   color_focus               = "#505050",
}

theme.colors = {
   white                     = "#F0F0FC",
   light_gray                = "#CCCCCC",
   black                     = "#202020",
   light_blue                = "#16B5FD",
   dark_blue                 = "#224466",
}

theme.top_bar = {
   height                    = 24,
   border_width              = 1,
}

theme.bottom_bar = {
   height                    = 24,
   border_width              = 1,
   background                = '#202020'
}

theme.images = {
   separator_right           = theme.image_dir .. "/separator.png",
   separator_left            = theme.image_dir .. "/separator_left.png",
   spacers = {
      small                  = theme.image_dir .. "/spacer_small.png",
   },
   icons = {
      clock                  = theme.icon_dir .. "/clock.png",
      calendar               = theme.icon_dir .. "/calendar.png",
      battery = {
         full                = theme.icon_dir .. "/battery_full.png",
         half                = theme.icon_dir .. "/battery_half.png",
         low                 = theme.icon_dir .. "/battery_low.png",
         charging            = theme.icon_dir .. "/battery_charging.png"
      },
      mplayer = {
         play                = theme.icon_dir .. "/play.png",
         pause               = theme.icon_dir .. "/pause.png",
         stop                = theme.icon_dir .. "/stop.png",
         playing             = theme.icon_dir .. "/playing.png",
         stopped             = theme.icon_dir .. "/stopped.png"
   },
}

theme.taglist_fg_normal      = theme.colors.light_gray
theme.taglist_fg_focus       = theme.colors.white

theme.taglist_squares_sel    = theme.image_dir .. "/tag_focus.png"
theme.taglist_squares_unsel  = theme.image_dir .. "/tag_hasclients.png"

theme.tasklist_bg_normal     = "#202020"
theme.tasklist_fg_focus      = "#4CB7DB"
theme.tasklist_bg_focus      = "#444444"

theme.textbox_widget_margin_top = 1
theme.awful_widget_height       = 14
theme.awful_widget_margin_top   = 2

theme.menu_height               = "20"
theme.menu_width                = "400"

function theme:colorize_text( text, color )
   return "<span color=\"" .. color .. "\">" .. text .. "</span>"
end

return theme
