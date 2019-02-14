local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TagList = require('widgets.tag-list')
local gears = require('gears')
local apps = require('conf.apps')
local dpi = require('beautiful').xresources.apply_dpi

local mat_list_item = require('widgets.mat-list-item')
-- Clock / Calendar 24h format
local textclock = wibox.widget.textclock('<span font="Roboto Mono bold ' .. dpi(11) .. '">%H\n%M</span>')

-- Clock / Calendar 12AM/PM fornat
-- local textclock = wibox.widget.textclock('<span font="Roboto Mono bold '..dpi(11)..'">%I\n%M</span>\n<span font="Roboto Mono bold '..dpi(9)..'">%p</span>')
-- textclock.forced_height = 56
local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(8), dpi(8))
local systray = wibox.widget.systray()
systray:set_horizontal(false)
local clickable_container = require('widgets.clickable-container')
local icons = require('theme.icons')

local menu_icon =
  wibox.widget {
  image = icons.menu,
  widget = wibox.widget.imagebox
}

local home_button =
  wibox.widget {
  wibox.widget {
    wibox.widget {
      menu_icon,
      top = dpi(12),
      left = dpi(12),
      right = dpi(12),
      bottom = dpi(12),
      widget = wibox.container.margin
    },
    widget = clickable_container
  },
  bg = beautiful.primary.hue_500,
  widget = wibox.container.background
}

local LeftPanel =
  function(s)
  local panel =
    wibox {
    screen = s,
    width = dpi(448),
    height = s.geometry.height,
    x = s.geometry.x + dpi(48) - dpi(448),
    y = s.geometry.y,
    ontop = true,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal
  }

  panel.opened = false

  panel:struts(
    {
      left = dpi(48)
    }
  )

  local backdrop =
    wibox {
    ontop = true,
    screen = s,
    bg = '#00000000',
    type = 'dock',
    x = s.geometry.x,
    y = s.geometry.y,
    width = s.geometry.width,
    height = s.geometry.height
  }

  local run_rofi =
    function()
    awesome.spawn(
      apps.rofi,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  local openPanel = function(should_run_rofi)
    panel.x = 0
    menu_icon.image = icons.close
    backdrop.visible = true
    panel.visible = false
    panel.visible = true
    if should_run_rofi then
      run_rofi()
    end
  end

  local closePanel = function()
    menu_icon.image = icons.menu
    panel.x = dpi(48) - dpi(448)
    backdrop.visible = false
  end

  function panel:toggle(should_run_rofi)
    self.opened = not self.opened
    if self.opened then
      openPanel(should_run_rofi)
    else
      closePanel()
    end
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )

  home_button:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          panel:toggle()
          --awful.spawn(apps.rofi)
        end
      )
    )
  )

  local search_button =
    wibox.widget {
    wibox.widget {
      wibox.widget {
        image = icons.search,
        widget = wibox.widget.imagebox
      },
      margins = dpi(12),
      widget = wibox.container.margin
    },
    wibox.widget {
      text = 'Search Applications',
      font = 'Roboto medium ' .. dpi(13),
      widget = wibox.widget.textbox
    },
    clickable = true,
    widget = mat_list_item
  }

  search_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          run_rofi()
        end
      )
    )
  )

  local exit_button =
    wibox.widget {
    wibox.widget {
      wibox.widget {
        image = icons.logout,
        widget = wibox.widget.imagebox
      },
      margins = dpi(12),
      widget = wibox.container.margin
    },
    wibox.widget {
      text = 'End work session',
      font = 'Roboto medium ' .. dpi(13),
      widget = wibox.widget.textbox
    },
    clickable = true,
    divider = true,
    widget = mat_list_item
  }

  exit_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
          exit_screen_show()
        end
      )
    )
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    {
      {
        layout = wibox.layout.align.vertical,
        {
          layout = wibox.layout.fixed.vertical,
          {
            search_button,
            bg = beautiful.background.hue_800,
            widget = wibox.container.background
          },
          wibox.widget {
            orientation = 'horizontal',
            forced_height = 1,
            opacity = 0.08,
            widget = wibox.widget.separator
          },
          require('widgets.left-panel.quick-settings'),
          require('widgets.left-panel.hardware-monitor')
        },
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          {
            exit_button,
            bg = beautiful.background.hue_800,
            widget = wibox.container.background
          }
        }
      },
      bg = beautiful.background.hue_900,
      widget = wibox.container.background
    },
    {
      layout = wibox.layout.align.vertical,
      forced_width = dpi(48),
      {
        -- Left widgets
        layout = wibox.layout.fixed.vertical,
        home_button,
        -- Create a taglist widget
        TagList(s)
      },
      --s.mytasklist, -- Middle widget
      nil,
      {
        -- Right widgets
        layout = wibox.layout.fixed.vertical,
        wibox.container.margin(systray, dpi(10), dpi(10)),
        require('widgets.package-updater'),
        require('widgets.wifi'),
        require('widgets.battery'),
        -- Clock
        clock_widget
      }
    }
  }

  return panel
end

return LeftPanel
