-------------------------------------------------------------------------------
-- Prints logging information to console
--
-- @author Thiago Costa Ponte (thiago@ideais.com.br)
--
-- @copyright 2004-2011 Kepler Project
--
-------------------------------------------------------------------------------
-- debug levels

local i = true
local e = true
local d = true

local skipFiles = {
--    DEBUG = { "dataSynchronizedList"},
--    DEBUG = { "dataSynchronizedList", "CustomRuntime" },
    DEBUG = {  "CustomRuntime" },
--    DEBUG = {},
    INFO = {},
    ERROR = {},
    WARN = {}
}

local gsub = string.gsub
local format = string.format

require("code.otherLibrary.logging")


local function shouldSkip(file, level)
    local skip = false
    for i = 1, #skipFiles[level] do
        local f = "@" .. skipFiles[level][i]
        if f == file then
            skip = true
            break
        end
    end
    return skip
end

local logs = {}

function logging.console(logPattern)

    return logging.new(function(self, level, message)
        if level == "DEBUG" and not d or level == "INFO" and not i or level == "ERROR" and not e then return false end
        local t = debug.getinfo(4)
        local f = gsub(gsub(t.source, "/.*/", ""), ".lua", "")
        if shouldSkip(f, level) then return end

        print(logging.prepareLogMsg(logPattern, system.getTimer(), level, f, t.currentline, message))
        return true
    end)
end



logging.logTable = function(tab)
    if not i and not d then return end
    local t = debug.getinfo(2)
    local f = gsub(gsub(t.source, "/.*/", ""), ".lua", "")
    print("--------------", system.getTimer(), "--------------")
    print(format("PRINTING TABLE %s [%s:%s]", tostring(tab), f, t.currentline))
    local function logTableLocal(o, level)
        local tabs = ""

        for i = 1, level do
            tabs = tabs .. "\t"
        end
        for k, v in pairs(o) do
            if type(v) == "table" then
                print(format(tabs .. "%s \t {", tostring(k)))
                logTableLocal(v, level + 1)
                print(format(tabs .. "}"))
            else
                print(format(tabs .. "%s \t : %s", tostring(k), tostring(v)))
            end
        end
    end

    logTableLocal(tab, 1)
    print("FINISHED PRINTING TABLE")
    print("--------------")
end

logging.shallowLogTable = function(tab, maxDepth)
    if not i and not d then return end
    local t = debug.getinfo(2)
    local f = gsub(gsub(t.source, "/.*/", ""), ".lua", "")
    print("--------------", system.getTimer(), "--------------")
    print(format("SHALLOW PRINTING TABLE %s [%s:%s]", tostring(tab), f, t.currentline))
    local function logTableLocal(o, level, depth)
        local tabs = ""

        for i = 1, level do
            tabs = tabs .. "\t"
        end
        for k, v in pairs(o) do
            if type(v) == "table" then
                print(format(tabs .. "%s \t {", tostring(k)))
                if depth > 0 then logTableLocal(v, level + 1, depth - 1) end
                print(format(tabs .. "}"))
            else
                print(format(tabs .. "%s \t : %s", tostring(k), tostring(v)))
            end
        end
    end

    logTableLocal(tab, 1, maxDepth)
    print("SHALLOW FINISHED PRINTING TABLE")
    print("--------------")
end

logging.traceback = function()
    local level = 1
    while true do
        local info = debug.getinfo(level, "Sl")
        if not info then break end
        if info.what == "C" then -- is a C function?
            log:info("%s C function", level)
            if level > 10 then
                log:info("[%s]:%s",
                    info.short_src, "More than 10 lines. Stopping")
            end
        else -- a Lua function
            log:info("[%s]:%d",
                info.short_src, info.currentline)
            if level > 10 then
                log:info("[%s]:%s",
                    info.short_src, "More than 10 lines. Stopping")
            end
        end
        level = level + 1
        if level > 11 then
            return false
        end
    end
end

return logging.console

