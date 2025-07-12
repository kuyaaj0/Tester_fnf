package objects.state.relaxState.windows;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;
import flixel.util.FlxDestroyUtil;

class RightList extends FlxSpriteGroup
{
    public var RightButtons:Map<Int, ListButtons> = new Map();
    public var onButtonClicked:Int->Void = null;
    public var onListUpdated:Void->Void = null;
    public var nowChoose:Int = 0;
    
    // 拖动相关变量
    private var isDragging:Bool = false;
    private var dragStartY:Float = 0;
    private var scrollOffset:Float = 0;
    private var scrollVelocity:Float = 0;
    private var inertiaTimer:Float = 0;
    
    // 渐变区域大小
    private var fadeZone:Float = 10; // 渐变区域高度
    private var buttonCount:Int = 0; // 按钮数量
    
    public function new(){
        super();
        updateList();
    }
    
    public function updateList(){
        clearButtons();
        
        var listCount = GetInit.getListNum();
        buttonCount = listCount; // 保存按钮数量
        var buttonWidth = FlxG.width * 0.3 - 10;
        
        for (i in 0...listCount) {
            var button = new ListButtons(10, i * 45, buttonWidth);
            var listName = GetInit.getAllListName().get(i);
            
            button.setText(listName != null ? listName : "Unnamed List");
            button.baseY = i * 45; // 设置基准Y位置
            
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
        scrollOffset = 0;
        updateButtonPositions();
        
        if (onListUpdated != null) {
            onListUpdated();
        }
    }
    
    override function update(elapsed:Float){
        super.update(elapsed);
        
        // 处理拖动
        handleDragging(elapsed);
        
        // 更新按钮位置和透明度
        updateButtonPositions();
    }
    
    private function handleDragging(elapsed:Float) {
        var mouseY = FlxG.mouse.y;
        
        // 开始拖动
        if (FlxG.mouse.justPressed && mouseY > 0 && mouseY < FlxG.height) {
            isDragging = true;
            dragStartY = mouseY;
            scrollVelocity = 0;
            inertiaTimer = 0;
        }
        
        // 拖动中
        if (isDragging && FlxG.mouse.pressed) {
            var deltaY = mouseY - dragStartY;
            scrollOffset += deltaY;
            scrollVelocity = deltaY / elapsed; // 记录速度用于惯性
            dragStartY = mouseY;
            inertiaTimer = 0.2; // 重置惯性计时器
        }
        
        // 结束拖动
        if (!FlxG.mouse.pressed) {
            isDragging = false;
        }
        
        // 应用惯性
        if (!isDragging && inertiaTimer > 0) {
            inertiaTimer -= elapsed;
            scrollOffset += scrollVelocity * elapsed;
            
            // 速度衰减
            scrollVelocity *= Math.max(0, 1 - elapsed * 5);
        }
        
        // 限制滚动范围
        var maxScroll = Math.max(0, (buttonCount * 45) - FlxG.height);
        scrollOffset = FlxMath.bound(scrollOffset, -maxScroll, 0);
    }
    
    private function updateButtonPositions() {
        for (button in RightButtons) {
            // 应用滚动偏移
            button.y = button.baseY + scrollOffset;
            
            // 计算透明度（边界渐变效果）
            var topEdge = -button.height;
            var bottomEdge = FlxG.height + button.height;
            var buttonTop = button.y;
            var buttonBottom = button.y + button.height;
            
            var topAlpha = FlxMath.remapToRange(buttonBottom, topEdge, topEdge + fadeZone, 0, 1);
            var bottomAlpha = FlxMath.remapToRange(buttonTop, bottomEdge - fadeZone, bottomEdge, 1, 0);
            
            var alpha = Math.min(topAlpha, bottomAlpha);
            button.alpha = Math.max(0, Math.min(1, alpha)); // 确保在0-1之间
        }
    }
    
    public function clearButtons() {
        for (button in RightButtons) {
            remove(button);
            FlxDestroyUtil.destroy(button);
        }
        RightButtons.clear();
    }
}