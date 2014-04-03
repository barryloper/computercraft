--coordinates from bottom left (0,0)
timeBetweenHarvests = 4500
origin = vector.new(0,0,0)
xV = vector.new(1,0,0)
yV = vector.new(0,1,0)
zV = vector.new(0,0,1)
home = vector.new(9,-1,0)
farPoint = vector.new(16,25,0)
seedSlot = 13
torchSlot = 14
wheatSlot = 15
chestSlot = 16
invSlots = {1,12}

unLoad = function()
    turtle.select(chestSlot)
    if turtle.compareDown() then
        for slot = invSlots[1],invSlots[2] do
            turtle.select(slot)
            if (turtle.getItemCount(slot) > 0) and not turtle.dropDown() then
                imStuck()
            end
        end
    else
        imStuck()
        return false
    end
end

imStuck = function()
    rednet.open("right")
    rednet.broadcast("Help! Farming turtle is stuck!")
    shell.exit()
end

isHome = function()
    turtle.select(torchSlot)
    turtle.turnLeft()
    local torchIsThere = turtle.compare()
    turtle.select(chestSlot)
    local chestIsThere = turtle.compareDown()
    turtle.turnRight()
    if torchIsThere and chestIsThere then
    --    print("yup, i'm home")
        return true
    else
    --    print("no i'm not home")
        return false
    end
end

goOrigin = function()
    --print("going origin")
    if isHome() then
        cpos = home
        while cpos:sub(origin):length()~=0 do
            yDiff = cpos:dot(yV)
            while yDiff < 0 do
                turtle.forward()
                cpos = cpos + yV
                yDiff = cpos:dot(yV)
            end

            xDiff = cpos:dot(xV)
            if xDiff < 0 then
                turtle.turnRight()
            else
                turtle.turnLeft()
            end
         
            while xDiff^2 > 0 do
                turtle.forward()
                cpos = cpos - xV
                xDiff = cpos:dot(xV)
            end
         
            zDiff = cpos:dot(zV)
            while zDiff > 0 do
                turtle.down()
                cpos = cpos - zV
                zDiff = cpos:dot(zV)
            end
        end 
        turtle.turnRight()
    else
        imStuck()
        return false
    end
    return true
end

plant = function()
    if currentSlot == nil then
        currentSlot = 1
        --print("No slot selected")
    end
    turtle.select(currentSlot)
    if turtle.compareTo(seedSlot) then
        return turtle.placeDown()
    else
        for c = invSlots[1],invSlots[2] do
            turtle.select(c)
            if turtle.compareTo(seedSlot) then
                print("planting seed slot "..c)
                currentSlot = c
                local rcode = turtle.placeDown()
                --This is to try and stop the turtle from filling all slots initially with one wheat each.
                turtle.select(1)
                return rcode
            end
            --print("Slot " .. c .. " is not a seed.")
        end
        --If can't find seed, plant from seedSlot
        turtle.select(seedSlot)
        turtle.placeDown()
        turtle.select(1)
    end
    return false
end

--Begin main loop
while true do
    goOrigin()
    maxX = farPoint:dot(xV)
    maxY = farPoint:dot(yV)

    for i = 1,maxX+1 do
        for j = 1,maxY do
            turtle.digDown()
            plant()
            turtle.forward()
        end
        turtle.digDown()
        plant()

        if i%2 > 0 then
            turtle.turnRight()
            if i > maxX then
                turtle.turnRight()
                cpos = farPoint
            else
                turtle.forward()
                turtle.turnRight()
            end
        else
            turtle.turnLeft()
            if i > maxX then
                turtle.turnLeft()
                cpos = farPoint*xV
            else
                turtle.forward()
                turtle.turnLeft()
            end
        end
    end

    -- turtle.turnRight()
    if cpos == farPoint then
        for c = 1,farPoint:dot(yV) do
            turtle.forward()
        end
        turtle.turnRight()
        for c = 1,farPoint:sub(home):dot(xV) do
            turtle.forward()
        end
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()
        turtle.turnLeft()
    else
        imStuck()
    end
    unLoad()
    
    displaytime = timeBetweenHarvests/60
    print("Waiting " .. displaytime .. " minutes until next harvest.")
    os.sleep(timeBetweenHarvests)
    
end
