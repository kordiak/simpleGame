local json = require('json')
local properties = require("code.global.properties")

local saveFile = {}

saveFile.loadValue = function(strFilename)
    local theFile = strFilename
    local path = system.pathForFile( theFile, system.DocumentsDirectory )
    local file = io.open( path, "r" )

    if file then -- If file exists, continue. Another way to read this line is 'if file == true then'.
        local contents = file:read( "*a" ) -- read all contents of file into a string
        io.close( file ) -- Since we are done with the file, close it.
        return contents -- Return the table with the JSON contents
    else
        return '' -- Return nothing
    end
end

-- Save specified value to specified encrypted file
saveFile.saveValue = function (strValue,strFilename)
    local theFile
    if strFilename then
    theFile = strFilename
    else
        theFile = properties.saveFile
        end
    local theValue = strValue
    local path = system.pathForFile( theFile, system.DocumentsDirectory )

    local file = io.open( path, "w+" )
    if file then -- If the file exists, then continue. Another way to read this line is 'if file == true then'.
        file:write(theValue) -- This line will write the contents of the table to the .json file.
        io.close(file) -- After we are done with the file, we close the file.
        return true -- If everything was successful, then return true
    end
end


saveFile.loadFile = json.decode(saveFile.loadValue('saveFile.txt'))
if not saveFile.loadFile then
    saveFile.loadFile = {
        level = 1, -- stores total number of coins
       }
    saveFile.saveValue(json.encode(saveFile.loadFile),'saveFile.txt')
end

if saveFile.loadFile then
    saveFile.loadFile = json.decode(saveFile.loadValue('saveFile.txt'))
    if saveFile.loadFile.level ~= nil then

    end
end

return saveFile
