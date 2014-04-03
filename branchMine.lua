tArgs = { ... }
if #tArgs < 3 then
    if fs.exists("branchMine.cfg") then
        cfgF = fs.open("branchMine.cfg", r)
        O, W, H, D = cfgF.readLine()
        origin = vector.new(cfgF.readLine())
        currentDirection = cfgF.readLine()
        cfgF.close()
    else
        usage()
        break
    end
else
    local O, W, H, D = tArgs[1], tArgs[2], tArgs[3], tArgs[4]
    currentDirection = 1
    if not W>0 or not H>0 or not D>0 then
        usage()
        break
    end
end
--Config file
 
--MAIN VARIABLES
--Offset, Width, Height, and Depth are defined above
myPosition = vector.new(gps.locate(2))
fuelLevel = turtle.getFuelLevel()
fuelRequired = 2*D --initially, we only have to get to the end of the first branch and back.
--currentDirection = 1 --Directions go clockwise from 1 to 4
--To find direction: 
--turnRight() --> direction = (direction+1) % 4
--turnLeft()  --> direction = (direction+3) % 4
recordConfig()
--FUNCTIONS

local function recordConfig()
    cfgF = fs.open("branchMine.cfg", w)
    cfgF.writeLine(string.format("%d, %d, %d, %d", O, W, H, D))
    cfgF.writeLine(origin:tostring())
    cfgF.writeLine(currentDirection)
    cfgF.close()
end

local function usage()
    print "Usage: Branch_mine O W H D"
    print "Where O=Offset W=# of branches, H=#of rows, D=Depth of branch"
    print "and W, H, and D are positive integers.
end

local function go(dist, ...)
    local args = { ... }
    if dist < 0 then return false end
    local traveled = 0
    if traveled == tonumber(dist) then
        return true
    end
    
    if #args == 0 then
        repeat
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
                sleep(1)
            end
            traveled = traveled + 1
        until traveled == dist
        return true
    else
        if args[1] == "up" then
            repeat
                while not turtle.up() do
                    turtle.digUp()
                    turtle.attackUp()
                    sleep(1)
                end
                traveled = traveled + 1
             until traveled == dist
             return true 
        end
        if args[1] == "down" then
            repeat
                while not turtle.down() do
                    turtle.digDown()
                    turtle.attackDown()
                    sleep(1)
                end
                traveled = traveled + 1
            until traveled == dist
            return true
        end
    end
    return false
end

local function divineDirection()
    myPosition = vector.new(gps.locate(2))
    for d = 1,4 do
        if turtle.detect() then
            turtle.turnRight()
        end
    end
    if turtle.forward() then
        local newPosition = vector.new(gps.locate(2))
        if newPosition.Z ~= myPosition.Z then
            local d = newPosition.Z - myPosition.Z
            if d > 0 then
                currentDirection = 1
            else 
                currentDirection = 3
            end
        elseif newPosition.X ~= myPosition.X then
            local d = newPosition.X - myPosition.X
            if d > 0 then
                currentDirection = 2
            else
                currentDirection = 4
            end
        end
        turtle.turnRight()
        turtle.turnRight()
        turtle.forward()
        turtle.turnRight()
        turtle.turnRight()
        return true
    end
    return false
end

local function collect() --adapted from excavate.lua
	local bFull = true
	local nTotalItems = 0
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount == 0 then
			bFull = false
		end
		nTotalItems = nTotalItems + nCount
	end
	
	if bFull then
		print( "No empty slots left." )
		return false
	end
	return true
end

local function goUnload()
    currentLocation = gps.locate(2)
    local tDist = currentLocation:sub(origin)
    turn("right")
    turn("right")
    go(math.abs(tDist.Z))
    if tDist.Y > 0 then
        go(math.abs(tDist.Y), "down")
    elseif tDist.Y < 0 then
        go(math.abs(tDist.Y), "up")
    end
    if tDist.X > 0 then
        turn("right")
    elseif tDist.X < 0 then
        turn("left")
    end
    go(math.abs(tDist.X))
    currentLocation = gps.locate(2)
    return true
end

local function turn(direction)
    if direction == "right" then
        turtle.turnRight()
        currentDirection = (currentDirection + 1) % 4
        return true
    elseif direction == "left" then
        turtle.turnLeft()
        currentDirection = (currentDirection + 3) % 4
        return true
    end
    return false
end

local function refuel()
    if not goUnload() then
        return false
    end
    turtle.turnLeft() --goUnload goes to the item drop. To the left is the refuel station.
    fuelLevel = turtle.getFuelLevel()
    while fuelLevel < fuelRequired do
        while not turtle.suck() do
            sleep(1)
        end
        for i in 1,16 do
            turtle.select(i)
            if turtle.refuel() then
                break
            end
        end
        fuelLevel = turtle.getFuelLevel()
    end
    turtle.turnLeft() --Face down the rows once again
    return true
end

local function checkFuel(coordinate)
    --returns true if we have enough fuel to reach coordinate and back
    fuelLevel = turtle.getFuelLevel()
    local dVec = coordinate:sub(myPosition)
    --taxicab distance
    fuelRequired = 2*(math.abs(dVec.X) + math.abs(dVec.Y) + math.abs(dVec.Z))
    if fuelRequired < fuelLevel then
        return false
    end
    return true
end

-- MAIN
--[[
for y in 0,H-1 do
    --Do this once for each row.
  for x in range(0,W-1):
      --
      goto(2y+5x, y, 0)
       
      for z in range(0,D-1):
        --Dig the Tunnel        
        --Mine blocks in front of you.
        if turtle.dig() then
            collected = collected + 1
        end
        --Mine non-blacklisted blocks from the four walls
        blacklist_slots = {1,2} --Cobble, Dirt
        --Check Up and Down
        for i in blacklist_slots do
            turtle.select(i)
            if not turtle.compareUp()
            turtle.compareDown()
        end
        --Check Right
        turtle.turnRight()
        for i in blacklist_slots do
            turtle.select(i)
            turtle.compare()
        end
        turtle.turnLeft(2)
        for i in blacklist_slots do
            turtle.select(i)
            turtle.compare()
        end
end
--]]

