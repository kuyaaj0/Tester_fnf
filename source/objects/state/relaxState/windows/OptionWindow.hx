package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import shapeEx.Rect;
import substates.RelaxSubState;

class OptionWindow extends FlxSpriteGroup
{
    public static var instance:OptionWindow;
    
    public var Hidding:Bool = true;
    
    public var BackendRect:FlxSprite;
    public var optionButton:OptionButton;
    
    public function new(){
        super();
        BackendRect = new Rect(0, 60, 1280, 580, 20, 20, 0xFF24232C);
        BackendRect.alpha = 0;
        add(BackendRect);
        
        optionButton = new OptionButton(10, 70);
        for (i in optionButton.members){
		    i.cameras = [RelaxSubState.instance.camOption];
		}
		add(optionButton);
    }
    
    override public function update(elapsed:Float){
        super.update(elapsed);
        alpha = FlxMath.lerp(BackendRect.alpha, Hidding ? 0 : 0.7, 0.2);
    }
}