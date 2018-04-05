# Android Lua

Lua 的 Android 加强版实现，基于 Lua5.3.1 和 LuaJava，改进并增加了部分功能。

## 相对于LuaJava的改进

### 1.使用 "包名+类名" 访问 Java 类

```lua
import "bin.androidlua.TestObject"
test = TestObject()
-- 也可以写成
test = bin.androidlua.TestObject()
```

但不支持内部类，例如访问 TestObject.TwoMethod 时，得这么写
```lua
import "bin.androidlua.*"
TwoMethod = TestObject_TwoMethod -- TestObject$TwoMethod
```
包名的开头（bin、java、javax、com 等）需要在 [LuaRunner.java](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/main/java/bin/androidlua/LuaRunner.java) 中添加

### 2.优化方法重载

在开始的测试中发现 Lua 中调用 Java 方法时，对于方法重载（即方法名相同但参数不同），匹配机制十分糟糕。

例如方法 a(Object) 和 a(String)，参数传入 "abc" 时，两个方法都可以接受该参数，但明显应该匹配并调用 a(String) 才对。

而原先的匹配机制是按顺序匹配，然后调用第一个匹配成功的方法，只要 a(Object) 在 a(String) 前面，传入 "abc" 时就会调用成 a(Object) 了。

为此我设计了一套评分模式，具体实现可查看 [AssignScorer.java](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/main/java/bin/luajava/AssignScorer.java)

Lua 测试例子在 [OverloadTest.lua](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/main/assets/OverloadTest.lua)

### 3.增加 Getter 和 Setter 功能

```lua
-- 对于 Java 对象 a

x = a.getName()
-- 可简写成
x = a.name

a.setName(x)
-- 可简写成
a.name = x
```
只做了 get 和 set，is 暂时没做，有兴趣的可以修改 [LuaJavaAPI.java](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/main/java/bin/luajava/LuaJavaAPI.java) 中的 javaGetter 方法。

Lua 测试例子在 [GetterSetterTest.lua](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/main/assets/GetterSetterTest.lua)

### 4.增加 Java 接口实现功能

通过 Lua 代码实现 Java 的接口，具体看 [InterfaceTest.lua](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/main/assets/InterfaceTest.lua)，已经写得很详细了。


### 5.增强异常处理功能

不论是 Lua 代码出现异常，还是调用 Java 代码时出现异常，你都可以在 Lua 或者 Java 中捕获它，并且可以得到异常时的调用栈。

模仿 Java 粗糙地做了 try 和 catch 功能，支持 throw 来重新抛出异常。

具体请参考 [ErrorTest.lua](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/main/assets/ErrorTest.lua) 中的例子。

## 运行说明

我没有写 UI 界面，上面提到的例子均在单元测试 [LuaJavaTest.java](https://github.com/L-JINBIN/AndroidLua/blob/master/app/src/androidTest/java/bin/androidlua/LuaJavaTest.java) 中进行调用。

运行后请在 Logcat 查看输出，建议选择 No Filters 并输入 Lua 来过滤日志。

## 参考项目
- [LuaJava](https://github.com/jasonsantos/luajava)   
- [AndroLua](https://github.com/mkottman/AndroLua)
- [AndroLua_pro](https://github.com/nirenr/AndroLua_pro)