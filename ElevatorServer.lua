term.clear()
term.setCursorPos(1,2)
print("Train Server")

rednet.open("back")

local function acknowledge(id, info)
  print("Received message "..info.." from "..id)
end

while true do
  evt, id, info, dis = os.pullEvent("rednet_message") 
  acknowledge(id, info)
  
  if info == ("top") then
  	 rs.setBundledOutput("bottom", colors.blue)
  	 sleep(8)
    rs.setBundledOutput("bottom", 0)
  elseif info == ("mid") then
    rs.setBundledOutput("bottom", colors.yellow)
    sleep(10)
  	 rs.setBundledOutput("bottom", 0)
  elseif info == ("bottom") then
  end
end	
