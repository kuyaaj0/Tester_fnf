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
            
            if(button.y > Math.floor(FlxG.height * 0.8) - 10){
                button.alpha = 1 - button.y / 10;
            }
            
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
    
    var saveY:Float;
    var moveData:Float;
    
    override function update(elapsed:Float){
        super.update(elapsed);
        
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.pressed) {
            if(FlxG.mouse.justPressed) saveY = FlxG.mouse.y;
            
            moveData = FlxG.mouse.y - saveY;
            saveY = FlxG.mouse.y;
            
            for(is in members){
                i = case(is, ListButtons);
                if(i.y > i.baseY){
                    i.y = i.baseY;
                }else if(members[0].y < -(this.height - Math.floor(FlxG.height * 0.8))){
                    i.y = i.baseY - (this.height - Math.floor(FlxG.height * 0.8));
                }
                i.y += moveData;
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