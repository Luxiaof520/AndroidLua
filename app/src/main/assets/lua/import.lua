local packages = {}
local append = table.insert
local new = luajava.new

-- SciTE requires this, if you want to see stdout immediately...

io.stdout:setvbuf 'no'
io.stderr:setvbuf 'no'

local function new_tostring (o)
    return o:toString()
end

function tryCatch(funs)
    local e
    if not xpcall(funs[1], function(err) e = err end) then
        if (type(e) == "string") then
            -- 跳过当前这个function的traceback
            funs[2](e .. '\n' .. debug.tracebackSkip(1), false)
        else
            funs[2](e, true)
        end
        return false
    end
    return true
end

function __java_class_call (t, ...)
    local stat, obj = pcall(new, t, ...)
    if not stat then
        error("cannot new instance of " .. t.toString())
    end
    getmetatable(obj).__tostring = new_tostring
    return obj
end

local function import_class (classname, packagename)
    local res, class = pcall(luajava.bindClass, packagename)
    if res then
        _G[classname] = class
        local mt = getmetatable(class)
        mt.__call = __java_class_call
        return class
    end
end

local function massage_classname (classname)
    if classname:find('_') then
        classname = classname:gsub('_', '$')
    end
    return classname
end

local globalMT = {
    __index = function(table, classname)
        classname = massage_classname(classname)
        for i, p in ipairs(packages) do
            local class = import_class(classname, p .. classname)
            if class then
                return class
            end
        end
        error("import cannot find " .. classname)
    end
}
setmetatable(_G, globalMT)

function import (package)
    local i = package:find('%.%*$')
    if i then
        -- a wildcard; put into the package list, including the final '.'
        append(packages, package:sub(1, i))
    else
        local classname = package:match('([%w_]+)$')
        if not import_class(classname, package) then
            error("cannot find " .. package)
        end
    end
end

append(packages, '')

import 'java.lang.*'
import 'java.util.*'