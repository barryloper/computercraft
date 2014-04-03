for k, v in pairs({"top", "right", "bottom", "left", "back", "front"}) do
    local t = peripheral.getType(v)
    if t == "modem" then
        rednet.open(v)
    end
end
local id, label = os.computerID(), os.getComputerLabel()
--print (label)
local ids = {["server"]=34, ["controlTop"]=22 , ["controlMid"] = 36, ["controlBottom"] = 24}
local floorControllers = { "controlBot" , "controlMid", "controlTop"}
local floorMessages = { "bottom", "mid", "top" }

local function message(mstring)
    term.setCursorPos(5,18)
    term.write("                        ")
    term.setCursorPos(5,18)
    term.write(mstring)
    sleep(1)
    term.setCursorPos(5,18)
    term.write("                        ")
end

local function launch()
    rs.setOutput("bottom", true)
    sleep(2)
    rs.setOutput("bottom", false)
end

local function goFloor(floor)
  local server = ids["server"]
  if floorControllers[floor] == label then
    message("Sending you a cart")
    for k,v in pairs(floorControllers) do
        --print(v..", launch!")
        if ids[v] ~= id then
            rednet.send(ids[v], "launch")
        end
    end
    rednet.send(server, floorMessages[floor])
  else
    message("Sending you to floor "..floor)
    rednet.send(server, floorMessages[floor])
    sleep(1)
    rs.setOutput("bottom", true)
    sleep(1)
    rs.setOutput("bottom", false)
  end
end

local function messageHandler(msg)
    if msg == "launch" then
        message("Launching...")
        launch()
    end
end

term.clear()
--Draw border
for i = 1,50 do
  term.setCursorPos(i,1)
  term.write("-")
  term.setCursorPos(i,19)
  term.write("-")
end
for i = 2,18 do
  term.setCursorPos(1,i)
  term.write(":")
  term.setCursorPos(50, i)
  term.write(":")
end

--display options
local options = {"Basement Floor", "Middle Floor", "Top Floor"}
for k, v in pairs(options) do
  term.setCursorPos(5, 5+k)
  term.write(k..": "..v)
end

while true do
  local eventType, p1, p2 = os.pullEvent()
  if eventType == "rednet_message" then
    messageHandler(p2)
  elseif eventType == "char" then
    local n = tonumber(p1)
    if n ~= nill then
        goFloor(n)
    end
  end
end
