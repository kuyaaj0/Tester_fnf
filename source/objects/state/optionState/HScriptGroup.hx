package objects.state.optionState;

import psychlua.HScript;

class HScriptGroup extends OptionCata {
    public function new(X:Float, Y:Float, width:Float, height:Float, path:String) {
        super(x, Y, width, height);
        for(fn in FileSystem.readDirectory(path)) {
            if(fn.toLowerCase().endsWith('.hx')) {
                var sc:HScript = new HScript(path + fn, this);
                sc.execute();
                sc.call("onCreate");
            }
        }
    }
}