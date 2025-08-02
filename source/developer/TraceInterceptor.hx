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
    
    static function customLogLevel(level:ErrorSeverity, x, ?infos:haxe.PosInfos) {
        var (coloredHead, plainMessage) = switch(level) {
            case WARN: 
                var head = "WARN: ";
                var message = if (infos != null) {
                    '${infos.fileName}:${infos.lineNumber}: ' + Std.string(x);
                } else {
                    Std.string(x);
                };
                {head, message};
            
            case ERROR: 
                var head = "ERROR: ";
                var message = if (infos != null) {
                    '${infos.fileName}:${infos.lineNumber}: ' + Std.string(x);
                } else {
                    Std.string(x);
                };
                {head, message};
            
            case FATAL: 
                var head = "FATAL: ";
                var message = if (infos != null) {
                    '${infos.fileName}:${infos.lineNumber}: ' + Std.string(x);
                } else {
                    Std.string(x);
                };
                {head, message};
            
            case NONE: 
                var message = if (infos != null) {
                    '${infos.fileName}:${infos.lineNumber}: ' + Std.string(x);
                } else {
                    Std.string(x);
                };
                {"", message};
        };
    
        originalLogLevel(level, x, infos);
        
        if (level != NONE) {
            Console.logWithColoredHead(coloredHead, plainMessage, getColorByLevel(level));
        } else {
            Console.log(plainMessage);
        }
    }
    
    static function getColorByLevel(level:ErrorSeverity):Int {
        return switch(level) {
            case WARN: 0xFFFF00; // 黄色
            case ERROR: 0xFF0000; // 红色
            case FATAL: 0xFF00FF; // 品红色
            case NONE: 0xFFFFFF; // 白色
        }
    }
}