package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;

class RightList extends FlxSpriteGroup
{
    public var RightButtons:Map<Int, ListButtons> = new Map();
    //按下按钮后的回调
    public dynamic var onButtonClicked:Int->Void = null;
    // 列表更新完成后的回调
    public dynamic var onListUpdated:Void->Void = null;
    
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
            var button = new ListButtons(10, 50 + i * 45, buttonWidth);
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
    
    public function clearButtons() {
        for (button in RightButtons) {
            remove(button);
            button.destroy();
        }
        RightButtons.clear();
    }
    
    public function getButton(index:Int):Null<ListButtons> {
        return RightButtons.get(index);
    }
    
    public function getButtonCount():Int {
        return RightButtons.count();
    }
}