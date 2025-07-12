package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;
import flixel.FlxG;
import flixel.math.FlxMath;
import Lambda;

class RightList extends FlxSpriteGroup
{
    public var RightButtons:Map<Int, ListButtons> = new Map();
    public var onButtonClicked:Int->Void = null;
    public var onListUpdated:Void->Void = null;
    
    public var nowChoose:Int = 0;
    
    // 滚动相关变量
    private var scrollY:Float = 0;
    private var targetScrollY:Float = 0;
    private var isDragging:Bool = false;
    private var lastMouseY:Float = 0;
    private var scrollSpeed:Float = 0;
    private var scrollFriction:Float = 0.9;
    
    // 布局参数
    private static final BUTTON_HEIGHT:Float = 40;
    private static final BUTTON_SPACING:Float = 5;
    private static final BUTTON_PADDING_TOP:Float = 0;
    private static final BUTTON_WIDTH_PADDING:Float = 20;
    
    // 显示范围
    private var topBoundary:Float = 0;
    private var bottomBoundary:Float = Math.floor(FlxG.height * 0.8) - 10;
    
    public function new(){
        super();
        updateList();
    }
    
    public function updateList(){
        clearButtons();
        
        var listCount = GetInit.getListNum();
        var buttonWidth = FlxG.width * 0.3 - BUTTON_WIDTH_PADDING;
        
        for (i in 0...listCount) {
            var yPos = BUTTON_PADDING_TOP + i * (BUTTON_HEIGHT + BUTTON_SPACING);
            var button = new ListButtons(10, yPos, buttonWidth, BUTTON_HEIGHT);
            
            var listName = GetInit.getAllListName().get(i);
            button.setText(listName != null ? listName : "Unnamed List");
            
            button.onClick = function() {
                if (onButtonClicked != null) {
                    onButtonClicked(i);
                    nowChoose = i;
                }
            };
            
            RightButtons.set(i, button);
            add(button);
        }
        
        // 重置滚动位置
        scrollY = 0;
        targetScrollY = 0;
        
        if (onListUpdated != null) {
            onListUpdated();
        }
    }
    
    override function update(elapsed:Float){
        super.update(elapsed);
        
        handleScrolling();
        updateButtonPositions();
    }
    
    private function handleScrolling() {
        // 鼠标滚轮滚动
        var wheel = FlxG.mouse.wheel;
        if (wheel != 0) {
            targetScrollY -= wheel * 60;
        }
        
        // 触摸/鼠标拖动
        if (FlxG.mouse.justPressed) {
            if (FlxG.mouse.overlaps(this)) {
                isDragging = true;
                lastMouseY = FlxG.mouse.y;
                scrollSpeed = 0;
            }
        }
        
        if (isDragging && FlxG.mouse.pressed) {
            var deltaY = FlxG.mouse.y - lastMouseY;
            targetScrollY += deltaY;
            scrollSpeed = deltaY;
            lastMouseY = FlxG.mouse.y;
        }
        
        if (FlxG.mouse.justReleased) {
            isDragging = false;
        }
        
        // 惯性滚动
        if (!isDragging && Math.abs(scrollSpeed) > 0.1) {
            targetScrollY += scrollSpeed;
            scrollSpeed *= scrollFriction;
        } else {
            scrollSpeed = 0;
        }
        
        // 限制滚动范围
        var buttonCount = Lambda.count(RightButtons);
        var maxScroll = Math.max(0, (buttonCount * (BUTTON_HEIGHT + BUTTON_SPACING)) - (bottomBoundary - topBoundary));
        targetScrollY = FlxMath.bound(targetScrollY, 0, maxScroll);
        
        // 平滑滚动
        scrollY = FlxMath.lerp(scrollY, targetScrollY, 0.2);
    }
    
    private function updateButtonPositions() {
        for (i => button in RightButtons) {
            var yPos = BUTTON_PADDING_TOP + i * (BUTTON_HEIGHT + BUTTON_SPACING) - scrollY;
            button.y = yPos;
            
            // 计算alpha值
            var alpha = 1.0;
            
            // 顶部淡出
            if (yPos < topBoundary) {
                alpha = FlxMath.remapToRange(yPos, topBoundary - 30, topBoundary, 0, 1);
            }
            // 底部淡出
            else if (yPos > bottomBoundary - BUTTON_HEIGHT) {
                alpha = FlxMath.remapToRange(yPos, bottomBoundary - BUTTON_HEIGHT, bottomBoundary - BUTTON_HEIGHT + 30, 1, 0);
            }
            
            alpha = FlxMath.bound(alpha, 0, 1);
            button.alpha = alpha;
            
            // 根据是否在可见范围内启用/禁用按钮
            button.allowChoose = (yPos >= topBoundary - BUTTON_HEIGHT && yPos <= bottomBoundary);
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