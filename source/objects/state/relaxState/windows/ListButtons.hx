package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.input.mouse.FlxMouseEvent;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;
import backend.relax.GetInit;

class ListButton extends FlxSpriteGroup
{
    public var ListMap:Map<Int, String>;
    public var buttonHeight:Float = 28; // 按钮高度
    public var buttonWidth:Float;      // 按钮宽度（动态计算）
    public var padding:Float = 5;      // 按钮间距
    public var cornerRadius:Float = 8; // 圆角半径
    
    private var isDragging:Bool = false;
    private var dragOffsetY:Float = 0;
    private var minY:Float = 0;
    private var maxY:Float = 0;
    
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        buttonWidth = FlxG.width * 0.3 - 10;
        ListMap = GetInit.getAllListName();
        
        createButtons();
        setupDrag();
    }
    
    private function createButtons()
    {
        var yPosition:Float = 0;
        
        for (key => value in ListMap)
        {
            var button = new FlxButton(0, yPosition, "", function() {
                onButtonClick(key, value);
            });
            
            button.width = buttonWidth;
            button.height = buttonHeight;
            
            button.makeGraphic(Std.int(buttonWidth), Std.int(buttonHeight), 0x00FFFFFF, true);
            FlxSpriteUtil.drawRoundRect(
                button,
                0, 0,
                buttonWidth, buttonHeight,
                cornerRadius, cornerRadius,
                0xFF514F63,
                { thickness: 0 }
            );
            
            // 添加文本
            var disNum:Int = key + 1;
            var text = new flixel.text.FlxText(10, 4, buttonWidth - 20, disNum + '. ' + value, 12);
            text.color = 0xFFFFFFFF;
            button.loadGraphicFromSprite(button);
            button.add(text);
            
            add(button);
            yPosition += buttonHeight + padding;
        }
        
        calculateDragBounds();
    }
    
    private var dragThreshold:Float = 10.0;
    private var dragStartPos:FlxPoint = FlxPoint.get();
    private var hasDragged:Bool = false;
    
    private function setupDrag()
    {
        FlxMouseEvent.add(this, 
            function(s) {
                dragStartPos.set(FlxG.mouse.x, FlxG.mouse.y);
                hasDragged = false;
                isDragging = true;
                dragOffsetY = FlxG.mouse.y - this.y;
            },
            null,
            function(s) { 
                isDragging = false;
                
                if (!hasDragged) {
                    var clickedButton = getClickedButton();
                    if (clickedButton != null) {
                        var key = getButtonKey(clickedButton);
                        if (key != null) {
                            onButtonClick(key, ListMap[key]);
                        }
                    }
                }
            },
            function(s) {
                if (isDragging) {
                    if (!hasDragged) {
                        var dx = FlxG.mouse.x - dragStartPos.x;
                        var dy = FlxG.mouse.y - dragStartPos.y;
                        var distSq = dx * dx + dy * dy;
                        
                        if (distSq > dragThreshold * dragThreshold) {
                            hasDragged = true;
                        }
                    }
                    
                    var newY = FlxG.mouse.y - dragOffsetY;
                    this.y = Math.max(minY, Math.min(maxY, newY));
                }
            }
        );
    }
    
    private function getClickedButton():FlxButton
    {
        for (member in members) {
            if (Std.isOfType(member, FlxButton)) {
                var button:FlxButton = cast member;
                if (button.overlapsPoint(FlxG.mouse.getPosition())) {
                    return button;
                }
            }
        }
        return null;
    }
    
    private function getButtonKey(button:FlxButton):Null<Int>
    {
        for (key => value in ListMap) {
            if (button.label != null && button.label.text.contains('$key.')) {
                return key;
            }
        }
        return null;
    }
    
    private function onButtonClick(key:Int, value:String)
    {
        if (key != helpKey) {
            helpKey = key;
            PlayListWindow.nowChoose = [key, -1];
        }
    }
    
    public function reload(newX:Float, newY:Float)
    {
        this.x = newX;
        this.y = newY;
        clear();
        ListMap = GetInit.getAllListName();
        createButtons();
        calculateDragBounds();
    }
}