package developer;

class TraceInterceptor {
    static var originalTrace = haxe.Log.trace;
    static var originalLogLevel = crowplexus.iris.logLevel;
    
    public static function init() {
        haxe.Log.trace = customTrace;
        crowplexus.iris.logLevel = customLogLevel;
        ConsoleToggleButton.show();
    }
    
    static function customTrace(v:Dynamic, ?infos:haxe.PosInfos) {
        var message = if (infos != null) {
            '${infos.fileName}:${infos.lineNumber}: ' + Std.string(v);
        } else {
            Std.string(v);
        };

        originalTrace(v, infos);
        Console.log(message);
    }
    
    static function customLogLevel(level:crowplexus.iris.ErrorSeverity, x, ?infos:haxe.PosInfos) {
        var head = switch(level) {
            case WARN: "WARN: ";
            case ERROR: "ERROR: ";
            case FATAL: "FATAL: ";
            case NONE: "";
        };

        var message = if (infos != null) {
            '${infos.fileName}:${infos.lineNumber}: ' + Std.string(x);
        } else {
            Std.string(x);
        };

        originalLogLevel(level, x, infos);
        
        if (level != NONE) {
            Console.logWithColoredHead(head, message, getColorByLevel(level));
        } else {
            Console.log(message);
        }
    }

    static function getColorByLevel(level:crowplexus.iris.ErrorSeverity):Int {
        return switch(level) {
            case WARN: 0xFFFF00; // 黄色
            case ERROR: 0xFF0000; // 红色
            case FATAL: 0xFF00FF; // 品红色
            case NONE: 0xFFFFFF; // 白色
        }
    }
}