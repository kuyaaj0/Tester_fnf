package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;

class RightList extends FlxSpriteGroup
{
    public var RightButtons:Map<Int, ListButtons> = new Map();
    public var onButtonClicked:Int->Void = null;
    public var onListUpdated:Void->Void = null;
    
    public var nowChoose:Int = 0;
    
    private var isDragging:Bool = false;
    private var dragOffsetY:Float = 0;
    private var minY:Float = 0;
    private var maxY:Float = 0;
    private var originalY:Float = 0;
    private var lastMouseY:Float = 0;
    
    private var visibleAreaTop:Float = 120;
    private var visibleAreaBottom:Float = 110 + Math.floor(FlxG.height * 0.8);
    private var fadeDistance:Float = 10; 
    
    public function new(){
        super();
        updateList();
    }
    
    public function updateList(){
        clearButtons();
        
        var listCount = GetInit.getListNum();
        var buttonWidth = FlxG.width * 0.3 - 10;
        
        // 计算内容高度
        var contentHeight = listCount * 45;
        minY = Math.min(0, FlxG.height - contentHeight - visibleAreaTop);
        maxY = 0;
        originalY = y;
        
        for (i in 0...listCount) {
            var button = new ListButtons(10, i * 45, buttonWidth);
            var listName = GetInit.getAllListName().get(i);
            
            button.setText(listName != null ? listName : "Unnamed List");
            
            button.onClick = function() {
                if (onButtonClicked != null && !isDragging) {
                    onButtonClicked(i);
                    nowChoose = i;
                }
            };
            
            RightButtons.set(i, button);
            add(button);
        }
        
        if (onListUpdated != null) {
            onListUpdated();
        }
    }
    
    override function update(elapsed:Float){
        super.update(elapsed);
        
        // 鼠标按下检测
        if (FlxG.mouse.justPressed) {
            // 检查是否点击在列表的可视区域内
            if (FlxG.mouse.x > x && FlxG.mouse.x < x + width && 
                FlxG.mouse.y > visibleAreaTop && FlxG.mouse.y < visibleAreaBottom) {
                isDragging = true;
                dragOffsetY = FlxG.mouse.y - y;
                lastMouseY = FlxG.mouse.y;
            }
        }
        
        // 鼠标释放检测
        if (FlxG.mouse.justReleased) {
            isDragging = false;
        }
        
        // 处理拖动
        if (isDragging && FlxG.mouse.pressed) {
            var deltaY = FlxG.mouse.y - lastMouseY;
            var targetY = y + deltaY;
            y = Math.max(minY, Math.min(maxY, targetY));
            lastMouseY = FlxG.mouse.y;
        }
        
        // 更新按钮透明度 - 只对即将超出可视范围的按钮进行渐变
        for (memb in RightButtons) {
            var buttonTop = memb.y + this.y; // 按钮顶部在屏幕中的绝对位置
            var buttonBottom = buttonTop + memb.height; // 按钮底部在屏幕中的绝对位置
            
            // 初始设为完全可见
            memb.alpha = 1.0;
            memb.allowChoose = true;
            
            // 顶部淡出/淡入效果
            if (buttonTop < visibleAreaTop) {
                var distanceToEdge = visibleAreaTop - buttonTop;
                if (distanceToEdge < fadeDistance) {
                    // 接近顶部边缘 - 淡出
                    var fadeAmount = Math.min(1, distanceToEdge / fadeDistance);
                    memb.alpha = fadeAmount; // 从0到1渐变
                    memb.allowChoose = fadeAmount > 0.2; // 透明度低于20%时禁用选择
                } else if (buttonBottom > visibleAreaTop && buttonTop < visibleAreaTop - fadeDistance) {
                    // 完全在顶部边缘之外 - 完全透明
                    memb.alpha = 0;
                    memb.allowChoose = false;
                }
            }
            
            // 底部淡出/淡入效果
            if (buttonBottom > visibleAreaBottom) {
                var distanceToEdge = buttonBottom - visibleAreaBottom;
                if (distanceToEdge < fadeDistance) {
                    // 接近底部边缘 - 淡出
                    var fadeAmount = Math.min(1, distanceToEdge / fadeDistance);
                    memb.alpha = 1 - fadeAmount; // 从1到0渐变
                    memb.allowChoose = fadeAmount < 0.8; // 透明度低于20%时禁用选择
                } else if (buttonTop < visibleAreaBottom && buttonBottom > visibleAreaBottom + fadeDistance) {
                    // 完全在底部边缘之外 - 完全透明
                    memb.alpha = 0;
                    memb.allowChoose = false;
                }
            }
            
            // 完全在可视区域内的按钮
            if (buttonTop >= visibleAreaTop && buttonBottom <= visibleAreaBottom) {
                memb.alpha = 1.0;
                memb.allowChoose = true;
            }
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