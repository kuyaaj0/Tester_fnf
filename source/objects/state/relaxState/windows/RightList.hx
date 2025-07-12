package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxMath;
import backend.relax.GetInit;

class RightList extends FlxSpriteGroup
{
    public var RightButtons:Map<Int, ListButtons> = new Map();
    public var onButtonClicked:Int->Void = null;
    public var onListUpdated:Void->Void = null;
    
    public var nowChoose:Int = 0;
    
    // 滚动相关变量
    public var minY:Float = 0; // 最高显示位置
    public var maxY:Float = Math.floor(FlxG.height * 0.8) - 10; // 最低显示位置
    public var isDragging:Bool = false;
    public var dragStartY:Float = 0;
    public var listStartY:Float = 0;
    public var velocity:Float = 0;
    public var lastY:Float = 0;
    public var touchID:Int = -1;
    
    // 按钮间距和尺寸
    public static final BUTTON_HEIGHT:Float = 45;
    public static final BUTTON_SPACING:Float = 5;
    
    public function new(){
        super();
        updateList();
    }
    
    public function updateList(){
        clearButtons();
        
        var listCount = GetInit.getListNum();
        var buttonWidth = FlxG.width * 0.3 - 20; // 留出边距
        
        for (i in 0...listCount) {
            var button = new ListButtons(10, i * (BUTTON_HEIGHT + BUTTON_SPACING), buttonWidth, Std.int(BUTTON_HEIGHT));
            var listName = GetInit.getAllListName().get(i);
            
            button.setText(listName != null ? listName : "Unnamed List");
            
            button.onClick = function() {
                if (!isDragging && onButtonClicked != null) {
                    onButtonClicked(i);
                    nowChoose = i;
                    highlightSelectedButton();
                }
            };
            
            RightButtons.set(i, button);
            add(button);
        }
        
        highlightSelectedButton(); // 高亮当前选中按钮
        updateAlpha(); // 初始设置alpha
        
        if (onListUpdated != null) {
            onListUpdated();
        }
    }
    
    function highlightSelectedButton() {
        for (i => button in RightButtons) {
            button.setColor(i == nowChoose ? 0xFF908BB0 : 0xFF5C5970);
        }
    }
    
    override function update(elapsed:Float){
        super.update(elapsed);
        
        // 处理惯性滚动
        if (!isDragging && Math.abs(velocity) > 0) {
            velocity *= 0.9; // 摩擦力
            y += velocity;
            
            // 边界检查
            checkBounds();
            
            // 速度足够小时停止
            if (Math.abs(velocity) < 0.5) {
                velocity = 0;
            }
        }
        
        // 更新按钮的alpha值
        updateAlpha();
        
        // 处理触摸输入
        handleTouchInput();
    }
    
    function handleTouchInput() {
        #if mobile
        for (touch in FlxG.touches.list) {
            if (touch.justPressed && touch.overlaps(this)) {
                onPointerDown(touch.screenY, touch.touchPointID);
            }
            else if (touchID == touch.touchPointID) {
                if (touch.pressed) {
                    onPointerMove(touch.screenY);
                }
                if (touch.justReleased) {
                    onPointerUp();
                }
            }
        }
        #else
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this)) {
            onPointerDown(FlxG.mouse.screenY, -1);
        }
        if (touchID == -1 && FlxG.mouse.pressed) {
            onPointerMove(FlxG.mouse.screenY);
        }
        if (touchID == -1 && FlxG.mouse.justReleased) {
            onPointerUp();
        }
        #end
    }
    
    // 更新所有按钮的alpha值
    function updateAlpha() {
        for (button in RightButtons) {
            var buttonTop = button.y + y;
            var buttonBottom = buttonTop + button.height;
            
            // 顶部淡出
            if (buttonTop < minY) {
                button.alpha = FlxMath.remapToRange(buttonTop, minY - button.height, minY, 0, 1);
            }
            // 底部淡出
            else if (buttonBottom > maxY) {
                button.alpha = FlxMath.remapToRange(buttonBottom, maxY, maxY + button.height, 1, 0);
            }
            // 完全可见区域
            else {
                button.alpha = 1.0;
            }
            
            // 确保alpha在0-1范围内
            button.alpha = FlxMath.bound(button.alpha, 0, 1);
            
            // 如果按钮部分可见，禁用点击
            button.allowChoose = button.alpha > 0.5;
        }
    }
    
    // 检查边界并应用弹性
    function checkBounds() {
        var totalHeight = RightButtons.size * (BUTTON_HEIGHT + BUTTON_SPACING);
        var minPossibleY = FlxG.height - maxY - totalHeight;
        
        // 上边界
        if (y > minY) {
            y = minY;
            velocity = 0;
        }
        // 下边界（只有当列表高度超过可视区域时才需要）
        else if (totalHeight > maxY - minY && y < minPossibleY) {
            y = minPossibleY;
            velocity = 0;
        }
    }
    
    // 触摸/鼠标按下
    public function onPointerDown(yPos:Float, id:Int) {
        isDragging = true;
        touchID = id;
        dragStartY = yPos;
        listStartY = y;
        velocity = 0;
        lastY = y;
        
        // 临时禁用所有按钮的点击，防止误触
        for (button in RightButtons) {
            button.allowChoose = false;
        }
    }
    
    // 触摸/鼠标移动
    public function onPointerMove(yPos:Float) {
        if (isDragging) {
            var delta = yPos - dragStartY;
            y = listStartY + delta;
            checkBounds();
            
            // 计算速度（用于惯性滚动）
            velocity = y - lastY;
            lastY = y;
        }
    }
    
    // 触摸/鼠标释放
    public function onPointerUp() {
        isDragging = false;
        touchID = -1;
        
        // 重新启用按钮点击
        for (button in RightButtons) {
            button.allowChoose = true;
        }
    }
    
    public function clearButtons() {
        for (button in RightButtons) {
            remove(button);
            button.destroy();
        }
        RightButtons.clear();
    }
}