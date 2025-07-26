package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import shapeEx.Rect;

import substates.RelaxSubState;

class OptionWindow extends FlxSpriteGroup
{
    public static var instance:OptionWindow;
    
    public var Hidding:Bool = true;
    
    public var BackendRect:FlxSprite;
    
    public function new(){
        
    }
}