package developer;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import openfl.geom.Rectangle;

class Console extends Sprite {
    public static var consoleInstance(get, null):Console;
    private var output:TextField;
    private var buffer:Array<String> = [];
    private var isDragging:Bool = false;
    private var dragOffsetX:Float = 0;
    private var dragOffsetY:Float = 0;
    private var isScrolling:Bool = false;
    private var scrollStartY:Float = 0;
    private var scrollStartV:Int = 0;
    private var captureEnabled:Bool = true;
    private var autoScroll:Bool = true;
    
    // 按钮引用
    private var captureButton:Sprite;
    private var autoScrollButton:Sprite;
    
    private var pendingLogs:Array<String> = [];
    private var pendingColoredLogs:Array<{head:String, message:String, color:Int}> = [];
    private var renderTimer:haxe.Timer = null;
    private var maxBatchSize:Int = 100; // 每批处理的最大日志数
    private var renderDelay:Int = 100; // 渲染延迟(毫秒)
    
    private static var _consoleInstance:Console = null;
    private static function get_consoleInstance():Console {
        if (_consoleInstance == null) {
            _consoleInstance = new Console();
        }
        return _consoleInstance;
    }
    
    public function new() {
        super();
        createConsoleUI();
    }
    
    private function createConsoleUI():Void {
        // 控制台背景
        graphics.beginFill(0x333333, 0.8);
        graphics.drawRoundRect(0, 0, 550, 400, 10);
        graphics.endFill();
        
        // 输出文本框
        output = new TextField();
        output.defaultTextFormat = new TextFormat(Paths.font('Lang-ZH.ttf'), 12, 0xFFFFFF);
        output.width = 520;
        output.height = 320;
        output.x = 15;
        output.y = 50;
        output.multiline = true;
        output.wordWrap = true;
        output.selectable = true;
        output.htmlText = "";
        output.addEventListener(MouseEvent.MOUSE_DOWN, startTextScroll);
        addChild(output);
        
        createTitleBar();
        createControlButtons();
    }
    
    private function createTitleBar():Void {
        var titleBar = new Sprite();
        titleBar.graphics.beginFill(0x444444);
        titleBar.graphics.drawRoundRect(0, 0, 550, 30, 10, 10);
        titleBar.graphics.endFill();
        addChild(titleBar);
        
        var title = new TextField();
        title.text = "Trace Console (拖拽移动)";
        title.setTextFormat(new TextFormat(Paths.font('Lang-ZH.ttf'), 12, 0xFFFFFF));
        title.x = 10;
        title.y = 5;
        title.width = 300;
        title.selectable = false;
        titleBar.addChild(title);
    
        titleBar.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
            isDragging = true;
            dragOffsetX = e.stageX - x;
            dragOffsetY = e.stageY - y;
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onTitleDragMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, onTitleDragEnd);
            
