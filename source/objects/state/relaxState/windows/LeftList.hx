package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import backend.relax.GetInit;

class LeftList extends FlxSpriteGroup
{
    public var LeftButtons:Map<Int, ListButtons> = new Map();
    
    public var scrollY:Float = 0;
    public var scrollSpeed:Float = 20;
    
    public function new(nowChoose:Int = 0){
        super();
        updateList(nowChoose);
    }
    
    public function updateList(nowChoose:Int = 0){
        clearButtons();
        
        var shit = GetInit.getList(nowChoose).list.length; //即使没有一个歌单也会返回一个空歌单
        
        for (i in 0...shit) {
            var button = new ListButtons(0, i * 45, FlxG.width * 0.3 - 10);
            button.setText(GetInit.getList(nowChoose).list[i].name);
            button.onClick = function() {
                PlayListWindow.instance.nowChoose = [nowChoose, i];
                //向PlayListWindow发送双击请求
                PlayListWindow.instance.handleDoubleClickCheck();
            };
            add(button);
            
            LeftButtons.set(i, button);
        }
    }
    
    function clearButtons() {
        for (button in LeftButtons) {
            remove(button);
            button.destroy();
        }
        LeftButtons.clear();
    }
}