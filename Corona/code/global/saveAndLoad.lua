local json = require('json')
local properties = require("code.global.properties")

local saveFile = {}

saveFile.load = function(strFilename)
    local theFile = strFilename
    local path = system.pathForFile(theFile, system.DocumentsDirectory)
    local file = io.open(path, "r")
    if file then -- If file exists, continue. Another way to read this line is 'if file == true then'.
    local value = file:read("*a")
    local contents = json.decode(value)
    io.close(file) -- Since we are done with the file, close it.
    return contents -- Return the table with the JSON contents
    else
        saveFile.save()
        return '' -- Return nothing
    end
end

-- Save specified value to specified encrypted file
saveFile.save = function(strValue, strFilename)
    local theFile
    if strFilename then
        theFile = strFilename
    else
        theFile = properties.saveFile
    end
    local theValue = json.encode(strValue, { indent = true })
    local path = system.pathForFile(theFile, system.DocumentsDirectory)
    local file = io.open(path, "w+")
    if file then
    file:write(theValue)
    io.close(file)
    return true
    end
end

return saveFile
