fun = require 'lib/fun'

range = fun.range

function reroll_intervals(intervals)
  local allocated = 0
  local rem = 100
  range(1,6):each(function (i)
    local val = math.random(5,math.min(rem,30))
    intervals[i] = val + allocated
    rem = rem - val
    allocated = allocated + val
  end)
end

function colorize_waves(color_intervals, r)
  local color = {255,255,255}
  if r > 999 then
     r = 100 + (r - 999)
  end
  if r % 100 < color_intervals[1] then
     color = {255,0,0}
  elseif r % 100 < color_intervals[2] then
     color = {255,80,0}
  elseif r % 100 < color_intervals[3] then
     color = {220,255,80}
  elseif r % 100 < color_intervals[4] then
     color = {0,255,0}
  elseif r % 100 < color_intervals[5] then
     color = {0,0,255}
  elseif r % 100 < color_intervals[6] then
     color = {150,0,150}
  else
     color = {255,0,255}
  end
  if r % 20 < 10 then
     color[4] = (((r%10)/10)*155) + 100
  else
     color[4] = (((10 - (r%10))/10)*155) + 100
  end
  return color
end

intervals1 = {}
intervals2 = {}

WIDTH = (800-8)/20
HEIGHT = (600-8)/20

function love.load()
  a = 100
  reroll_intervals(intervals1)
  reroll_intervals(intervals2)
end

function love.draw()
  range(WIDTH):each(function (x)
    range(HEIGHT):each(function (y)
      local r = x+y+a
      local color = {}
      if r % 200 < 100 then
        color = colorize_waves(intervals1, r)
      else
        color = colorize_waves(intervals2, r-1000)
      end
      love.graphics.print({color,math.ceil(r/10)%100}, (x-1)*20+8, (y-1)*20+8)
    end)
  end)
  if a < (999 + WIDTH + HEIGHT) then
    a = a + 1
  else
    a = a % 100 + 1
  end
  if a % 200 == 0 then
    reroll_intervals(intervals2)
  elseif a % 100 == 0 then
    reroll_intervals(intervals1)
  end
end
