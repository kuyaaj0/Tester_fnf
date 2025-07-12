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
    
    override function update(elapsed:Float){
        super.update(elapsed);
    }
    
    public function clearButtons() {
        for (button in RightButtons) {
            remove(button);
            button.destroy();
        }
        RightButtons.clear();
    }
}