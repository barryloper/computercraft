ignighterColor = colors.blue
pistonsColor = colors.pink
upColor = colors.green
downColor = colors.green
buttonColor = colors.yellow

pistonSide = "left"
ignighterSide = "left"
buttonSide = "right"
upSide = "left"
downSide = "right"

stateFile = "portalState"

setState = function(status)
    sf = fs.open(stateFile, "w")
    sf.write(status)
    state = status
    sf.close()
end

up = function()
    rs.setBundledOutput(downSide, 0)
    rs.setBundledOutput(pistonSide, 0)
    sleep(.2)
    rs.setBundledOutput(upSide, 0)
    sleep(.1)
    rs.setBundledOutput(upSide, upColor)
    sleep(.5)
    rs.setBundledOutput(ignighterSide, ignighterColor)
    setState("up")
end

down = function()
    rs.setBundledOutput(upSide, 0)
    rs.setBundledOutput(ignighterSide, 0)
    sleep(.1)
    rs.setBundledOutput(downSide, downColor)
    sleep(.2)
    rs.setBundledOutput(pistonSide, pistonsColor)
    setState("down")
end

-- read portal state on bootup
if fs.exists(stateFile) then
    sf = fs.open(stateFile, "r")
    state = sf.readLine()
    sf.close()
    if state == "up" then
        up()
    else
        down()
    end
end

while true do
    os.pullEvent("redstone") --Blocks until a redstone event is fired
    if colors.test(rs.getBundledInput(buttonSide), buttonColor) then
        --print("State: ", state)
        if state == "down" then
            up()
        elseif state == "up" then
            down()
        end
        sleep(1) --Needed since the button is active for about a second.
    end
end