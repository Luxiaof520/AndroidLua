import "bin.androidlua.*"
TwoMethod = TestObject_TwoMethod

--
-- 1.创建接口实例
--
iface = TwoMethod {
    method1 = function()
        print("method1")
    end,
    method2 = function(arg)
        print("method2 "..arg)
    end
}

runnable = Runnable {
    run = function()
        print("run")
    end
}

TestObject.testInterface(iface)
Thread(runnable).run()

--
-- 2.当作为参数或者用于setter时，因为可以推断出类型，所以可以不写接口类名
--
TestObject.testInterface({
    method1 = function()
        print("_method1")
    end,
    method2 = function(arg)
        print("_method2 "..arg)
    end
})

Thread({
    run = function()
        print("run1")
    end
}).run()

--
-- 3.单方法Interface可以不写方法名
--
Runnable {
    function()
        print("run2")
    end
}.run()

Thread({
    function()
        print("run3")
    end
}).run()

--
-- 4.结合2和3的情况，在不需要接口类名和方法名时，大括号也不需要了，直接传入function
--
Thread(
    function()
        print("run4")
    end
).run()