            e.stopPropagation();
        });
    }
    
    private function onTitleDragMove(e:MouseEvent):Void {
        if (isDragging) {
            x = e.stageX - dragOffsetX;
            y = e.stageY - dragOffsetY;
            e.stopPropagation();
        }
    }
    
    private function onTitleDragEnd(e:MouseEvent):Void {
        if (isDragging) {
            isDragging = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTitleDragMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onTitleDragEnd);
            e.stopPropagation();
        }
    }
    
    private function createControlButtons():Void {
        var buttonY = 10;
        
        // 启用/禁用捕捉按钮
        captureButton = createButton("捕捉:开", 0xFF5555, 360, buttonY);
        captureButton.addEventListener(MouseEvent.CLICK, function(e) {
            toggleCapture();
        });
        
        // 自动滚动按钮
        autoScrollButton = createButton("自动滚动:开", 0x55AA55, 440, buttonY);
        autoScrollButton.addEventListener(MouseEvent.CLICK, function(e) {
            toggleAutoScroll();
        });
        
        // 清空按钮
        var clearButton = createButton("清空日志", 0x5555FF, 280, buttonY);
        clearButton.addEventListener(MouseEvent.CLICK, function(e) {
            clearLogs();
        });
        
        // 关闭按钮
        var closeButton = createButton("关闭", 0xAAAAAA, 200, buttonY);
        closeButton.addEventListener(MouseEvent.CLICK, function(e) {
            closeConsole();
        });
    }
    
    private function createButton(label:String, color:Int, xPos:Float, yPos:Float):Sprite {
        var button = new Sprite();
        button.graphics.beginFill(color);
        button.graphics.drawRoundRect(0, 0, 80, 20, 5);
        button.graphics.endFill();
        
        var text = new TextField();
        text.text = label;
        text.setTextFormat(new TextFormat(Paths.font('Lang-ZH.ttf'), 10, 0xFFFFFF));
        text.x = 5;
        text.y = 3;
        text.width = 70;
        text.selectable = false;
        button.addChild(text);
        
        button.x = xPos;
        button.y = yPos;
        addChild(button);
        
        button.addEventListener(MouseEvent.MOUSE_OVER, function(e) {
            Mouse.cursor = MouseCursor.BUTTON;
        });
        
        button.addEventListener(MouseEvent.MOUSE_OUT, function(e) {
            Mouse.cursor = MouseCursor.AUTO;
        });
        
        return button;
    }
    
    private function startTextScroll(e:MouseEvent):Void {
        isScrolling = true;
        scrollStartY = e.stageY;
        scrollStartV = output.scrollV;
        stage.addEventListener(MouseEvent.MOUSE_MOVE, doTextScroll);
        stage.addEventListener(MouseEvent.MOUSE_UP, stopTextScroll);
    }
    
    private function doTextScroll(e:MouseEvent):Void {
        if (isScrolling) {
            var deltaY:Int = Std.int((e.stageY - scrollStartY) / 3);
            output.scrollV = scrollStartV - deltaY;
            if (autoScroll) {
                toggleAutoScroll(false);
            }
            updateAutoScrollButton();
        }
    }
    
    private function stopTextScroll(e:MouseEvent):Void {
        isScrolling = false;
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, doTextScroll);
        stage.removeEventListener(MouseEvent.MOUSE_UP, stopTextScroll);
    }
    
    private function startDragConsole(e:MouseEvent):Void {
        isDragging = true;
        dragOffsetX = e.stageX - x;
        dragOffsetY = e.stageY - y;
        stage.addEventListener(MouseEvent.MOUSE_MOVE, dragConsole);
    }
    
    private function stopDragConsole(e:MouseEvent):Void {
        isDragging = false;
        if (stage != null) {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragConsole);
        }
    }
    
    private function dragConsole(e:MouseEvent):Void {
        if (isDragging) {
            x = e.stageX - dragOffsetX;
            y = e.stageY - dragOffsetY;
        }
    }
    
    private function scrollToBottom():Void {
        output.scrollV = output.maxScrollV;
    }
    
    private function toggleCapture():Void {
        captureEnabled = !captureEnabled;
        updateCaptureButton();
    }
    
    private function toggleAutoScroll(?value:Bool):Void {
        autoScroll = value != null ? value : !autoScroll;
        if (autoScroll) scrollToBottom();
        updateAutoScrollButton();
    }
    
    private function clearLogs():Void {
        output.htmlText = "";
    }
    
    private function closeConsole():Void {
        visible = false;
        ConsoleToggleButton.show();
    }
    
    private function updateCaptureButton():Void {
        var textField:TextField = cast(captureButton.getChildAt(0), TextField);
        textField.setTextFormat(new TextFormat(Paths.font('Lang-ZH.ttf'), 10, 0xFFFFFF));
        textField.text = captureEnabled ? "捕捉:开" : "捕捉:关";
    }
    
    private function updateAutoScrollButton():Void {
        var textField:TextField = cast(autoScrollButton.getChildAt(0), TextField);
        textField.setTextFormat(new TextFormat(Paths.font('Lang-ZH.ttf'), 10, 0xFFFFFF));
        textField.text = autoScroll ? "自动滚动:开" : "自动滚动:关";
    }
    
    public static function log(message:String):Void {
        if (consoleInstance != null) {
            consoleInstance.addLog(message);
        }
    }
    
    private function addLog(message:String):Void {
        if (!captureEnabled) return;
        
        pendingLogs.push(StringTools.htmlEscape(message));
        scheduleRender();
    }
    
    public static function show():Void {
        if (consoleInstance.parent == null) {
            openfl.Lib.current.stage.addChild(consoleInstance);
        }
        consoleInstance.visible = true;
        ConsoleToggleButton.hide();
    }
    
    public static function hide():Void {
        if (consoleInstance != null) {
            consoleInstance.visible = false;
        }
    }
    
    public static function isVisible():Bool {
        return consoleInstance != null && consoleInstance.visible;
    }
    
    public static function toggle():Void {
        if (isVisible()) {
            hide();
        } else {
            show();
        }
    }
    
    public static function logWithColoredHead(head:String, message:String, color:Int):Void {
        if (consoleInstance != null) {
            consoleInstance.addLogWithColoredHead(head, message, color);
        }
    }
    
    private function addLogWithColoredHead(head:String, message:String, color:Int):Void {
        if (!captureEnabled) return;
        
        pendingColoredLogs.push({
            head: head,
            message: message,
            color: color
        });
        scheduleRender();
    }
    
    private function scheduleRender():Void {
        if (renderTimer == null) {
            renderTimer = haxe.Timer.delay(processPendingLogs, renderDelay);
        }
    }
    
    private function processPendingLogs():Void {
        renderTimer = null;
        
        var hasNewContent = false;
        var batchCount = 0;
        
        // 处理普通日志
        while (pendingLogs.length > 0 && batchCount < maxBatchSize) {
            var message = pendingLogs.shift();
            appendToOutput(message);
            hasNewContent = true;
            batchCount++;
        }
        
        // 处理带颜色的日志
        while (pendingColoredLogs.length > 0 && batchCount < maxBatchSize) {
            var log = pendingColoredLogs.shift();
            var htmlLine = '<font color="#${StringTools.hex(log.color, 6)}">${StringTools.htmlEscape(log.head)}</font>${StringTools.htmlEscape(log.message)}';
            appendToOutput(htmlLine);
            hasNewContent = true;
            batchCount++;
        }
        
        if (hasNewContent && autoScroll) {
            scrollToBottom();
        }
        
        // 如果还有待处理日志，继续调度下一批
        if (pendingLogs.length > 0 || pendingColoredLogs.length > 0) {
            scheduleRender();
        }
    }
    
    private function appendToOutput(content:String):Void {
        if (output.htmlText != "") {
            output.htmlText += "<br/>" + content;
        } else {
            output.htmlText = content;
        }
    }
}