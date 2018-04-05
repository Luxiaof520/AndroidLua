import "bin.androidlua.TestObject"

-- 也可写 test = bin.androidlua.TestObject()
test = TestObject()

test.print(byte(1234))
test.print(short(65537))

-- 最终传递的参数是Object，int会自动包装成Integer，所以调用print(Integer)而不是print(int)
test.print(int(123.0))

test.print(long(123))
test.print(float(123))
test.print(double(123))
test.print(boolean(true))
test.print(char(65))

test.print(false)

test.print(1234567) -- int
test.print(9876543210) -- 超过int范围，long

test.print(1234567.0) -- float
test.print(1.7976931348623157E308) -- 超过float范围，double

test.print("123")
test.print(test)
