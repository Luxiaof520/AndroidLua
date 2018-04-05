package bin.androidlua;

import android.content.Context;
import android.support.test.InstrumentationRegistry;
import android.support.test.runner.AndroidJUnit4;
import android.util.Log;

import org.junit.Test;
import org.junit.runner.RunWith;

import bin.luajava.LuaException;

/**
 * Instrumented test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
@RunWith(AndroidJUnit4.class)
public class LuaJavaTest {

    @Test
    public void overloadTest() throws Throwable {
        Context appContext = InstrumentationRegistry.getTargetContext();
        Log.i("Lua", "==============================================");

        LuaRunner runner = null;
        try {
            runner = new LuaRunner(appContext);
            runner.runFromAssets("OverloadTest.lua");
        } catch (Exception e) {
            Log.i("Lua", "run", e);
            throw e;
        } finally {
            if (runner != null && !runner.isClosed())
                runner.close();
        }
    }

    @Test
    public void errorTest() throws Throwable {
        Context appContext = InstrumentationRegistry.getTargetContext();
        Log.i("Lua", "==============================================");

        LuaRunner runner = null;
        try {
            runner = new LuaRunner(appContext);
            runner.runFromAssets("ErrorTest.lua");
            // javaError
            try {
                Object ret = runner.runFunction("javaError", "123456789");
                Log.i("Lua", "函数正常结束：" + ret);
            } catch (LuaException e) {
                Log.e("Lua", "Java捕获到错误", e);
            }
            // luaError
            try {
                Object ret = runner.runFunction("luaError");
                Log.i("Lua", "函数正常结束：" + ret);
            } catch (LuaException e) {
                Log.e("Lua", "Java捕获到错误", e);
            }
            // catchJavaError
            try {
                Object ret = runner.runFunction("catchJavaError", "987654321");
                Log.i("Lua", "函数正常结束：" + ret);
            } catch (LuaException e) {
                Log.e("Lua", "Java捕获到错误", e);
            }
            // catchLuaError
            try {
                Object ret = runner.runFunction("catchJavaError");
                Log.i("Lua", "函数正常结束：" + ret);
            } catch (LuaException e) {
                Log.e("Lua", "Java捕获到错误", e);
            }
            // catchJavaErrorAndRethrow
            try {
                Object ret = runner.runFunction("catchJavaErrorAndRethrow");
                Log.i("Lua", "函数正常结束：" + ret);
            } catch (LuaException e) {
                Log.e("Lua", "Java捕获到错误", e);
            }
            // catchLuaErrorAndRethrow
            try {
                Object ret = runner.runFunction("catchLuaErrorAndRethrow");
                Log.i("Lua", "函数正常结束：" + ret);
            } catch (LuaException e) {
                Log.e("Lua", "Java捕获到错误", e);
            }
        } finally {
            if (runner != null && !runner.isClosed())
                runner.close();
        }
    }

    @Test
    public void getterSetterTest() throws Throwable {
        Context appContext = InstrumentationRegistry.getTargetContext();
        Log.i("Lua", "==============================================");

        LuaRunner runner = null;
        try {
            runner = new LuaRunner(appContext);
            runner.runFromAssets("GetterSetterTest.lua");
        } finally {
            if (runner != null && !runner.isClosed())
                runner.close();
        }
    }

    @Test
    public void interfaceTest() throws Throwable {
        Context appContext = InstrumentationRegistry.getTargetContext();
        Log.i("Lua", "==============================================");

        LuaRunner runner = null;
        try {
            runner = new LuaRunner(appContext);
            runner.runFromAssets("InterfaceTest.lua");
        } finally {
            if (runner != null && !runner.isClosed())
                runner.close();
        }
    }

}
