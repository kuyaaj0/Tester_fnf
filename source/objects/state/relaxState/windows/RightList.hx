package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;

class RightList extends FlxSpriteGroup
{
    public var RightButtons:Map<Int, ListButtons> = new Map();
    //按下按钮后的回调
    public var onButtonClicked:Int->Void = null;
    // 列表更新完成后的回调
    public var onListUpdated:Void->Void = null;
    
    public var nowChoose:Int = 0;
    
    public function new(){
        super();
        updateList();
    }
    
    public function updateList(){
        clearButtons();
        
        var listCount = GetInit.getListNum();
        var buttonWidth = FlxG.width * 0.3 - 10;
        
        for (i in 0...listCount) {
            var button = new ListButtons(10, i * 45, buttonWidth);
            var listName = GetInit.getAllListName().get(i);
            
            button.setText(listName != null ? listName : "Unnamed List");
            
            button.onClick = function() {
                if (onButtonClicked != null) {
                    //按下按钮后的回调
                    onButtonClicked(i);
                    nowChoose = i;
                }
            };
            
            RightButtons.set(i, button);
            add(button);
        }
        
        // 列表更新完成后的回调
        if (onListUpdated != null) {
            onListUpdated();
        }
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);
    
        // 拖动逻辑（鼠标在 RightList 上按下时）
        if (FlxG.mouse.pressed && FlxG.mouse.overlaps(this)) {
            // 计算鼠标移动的偏移量（基于速度 * 时间）
            var deltaY = FlxG.mouse.velocity.y * elapsed;
    
            // 遍历所有按钮并调整 y 坐标
            for (button in RightButtons) {
                button.y += deltaY;
            }
    
            // 限制整个列表的拖动范围（防止拖出屏幕）
            constrainListPosition();
        }
    
        // 更新按钮透明度（渐隐效果）
        updateButtonsAlpha();
    }
    
    /** 限制 RightList 的拖动范围 */
    private function constrainListPosition() {
        var minY = 0; // 最小 y 值（顶部边界）
        var maxY = FlxG.height * 0.8 - getListHeight(); // 最大 y 值（底部边界）
    
        // 检查是否超出范围，并修正位置
        var listY = getFirstButtonY(); // 获取第一个按钮的 y 值（代表列表位置）
        if (listY < minY || listY > maxY) {
            var offset = listY < minY ? minY - listY : maxY - listY;
            
            // 修正所有按钮的位置
            for (button in RightButtons) {
                button.y += offset;
            }
        }
    }
    
    /** 获取第一个按钮的 y 坐标（用于判断列表位置） */
    private function getFirstButtonY():Float {
        return RightButtons.exists(0) ? RightButtons.get(0).y : 0;
    }
    
    /** 计算列表总高度（所有按钮高度 + 间距） */
    private function getListHeight():Float {
        if (RightButtons.count() == 0) return 0;
        var lastButton = RightButtons.get(RightButtons.count() - 1);
        return lastButton.y + lastButton.height - getFirstButtonY();
    }
    
    /** 更新按钮透明度（渐隐效果） */
    private function updateButtonsAlpha() {
        for (button in RightButtons) {
            if (button.y < 0) {
                button.alpha = 1 - button.y / 10;
            } 
            else if (button.y > Math.floor(FlxG.height * 0.8) - 10) {
                button.alpha = 1 - (button.y - (Math.floor(FlxG.height * 0.8)) - 10) / 10;
            } 
            else {
                button.alpha = 1;
            }
            button.allowChoose = (button.alpha > 0);
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