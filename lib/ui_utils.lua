local math = require "math"

local ui_utils = {
  screen = 1,
  initScreen = 1,
  endScreen = 2,
  viewport = { width = 128, height = 64 },
}

local degFactor = 3.14 / 180;
local startAngleOffset = math.pi/2 + math.pi/4;

-------------------------------------------------------
--  This will draw a knob to screen
--  @arg startVal - starting value of controller
--  @arg endVal - ending value of controller
--  @arg value - current value of controller
--  @arg startDrawX - starting position of visual entity
--  @arg startDrawX - starting position of visual entity
--  @arg innerRadius - inner radius of knob
--  @arg outerRadius - outer radius of knob
--------------------------------------------------------
local function drawKnob (
  startVal,
  endVal,
  value,
  startDrawX,
  startDrawY,
  innerRadius,
  outerRadius
)

  local mappedValue = startAngleOffset + (util.linlin(startVal, endVal, 0, 270, value) * degFactor)
  local startX = math.floor(math.cos(startAngleOffset) * innerRadius)
  local startY = math.ceil(math.sin(startAngleOffset) * innerRadius)
  
  screen.stroke()
  screen.circle(startDrawX, startDrawY, outerRadius)
  screen.close()
  
  screen.move(startDrawX +  startX, startDrawY + startY)
  screen.arc(startDrawX, startDrawY, innerRadius, startAngleOffset, mappedValue)
  screen.stroke()
  
end

-- Changes between available screens
function ui_utils.changeScreen(newScreen)
  if newScreen > ui_utils.endScreen then
    newScreen = ui_utils.initScreen
  elseif newScreen < ui_utils.initScreen then
    newScreen = ui_utils.endScreen
  end
  ui_utils.screen = newScreen
end

function ui_utils.drawFrame()
  screen.level(15)
  screen.rect(1, 1, ui_utils.viewport.width-1, ui_utils.viewport.height-1)
  screen.stroke()
end

-- draws the header title
function ui_utils.drawTitle()
  screen.move(1, 8)
  screen.text("bgcDust - by bgc")
  screen.move(1,12)
  screen.line(ui_utils.viewport.width, 12)
  screen.stroke()
  screen.close()
end

--draws Rate control
function ui_utils.drawRate()
  local rateVal = params:string("rate")
  local rate = params:get("rate")

  local outerRadius = 10
  local innerRadius = 7

  local startDrawX = 2
  local startDrawY = 18
  
  screen.move(startDrawX, startDrawY)
  screen.text("rate: ")
  screen.move(startDrawX, startDrawY + 8)
  screen.text(rateVal)
  -- print(params:get("rate"))
  -- screen.line_width(1)
  drawKnob(0.0, 180, rate, startDrawX + outerRadius, startDrawY + 20, innerRadius, outerRadius)
end

--draws Amp control
function ui_utils.drawAmp()
  local ampVal = params:string("amp")
  local amp = params:get("amp")
  
  local outerRadius = 10
  local innerRadius = 7
  
  local startDrawX = 30
  local startDrawY = 18
  
  screen.move(startDrawX, startDrawY)
  screen.text("amp: ")
  screen.move(startDrawX, startDrawY + 8)
  screen.text(ampVal)
  -- print(params:get("amp"))
   drawKnob(0.0, 1.0, amp, startDrawX + outerRadius, startDrawY + 20, innerRadius, outerRadius)

end

return ui_utils