--Improved version of the default write command
--Allows writing with wordwrap to monitors

oWrite = write

function write( sText, oSide )
    local oDevice = nil
    if oSide == nil then
        oDevice = term
    elseif peripheral.getType(oSide) == "monitor" then
        oDevice = peripheral.wrap(oSide)
    else
        return false
    end
    
    local w,h = oDevice.getSize()		
    local x,y = oDevice.getCursorPos()
    
    local nLinesPrinted = 0
    local function newLine()
        if y + 1 <= h then
            oDevice.setCursorPos(1, y + 1)
        else
            oDevice.scroll(1)
            oDevice.setCursorPos(1, h)
        end
        x, y = oDevice.getCursorPos()
        nLinesPrinted = nLinesPrinted + 1
    end
    
    -- Print the line with proper word wrapping
    while string.len(sText) > 0 do
        local whitespace = string.match( sText, "^[ \t]+" )
        if whitespace then
            -- Print whitespace
            oDevice.write( whitespace )
            x,y = oDevice.getCursorPos()
            sText = string.sub( sText, string.len(whitespace) + 1 )
        end
        
        local newline = string.match( sText, "^\n" )
        if newline then
            -- Print newlines
            newLine()
            sText = string.sub( sText, 2 )
        end
        
        local text = string.match( sText, "^[^ \t\n]+" )
        if text then
            sText = string.sub( sText, string.len(text) + 1 )
            if string.len(text) > w then
                -- Print a multiline word				
                while string.len( text ) > 0 do
                if x > w then
                    newLine()
                end
                    oDevice.write( text )
                    text = string.sub( text, (w-x) + 2 )
                    x,y = oDevice.getCursorPos()
                end
            else
                -- Print a word normally
                if x + string.len(text) > w then
                    newLine()
                end
                oDevice.write( text )
                x,y = oDevice.getCursorPos()
            end
        end
    end
    
    return nLinesPrinted

end
