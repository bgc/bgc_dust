--
-- Darkening motions
-- Wait for me as echoes pass
-- Fall reaching around
--
--
--
--
-----------------------------
-- scriptname: bgc_Dust
-- Dust2 based engine,
-- because I like Dust2
-- v0.0.1 @bgc
-- llllllll.co/t/???????????
-----------------------------

-- Setup engine
engine.name = 'bgcDust'

--Imports
local UI = require "ui"
local ControlSpec = require "controlspec"
local util = require "util"

-- libs
local ui_utils = include "lib/ui_utils"

-- Globals
local SCREEN_FRAMERATE = 15
local screen_refresh_metro

local function setupParams()
  -- Param spec for engine rate
  params:add{
    type="control",
    id="rate",
    controlspec=controlspec.new(
      0.01, --minVal
      180, --maxVal
      "exp", --warp (exp, db, lin)
      0, -- step (rounded)
      1, --default initial value
      "Hz" --units
    ),
    action=engine.setRate,
  }

  -- Param spec for engine amp
  params:add{
    type="control",
    id="amp",
    controlspec=controlspec.new(
      0,
      1,
      "linear",
      0,
      0.5,
      ""
    ),
    action=engine.setAmp,
  }

end

local function setupScreen()
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  screen.font_face(2)
  screen.font_size(8)
end

-- initialization
function init()
  engine.list_commands()
  
  setupParams()
  setupScreen()

  -- Start drawing to screen
  screen_refresh_metro = metro.init()
  screen_refresh_metro.event = function()
    if screen_dirty then
      screen_dirty = false
      redraw()
    end
  end
  screen_refresh_metro:start(1 / SCREEN_FRAMERATE)
  

end

--Keys functionality 
function key(button, state)
  if button == 2 and state == 1 then
    ui_utils.changeScreen(ui_utils.screen - 1)
  end
  if button == 3 and state == 1 then
    ui_utils.changeScreen(ui_utils.screen + 1)
  end
  --always have redraw at the end
  redraw()
end

-- Encoder functionality
function enc(encoder, delta)
  --[[ TODO: check this up ]]--
    -- norns.encoders.set_sens(1,3)
    norns.encoders.set_sens(2,1)
    norns.encoders.set_sens(3,3)
    -- norns.encoders.set_accel(1, false)
    norns.encoders.set_accel(2, false)
    norns.encoders.set_accel(3, true)
  -- ]]
  if ui_utils.screen == 1 then
    if encoder == 2 then
      -- lets handle enc2
      params:delta("rate", delta)
  
    elseif encoder == 3 then
      -- lets handle enc3
      params:delta("amp", delta)
    end
  elseif ui_utils.screen == 2 then
    print("meow")
  end
  
  --always have redraw at the end
  redraw()
end

-- Screen functionality
function redraw()
  -- clear screen
  screen.clear()
  -- screen.font_face(2)
  -- set pixel brightness (0-15)
  -- screen.level(15)
  ui_utils:drawFrame()
  ui_utils:drawTitle()
  if ui_utils.screen == 1 then
    ui_utils:drawRate()
    ui_utils:drawAmp()
  elseif ui_utils.screen == 2 then
  screen.move(1, 18)
  screen.text("meow")
  screen.stroke()
  screen.close()
  end
  

  screen.update()
end


function cleanup()
  -- deinitialization
end