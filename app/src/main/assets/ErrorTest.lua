function javaError(msg)
    print("====== javaError ======")
    bin.androidlua.TestObject.error123(msg)
    return "ReturnValue"
end

function luaError()
    print("====== luaError ======")
    print(0 / nil)
    return "ReturnValue"
end

function catchJavaError(msg)
    print("====== catchJavaError ======")
    --
    -- 语法：
    -- tryCatch {
    --   tryFunction,
    --   catchFunction
    -- }
    -- 可通过tryCatch的返回值来判断是否没有错误
    --
    local ok = tryCatch {
        function()
            bin.androidlua.TestObject.error123(msg)
        end, function(err, isJavaErr)
            if isJavaErr then
                print("Lua捕获到错误(JavaErr)")
                -- err 为 JavaException
                print(err)
            else
                print("Lua捕获到错误(LuaErr)")
                -- err 为 string
                print(err)
            end
        end
    }
    local ret = "Return: "
    if (ok) then
        ret = ret.."pass"
    else
        ret = ret.."error"
    end
    return ret
end

function catchLuaError(msg)
    print("====== catchLuaError ======")
    local ok = tryCatch {
        function()
            print(0 / nil)
        end, function(err, isJavaErr)
            if isJavaErr then
                print("Lua捕获到错误(JavaErr)")
                -- err 为 JavaException
                print(err)
            else
                print("Lua捕获到错误(LuaErr)")
                -- err 为 string
                print(err)
            end
        end
    }
    local ret = "Return: "
    if (ok) then
        ret = ret.."pass"
    else
        ret = ret.."error"
    end
    return ret
end

function catchJavaErrorAndRethrow()
    print("====== catchJavaErrorAndRethrow ======")
    tryCatch {
        function()
            bin.androidlua.TestObject.error123("aaaaaaaaa")
        end, function(err, isJavaErr)
            print("捕获到异常，将它重新抛出")
            throw(err)
        end
    }
    return "ReturnValue"
end

local function catchLuaErrorAndRethrowImpl()
    tryCatch {
        function()
            print(0 / nil)
        end, function(err, isJavaErr)
            print("捕获到异常，将它重新抛出（1）")
            throw(err)
        end
    }
    return "ReturnValue"
end

function catchLuaErrorAndRethrow()
    print("====== catchLuaErrorAndRethrow ======")
    tryCatch {
        function()
            catchLuaErrorAndRethrowImpl()
        end, function(err, isJavaErr)
            print("捕获到异常，将它重新抛出（2）")
            print(err)
            throw(err)
            -- 最终打印信息有三个stack traceback
            -- 后面两个是因为调用两次throw后加进去的
        end
    }
    return "ReturnValue"
end
