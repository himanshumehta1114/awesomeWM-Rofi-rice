local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"
local gears = require "gears"
local net_widgets = require "net_widgets"

local net_wireless = net_widgets.wireless()

local battery = wibox.widget {
  bg = beautiful.bg_normal,
  fg = beautiful.fg_bat,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 9)
  end,
  widget = wibox.container.background,
  {
    {
      widget = awful.widget.watch("cat /sys/class/power_supply/BAT0/capacity", 30),
    },
    left = 7,
    right = 7,
    top = 5,
    bottom = 5,
    widget = wibox.container.margin,
  },
}

local time = wibox.widget {
  bg = beautiful.bg_normal,
  fg = beautiful.fg_time,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 9)
  end,
  widget = wibox.container.background,
  buttons = {
    awful.button({}, 1, function()
      require "ui.widget.calendar"()
    end),
  },
  {
    widget = wibox.widget.textclock,
  },
}

local layoutbox = wibox.widget {
  bg = beautiful.bg_normal,
  fg = beautiful.fg_time,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 9)
  end,
  widget = wibox.container.background,
  buttons = {
    awful.button({}, 1, function()
      require "ui.widget.layoutlist"()
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end),
  },
  {
    widget = wibox.container.margin,

    margins = 7.5,
    {
      widget = awful.widget.layoutbox,
    },
  },
}

screen.connect_signal("request::desktop_decoration", function(s)
  local l = awful.layout.suit
  awful.tag(
    { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    s,
    { l.attached, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile }
  )
  awful.popup({
    bg = beautiful.bg_dark,
    placement = function(c)
      (awful.placement.top + awful.placement.maximize_horizontally)(c)
    end,
    screen = s,
    widget = {
      {
        {
          {
            widget = require "ui.bar.attached.taglist"(s),
          },
          widget = wibox.container.margin,
          margins = 5,
        },
        {
          widget = wibox.container.place,
          halign = "center",
          {
            widget = require "ui.bar.attached.tasklist"(s),
          },
        },
        {
          { widget = net_wireless },
          { widget = battery },
          { widget = time },
          { widget = layoutbox },
          layout = wibox.layout.fixed.horizontal,
          spacing = 10,
          bottom = 10,
        },
        layout = wibox.layout.align.horizontal,
        forced_height = 30,
      },
      widget = wibox.container.margin,
      margins = 7,
    },
  }):struts { top = 40 }
end)
