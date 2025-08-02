package developer;

class TraceInterceptor {
    static var originalTrace = haxe.Log.trace;
    
    public static function init() {
        haxe.Log.trace = customTrace;
        ConsoleToggleButton.show();
    }
    
    static function customTrace(v:Dynamic, ?infos:haxe.PosInfos) {
        var message = if (infos != null) {
            '${infos.fileName}:${infos.lineNumber}: ' + Std.string(v);
        } else {
            Std.string(v);
        };

        originalTrace(v, infos);
        
        if (Console.instance != null && Console.instance.visible) {
            Console.log(message);
        }
    }
}