local json = require('json')
local properties = require("code.global.properties")
local saveFile = {}
saveFile.load = function(strFilename)
    local theFile = strFilename
    local path = system.pathForFile(theFile, system.DocumentsDirectory)
    local file = io.open(path, "r")
    if file then
    local value = file:read("*a")
    local contents = json.decode(value)
    io.close(file)
    return contents
    else
        saveFile.save()
        return ''
    end
end
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
