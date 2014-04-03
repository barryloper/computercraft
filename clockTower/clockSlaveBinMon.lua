local binSide = "left"
local monSide = "back"
local lightSensor = "right"
local am = colors.lime
local pm = colors.red
local x,y = term.getSize()
local tClockX = x-5
local mon = peripheral.wrap(monSide)
mon.setTextScale(3.5)

os.loadAPI("clockWriter")
local tFont = clockWriter.readFont(7, 4, 10, "numbers")

local function dispTime(_t, tFont, mon, binSide)
  local _h = bit.blshift(tonumber(_t:sub(1,2)), 6)
  local _m = tonumber(_t:sub(4,5))
  rs.setBundledOutput(binSide, _h+_m) 
  clockWriter.printTime(_t, tFont, mon)  
end

while true do
 evt, id, msg = os.pullEvent("rednet_message")
 if msg:find("^!time%d.*") then
    dispTime(msg:sub(6), tFont, mon, binSide)
    term.setCursorPos(tClockX,1)
    print(msg:sub(6))
  end
end
