package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;
import flixel.input.mouse.FlxMouseEventManager;

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
    
    public function new(){
        super();
        updateList();
        
        FlxMouseEventManager.add(this, null, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
    }
    
    public function updateList(){
        clearButtons();
        
        var listCount = GetInit.getListNum();
        var buttonWidth = FlxG.width * 0.3 - 10;
        
        var contentHeight = listCount * 45;
        minY = Math.min(0, FlxG.height - contentHeight);
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
    
    private function onMouseDown(object:Dynamic):Void {
        isDragging = true;
        dragOffsetY = FlxG.mouse.y - y;
    }
    
    private function onMouseUp(object:Dynamic):Void {
        isDragging = false;
    }
    
    private function onMouseOver(object:Dynamic):Void {}
    private function onMouseOut(object:Dynamic):Void {}
    
    override function update(elapsed:Float){
        super.update(elapsed);
        
        if (isDragging) {
            var targetY = FlxG.mouse.y - dragOffsetY;
            y = Math.max(minY, Math.min(maxY, targetY));
        }
        
        for (memb in RightButtons) {
            var screenY = memb.y + this.y;
            
            if(screenY < 0) {
                memb.alpha = 1 - (-screenY) / 10;
            }
            else if(screenY > Math.floor(FlxG.height * 0.8) - 10) {
                memb.alpha = 1 - (screenY - (Math.floor(FlxG.height * 0.8) - 10)) / 10;
            } else {
                memb.alpha = 1;
            }
            
            memb.allowChoose = memb.alpha > 0;
        }
    }
    
    public function clearButtons() {
        for (button in RightButtons) {
            remove(button);
            button.destroy();
        }
        RightButtons.clear();
    }
    
    override public function destroy():Void {
        FlxMouseEventManager.remove(this);
        super.destroy();
    }
}