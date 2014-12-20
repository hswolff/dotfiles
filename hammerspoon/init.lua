
-- watch for changes
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()



--
-- start custom config
--

hs.grid.MARGINX = 0    -- The margin between each window horizontally
hs.grid.MARGINY = 0    -- The margin between each window vertically
hs.grid.GRIDHEIGHT = 2  -- The number of cells high the grid is
hs.grid.GRIDWIDTH = 8  -- The number of cells wide the grid is

-- moves window into position
function movewindow(pos)
  local grid

  local grid_positions = {
    full = { x = 0, y = 0, w = hs.grid.GRIDWIDTH, h = 2 },
    left_half = { x = 0, y = 0, w = hs.grid.GRIDWIDTH / 2, h = 2 },
    right_half = { x = hs.grid.GRIDWIDTH / 2, y=0, w = hs.grid.GRIDWIDTH / 2, h = 2 },
    left_2_3 = { x = 0, y = 0, w = 7, h = 2 },
    right_2_3 = { x = 1, y = 0, w = 7, h = 2 }
  }

  return function()
    hs.grid.set(hs.window.focusedWindow(), grid_positions[pos], hs.screen.mainScreen())
  end
end

-- keyboard modifier for bindings
local mod1 = {'ctrl', 'shift'}

hs.fnutils.each({
  { key = 's', pos = 'full' },
  { key = 'a', pos = 'left_half' },
  { key = 'd', pos = 'right_half' },
  { key = '.', pos = 'left_2_3' },
  { key = '/', pos = 'right_2_3' }
}, function(obj)
  hs.hotkey.new(mod1, obj.key, movewindow(obj.pos)):enable()
end)

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
