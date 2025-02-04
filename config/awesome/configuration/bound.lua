local awful = require "awful"
local machi = require "modules.layout-machi"
local xrandr = require("xrandr")

-- Mouse bindings
awful.mouse.append_global_mousebindings {
  awful.button({}, 3, function()
    Menu.main:toggle()
  end),
}

-- Key bindings

-- General Utilities
awful.keyboard.append_global_keybindings {
  -- Screenshot
  awful.key({}, "Print", function()
    awful.spawn "scr screen"
  end),
  awful.key({ "Shift" }, "Print", function()
    awful.spawn "scr selection"
  end),
  awful.key({ "Control" }, "Print", function()
    awful.spawn "scr window"
  end),
  awful.key({ modkey }, "Print", function()
    awful.spawn "scr screentoclip"
  end),
  awful.key({ modkey, "Shift" }, "Print", function()
    awful.spawn "scr selectiontoclip"
  end),
  awful.key({ modkey, "Control" }, "Print", function()
    awful.spawn "scr windowtoclip"
  end),

  -- XF86 keys
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"
  end),
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"
  end),
}

-- General Awesome keys
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, "w", function()
    Menu.main:show()
  end, {
    description = "show main menu",
    group = "awesome",
  }),
  awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey }, "Return", function()
    awful.spawn(terminal)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),
  awful.key({ modkey }, "r", function()
    awful.spawn.with_shell("rofi -show filebrowser &>> /tmp/rofi.log")
  end, {
    description = "run prompt",
    group = "launcher",
  }),
  awful.key({ modkey }, "space", function()
    awful.spawn.with_shell("rofi -show drun &>> /tmp/rofi.log")
  end, {
    description = "run prompt",
    group = "launcher",
  }),
  awful.key({ modkey }, "a", function()
    require "ui.sidebar"()
  end),
  awful.key({ modkey }, "s", function()
    require "ui.action_center"()
  end),
}

-- Tags related keybindings
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
  awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
}

-- Focus related keybindings
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "client",
  }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "client",
  }),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, {
    description = "go back",
    group = "client",
  }),
}

-- Layout related keybindings
awful.keyboard.append_global_keybindings {
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, {
    description = "swap with next client by index",
    group = "client",
  }),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, {
    description = "swap with previous client by index",
    group = "client",
  }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey }, "l", function()
    awful.tag.incmwfact(0.05)
  end, {
    description = "increase master width factor",
    group = "layout",
  }),
  awful.key({ modkey }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, {
    description = "decrease master width factor",
    group = "layout",
  }),
}

awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers = { modkey },
    keygroup = "numrow",
    description = "only view tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Shift" },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Control", "Shift" },
    keygroup = "numrow",
    description = "toggle focused client on tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers = { modkey },
    keygroup = "numpad",
    description = "select layout directly",
    group = "layout",
    on_press = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  },
  awful.key({ modkey }, "d", function() xrandr.xrandr() end)
}

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings {
    awful.button({}, 1, function(c)
      c:activate { context = "mouse_click" }
    end),
    awful.button({ modkey }, 1, function(c)
      c:activate { context = "mouse_click", action = "mouse_move" }
    end),
    awful.button({ modkey }, 3, function(c)
      c:activate { context = "mouse_click", action = "mouse_resize" }
    end),
  }
end)

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings {
    awful.key({ modkey }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, {
      description = "toggle fullscreen",
      group = "client",
    }),
    awful.key({ modkey, "Shift" }, "c", function(c)
      c:kill()
    end, {
      description = "close",
      group = "client",
    }),
    awful.key(
      { modkey, "Shift" },
      "space",
      awful.client.floating.toggle,
      { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "Return", function(c)
      c:swap(awful.client.getmaster())
    end, {
      description = "move to master",
      group = "client",
    }),
    awful.key({ modkey }, "t", function(c)
      c.ontop = not c.ontop
    end, {
      description = "toggle keep on top",
      group = "client",
    }),
    awful.key({ modkey }, "n", function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end, {
      description = "minimize",
      group = "client",
    }),
    awful.key({ modkey }, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end, {
      description = "(un)maximize",
      group = "client",
    }),
  }
end)

-- Layout Machi
awful.keyboard.append_global_keybindings {
  awful.key({ modkey }, ".", function()
    machi.default_editor.start_interactive()
  end, {
    description = "edit the current layout if it is a machi layout",
    group = "layout",
  }),
  awful.key({ modkey }, "/", function()
    machi.switcher.start(client.focus)
  end, {
    description = "switch between windows for a machi layout",
    group = "layout",
  }),
}
