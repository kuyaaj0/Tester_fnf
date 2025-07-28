package developer;

class TraceInterceptor {
    static var originalTrace = haxe.Log.trace;
    
    public static function init() {
        haxe.Log.trace = customTrace;
    }
    
    static function customTrace(v:Dynamic, ?infos:haxe.PosInfos) {
        var message = if (infos != null) {
            '${infos.fileName}:${infos.lineNumber}: $v';
        } else {
            Std.string(v);
        };

        originalTrace(v, infos);
    }
}