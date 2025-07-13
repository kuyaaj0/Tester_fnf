package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;
import flixel.FlxG;
import flixel.math.FlxMath;
import Lambda;

class LeftList extends FlxSpriteGroup
{
    public var LeftButtons:Map<Int, ListButtons> = new Map();
    public var onButtonClicked:Int->Void = null;
    public var onListUpdated:Void->Void = null;
    
    // 滚动相关变量
    private var scrollY:Float = 0;
    private var targetScrollY:Float = 0;
    private var isDragging:Bool = false;
    private var lastMouseY:Float = 0;
    private var scrollSpeed:Float = 0;
    private var scrollFriction:Float = 0.9;
    
    // 布局参数
    private static final BUTTON_HEIGHT:Float = 40;
    private static final BUTTON_SPACING:Float = 22.5;
    private static final BUTTON_PADDING_TOP:Float = 60;
    private static final BUTTON_WIDTH_PADDING:Float = 20;
    
    // 显示范围
    private var topBoundary:Float = 60;
    private var bottomBoundary:Float = Math.floor(FlxG.height * 0.8) - 5;
    
    public function new(nowChoose:Int = 0){
        super();
        updateList(nowChoose);
    }
    
    public function updateList(nowChoose:Int = 0){
        clearButtons();
        
        var songList = GetInit.getList(nowChoose).list;
        var buttonWidth = FlxG.width * 0.3 - BUTTON_WIDTH_PADDING;
        
        for (i in 0...songList.length) {
            var yPos = BUTTON_PADDING_TOP + i * BUTTON_SPACING;
            var button = new ListButtons(10, yPos, buttonWidth, BUTTON_HEIGHT);
            
            button.setText(songList[i].name != null ? songList[i].name : "unknown");
            
            button.onClick = function(btn:ListButtons) {
                if (onButtonClicked != null) {
                    onButtonClicked(i);
                }
                PlayListWindow.instance.nowChoose = [nowChoose, i];
                PlayListWindow.instance.handleDoubleClickCheck();
            };
            
            LeftButtons.set(i, button);
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
            if (FlxG.mouse.overlaps(PlayListWindow.instance.leftRect)) {
                isDragging = true;
                lastMouseY = FlxG.mouse.y;
                scrollSpeed = 0;
            }
        }
        
        if (isDragging && FlxG.mouse.pressed) {
            var deltaY = FlxG.mouse.y - lastMouseY;
            targetScrollY -= deltaY;
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
        
        // 修正滚动范围限制（仅修改这部分）
        var buttonCount = Lambda.count(LeftButtons);
        var contentHeight = buttonCount * (BUTTON_HEIGHT + BUTTON_SPACING) + BUTTON_PADDING_TOP;
        var visibleHeight = bottomBoundary - topBoundary;
        
        if (contentHeight > visibleHeight) {
            var maxScroll = contentHeight - visibleHeight;
            targetScrollY = FlxMath.bound(targetScrollY, 0, maxScroll);
        } else {
            targetScrollY = 0;
        }
        
        // 平滑滚动
        scrollY = FlxMath.lerp(scrollY, targetScrollY, 0.2);
    }
    
    // 完全保留原有的淡入淡出逻辑
    private function updateButtonPositions() {
        for (i => button in LeftButtons) {
            var yPos = BUTTON_PADDING_TOP + i * BUTTON_SPACING - scrollY;
            button.y = yPos;
            
            var alpha = 1.0;
            
            var upY:Float = topBoundary - i * BUTTON_SPACING;
            var downY:Float = bottomBoundary - (i + 1) * BUTTON_SPACING;
            if (yPos < upY) {
                alpha = FlxMath.remapToRange(yPos, upY - 30, upY, 0, 1);
            } else if (yPos > downY - BUTTON_HEIGHT) {
                alpha = FlxMath.remapToRange(yPos, downY - BUTTON_HEIGHT, downY - BUTTON_HEIGHT + 30, 1, 0);
            }
            
            alpha = FlxMath.bound(alpha, 0, 1);
            button.alpha = alpha;
            
            button.allowChoose = (alpha > 0.4);
        }
    }
    
    public function clearButtons() {
        for (button in LeftButtons) {
            remove(button);
            button.destroy();
        }
        LeftButtons.clear();
    }
}