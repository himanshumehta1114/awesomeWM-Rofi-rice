local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"

local styles = {}

styles.month = {
  padding = 20,
}

styles.normal = {
  fg_color = beautiful.fg_dark,
}

styles.focus = {
  fg_color = beautiful.fg_normal,
  markup = function(t)
    return "<b>" .. t .. "</b>"
  end,
  padding = 2,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
  end,
}

styles.header = {
  markup = function(t)
    return "<span font_desc='" .. beautiful.font_name .. " Bold 15" .. "'>" .. t .. "</span>"
  end,
}
styles.weekday = {}

local function decorate_cell(widget, flag, date)
  if flag == "monthheader" and not styles.monthheader then
    flag = "header"
  end
  local props = styles[flag] or {}
  if props.markup and widget.get_text and widget.set_markup then
    widget:set_markup(props.markup(widget:get_text()))
  end
  -- Change bg color for weekends
  local default_bg = beautiful.bg_dark
  local ret = wibox.widget {
    {
      widget,
      margins = (props.padding or 2) + (props.border_width or 0),
      widget = wibox.container.margin,
    },
    shape = props.shape,
    fg = props.fg_color or beautiful.fg_normal,
    bg = props.bg_color or default_bg,
    widget = wibox.container.background,
  }
  return ret
end

local calendar = awful.popup {
  widget = {
    widget = wibox.container.margin,
    margins = 7,
    {
      date = os.date "*t",
      spacing = 15,
      fn_embed = decorate_cell,
      widget = wibox.widget.calendar.month,
    },
  },
  bg = beautiful.bg_dark,
  visible = false,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  placement = function(c)
    (awful.placement.top_right)(c, { margins = { top = 50, right = 10 } })
  end,
  ontop = true,
}

local function toggle()
  calendar.visible = not calendar.visible
end

return toggle
