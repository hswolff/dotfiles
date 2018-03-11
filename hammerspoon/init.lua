
-- watch for changes
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()



--
-- start custom config
--

hs.grid.MARGINX = 0    -- The margin between each window horizontally
hs.grid.MARGINY = 0    -- The margin between each window vertically
hs.grid.GRIDWIDTH = 8  -- The number of cells wide the grid is
hs.grid.GRIDHEIGHT = 4  -- The number of cells high the grid is

-- moves window into position
function movewindow(pos)
  local grid

  local grid_positions = {
    full = { x = 0, y = 0, w = hs.grid.GRIDWIDTH, h = hs.grid.GRIDHEIGHT },
    left_half = { x = 0, y = 0, w = hs.grid.GRIDWIDTH / 2, h = hs.grid.GRIDHEIGHT },
    right_half = { x = hs.grid.GRIDWIDTH / 2, y=0, w = hs.grid.GRIDWIDTH / 2, h = hs.grid.GRIDHEIGHT },
    left_2_3 = { x = 0, y = 0, w = 7, h = hs.grid.GRIDHEIGHT },
    right_2_3 = { x = 1, y = 0, w = 7, h = hs.grid.GRIDHEIGHT },

    left_5_8 = { x = 0, y = 0, w = 5, h = hs.grid.GRIDHEIGHT },
    right_5_8 = { x = 3, y = 0, w = 5, h = hs.grid.GRIDHEIGHT },

    top_half = { x = 0, y = 0, w = hs.grid.GRIDWIDTH, h = hs.grid.GRIDHEIGHT / 2 },
    bottom_half = { x = 0, y = hs.grid.GRIDHEIGHT / 2, w = hs.grid.GRIDWIDTH, h = hs.grid.GRIDHEIGHT / 2 },

    left_top_corner = { x = 0, y = 0, w = hs.grid.GRIDWIDTH / 2, h = hs.grid.GRIDHEIGHT / 2 },
    left_bottom_corner = { x = 0, y = 2, w = hs.grid.GRIDWIDTH / 2, h = hs.grid.GRIDHEIGHT / 2 },
    right_top_corner = { x = 4, y = 0, w = hs.grid.GRIDWIDTH / 2, h = hs.grid.GRIDHEIGHT / 2 },
    right_bottom_corner = { x = 4, y = 2, w = hs.grid.GRIDWIDTH / 2, h = hs.grid.GRIDHEIGHT / 2 },

    centered = { x = 2, y = 1, w = 4, h = 2 },
  }

  return function()
    hs.grid.set(hs.window.focusedWindow(), grid_positions[pos], hs.screen.mainScreen())
  end
end

-- keyboard modifier for bindings
local mod1 = {'ctrl', 'shift'}

hs.fnutils.each({
  { key = 'f', pos = 'full' },

  { key = 's', pos = 'centered' },
  { key = 'a', pos = 'left_half' },
  { key = 'd', pos = 'right_half' },
  { key = '.', pos = 'left_2_3' },
  { key = '/', pos = 'right_2_3' },
  { key = ';', pos = 'left_5_8' },
  { key = '\'', pos = 'right_5_8' },

  { key = 'w', pos = 'top_half' },
  { key = 'x', pos = 'bottom_half' },

  { key = 'q', pos = 'left_top_corner' },
  { key = 'z', pos = 'left_bottom_corner' },
  { key = 'e', pos = 'right_top_corner' },
  { key = 'c', pos = 'right_bottom_corner' },

}, function(obj)
  hs.hotkey.new(mod1, obj.key, movewindow(obj.pos)):enable()
end)

-- set window to 1080p
hs.hotkey.new(mod1, 'h', function()
  hs.window.focusedWindow():setFrame({ x = 0, y = 0, w = 1920, h = 1080 })
end):enable()

function application_positions()
  local screen = hs.screen.mainScreen():fullFrame()

  -- application positions we want for defaults.
  -- allow for setting 'by_window' within an application for more finite control.
  local app_positions = {
    HipChat = { x = 0, y = screen.h - 468, w = 900, h = 468 },
    Textual = { x = 0, y = 0, w = 900, h = 410 },
    Messages = {
      by_window = true,
      Buddies = { x = screen.w - 190, y = 0, w = 190, h = 900 },
      Messages = { x = screen.w - 670, y = screen.h - 360, w = 600, h = 360 }
    },
    iTunes = { x = (screen.w - 1100) / 2, y = 22, w = 1100, h = 725 },

    ['Google Chrome'] = { x = 0, y = 0, w = screen.w - 150, h = screen.h },
    ['Sublime Text'] = { x = 150, y = 0, w = screen.w - 150, h = screen.h },
    ['Atom'] = { x = 150, y = 0, w = screen.w - 150, h = screen.h },
    ['Code'] = { x = 150, y = 0, w = screen.w - 150, h = screen.h },

    iTerm = { x = 0, y = 0, w = screen.w, h = 460 },
    SourceTree = { x = 0, y = screen.h - 720, w = screen.w, h = 720 }
  }

  -- iterate over every visible window in the current screen.
  hs.fnutils.each(hs.window.allWindows(), function(win)
    -- grab the window's application's title.
    local app_title = win:application():title()

    -- save our desired application position
    local app_position = app_positions[app_title]

    -- if we've found an application position then we can position its frame
    if app_position then

      -- if we're setting frame by_window instead of by application
      if app_position.by_window then
        -- iterate over every window open in the application
        hs.fnutils.each(win:application():allWindows(), function(app_window)
          -- get the actual window's title (not the application's)
          local window_title = app_window:title()

          -- if we have a desired position then we can position it!
          if app_position[window_title] then
            app_window:setFrame(app_position[window_title])
          end
        end)
      else
        -- set window frame
        win:setFrame(app_position)
      end

    end
  end)
end
hs.hotkey.new(mod1, '1', application_positions):enable()
