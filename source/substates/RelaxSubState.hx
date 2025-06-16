package substates;

import lime.ui.Window;
import lime.ui.WindowAttributes;
import lime.app.Application;
import lime.graphics.RenderContext;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.Lib;

class RelaxSubState extends MusicBeatSubstate {
    var newWindow:Window = null;
    var mainContext:RenderContext;
    
    override function create() {
        //mainContext = Application.current.window.context;
        
        // 创建新窗口的属性
        var attrs:WindowAttributes = {
            title: "Relax Window",
            width: 800,
            height: 600,
            resizable: true,
            borderless: false,
            alwaysOnTop: false,
            fullscreen: false
        };
        
        newWindow = Application.current.createWindow(attrs);
        
        newWindow.onClose.add(() -> {
            close();
            Application.current.window.focus();
        });
        
        super.create();
    }
    
    override function destroy() {
        if(newWindow != null) {
            trace("fuck");
            FlxG.game.stage.invalidate();
        }
        super.destroy();
    }
    
    override function update(elapsed:Float) {
        //FlxG.game.stage.invalidate();
        super.update(elapsed);
    }
}