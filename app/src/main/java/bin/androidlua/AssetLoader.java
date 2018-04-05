package bin.androidlua;

import android.content.Context;
import android.content.res.AssetManager;

import bin.luajava.JavaFunction;
import bin.luajava.LuaException;
import bin.luajava.LuaState;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.PrintStream;

import static bin.androidlua.LuaRunner.readAll;

public class AssetLoader extends JavaFunction {
    private Context context;
    /**
     * Constructor that receives a LuaState.
     *
     * @param L LuaState object associated with this JavaFunction object
     */
    public AssetLoader(Context context, LuaState L) {
        super(L);
        this.context = context.getApplicationContext();
    }

    @Override
    public int execute() throws LuaException {
        String name = L.toString(-1);
        AssetManager am = context.getAssets();
        try {
            InputStream is = am.open("lua/" + name + ".lua");
            byte[] bytes = readAll(is);
            L.LloadBuffer(bytes, name);
            return 1;
        } catch (Exception e) {
            ByteArrayOutputStream os = new ByteArrayOutputStream();
            e.printStackTrace(new PrintStream(os));
            L.pushString("Cannot load module "+name+":\n"+os.toString());
            return 1;
        }
    }
}
