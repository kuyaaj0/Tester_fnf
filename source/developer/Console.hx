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
    
    private var colorBuffer:Array<Int> = []; // 存储每行对应的颜色值
    public static inline var MAX_LOG_LINES:Int = 200;
    
    // 按钮引用
    private var captureButton:Sprite;
    private var autoScrollButton:Sprite;
    
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
        captureButton = createButton("禁用捕捉", 0xFF5555, 360, buttonY);
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
    }
    
    private function clearLogs():Void {
        buffer = [];
        colorBuffer = [];
        output.text = "";
    }
    
    private function closeConsole():Void {
        visible = false;
        ConsoleToggleButton.show();
    }
    
    private function updateCaptureButton():Void {
        var textField:TextField = cast(captureButton.getChildAt(0), TextField);
        textField.setTextFormat(new TextFormat(Paths.font('Lang-ZH.ttf'), 10, 0xFFFFFF));
        textField.text = captureEnabled ? "禁用捕捉" : "启用捕捉";
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
        
        if (buffer.length >= MAX_LOG_LINES) {
            buffer.shift();
        }
        
        buffer.push(message);
        output.text = buffer.join("\n");
        
        if (autoScroll) {
            scrollToBottom();
        }
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
        
        var fullMessage = head + message;
        
        if (buffer.length >= MAX_LOG_LINES) {
            buffer.shift();
        }
        
        buffer.push(fullMessage);
        output.text = buffer.join("\n");
        
        var startIndex = output.text.length - fullMessage.length;
        var endIndex = startIndex + head.length;
        
        var coloredFormat = new TextFormat(Paths.font('Lang-ZH.ttf'), 12, color);
        output.setTextFormat(coloredFormat, startIndex, endIndex);
        
        if (autoScroll) {
            scrollToBottom();
        }
    }
}