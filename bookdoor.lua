p1 = colors.orange
p2 = colors.pink
p3 = colors.green
s1 = colors.green --Piston shifted into contact with same wire.
s2 = colors.blue
s3 = colors.yellow


sw1 = colors.red
inputSide = "left"
outputSide = "right"

openDoor = function()
    if closed then
        --print("Opening door on: " .. outputSide)
        rs.setBundledOutput(outputSide, p1) --push sticky puller into place
        sleep(.2)
        rs.setBundledOutput(outputSide, s1) -- rest p1 and get bottom block
        sleep(.2)
        rs.setBundledOutput(outputSide, s3) --pull it down & get with lateral sticky
        sleep(.2)
        --rs.setBundledOutput(outputSide, s3) -- get block with lateral sticky
        --sleep(.2)
        rs.setBundledOutput(outputSide, 0) --pull it out of the way
        sleep(.2)
        rs.setBundledOutput(outputSide, s2) --push up sticky puller
        sleep(.2)
        rs.setBundledOutput(outputSide, s1+s2) --grab top block keeping puller extended
        sleep(.2)
        rs.setBundledOutput(outputSide, s2) --pull it down once keeping puller extended
        sleep(.2)
        rs.setBundledOutput(outputSide, 0) --pull down sticky puller
        sleep(.2)
        rs.setBundledOutput(outputSide, s1) --grab bottom block again
        sleep(.2)
        rs.setBundledOutput(outputSide, 0) --pull it down
        closed = false
    end
end

closeDoor = function()
    --print("Closing door on " .. outputSide)
    rs.setBundledOutput(outputSide, p2) --push closer in place
    sleep(.2)
    rs.setBundledOutput(outputSide, p3) --push up first block
    sleep(.2)
    rs.setBundledOutput(outputSide, 0) --ready for second block
    sleep(.2)
    rs.setBundledOutput(outputSide, s3) --push second block over
    sleep(.2)
    rs.setBundledOutput(outputSide, p3+s3) --push second block up leaving horizontal extended
    sleep(.2)
    --rs.setBundledOutput(outputSide, p3) --put lateral sticky into rest position
    --sleep(.2)
    rs.setBundledOutput(outputSide, 0) --put vertical pusher into rest position
    closed = true
end

closeDoor()
while true do
    ---print("Waiting for input.")
    evt = os.pullEvent("redstone")
    if rs.getInput(inputSide) then
        ---print("Button Pressed")
        if closed then
            ---print("Door closed: Opening.")
            openDoor()
            sleep(5)
            closeDoor()
        else
            ---print("Door open: Closing.")
            closeDoor()
        end
    end
    ---print("Sleeping.")
    sleep(2)
end

