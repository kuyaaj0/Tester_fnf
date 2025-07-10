package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;

class PlayListWindow extends FlxSpriteGroup
{
    public var Hidding:Bool = true;
    public var leftRect:FlxSprite;
    public var rightRect:FlxSprite;
    
    private var tweenDuration:Float = 0.3;
    
    private var easeType:FlxEase = FlxEase.quadOut;
    
    private var leftHiddenX:Float;
    private var leftShownX:Float;
    private var rightHiddenX:Float;
    private var rightShownX:Float;

    public function new()
    {
        super();
        
        leftRect = new FlxSprite(0, 30);
        rightRect = new FlxSprite(FlxG.width, 30);

        var width:Int = Math.floor(FlxG.width * 0.3);
        var height:Int = Math.floor(FlxG.height * 0.8);
        var cornerRadius:Int = 20;
        
        leftRect.makeGraphic(width, height, flixel.util.FlxColor.TRANSPARENT, true);
        rightRect.makeGraphic(width, height, flixel.util.FlxColor.TRANSPARENT, true);
        
        FlxSpriteUtil.drawRoundRect(
            leftRect,
            0, 0,
            width, height,
            cornerRadius, cornerRadius,
            0xFF24232C,
            { thickness: 0 }
        );
        
        FlxSpriteUtil.drawRoundRect(
            rightRect,
            0, 0,
            width, height,
            cornerRadius, cornerRadius,
            0xFF24232C,
            { thickness: 0 }
        );
        
        leftHiddenX = -leftRect.width;
        leftShownX = 0;
        rightHiddenX = FlxG.width;
        rightShownX = FlxG.width - rightRect.width;
        
        leftRect.x = leftHiddenX;
        leftRect.y = 30;
        rightRect.x = rightHiddenX;
        rightRect.y = 30;
        
        add(leftRect);
        add(rightRect);
    }
    
    public function show():Void
    {
        if (!Hidding) return;
        
        Hidding = false;
        
        FlxTween.cancelTweensOf(leftRect);
        FlxTween.cancelTweensOf(rightRect);
        
        FlxTween.tween(leftRect, { x: leftShownX }, tweenDuration, {
            ease: easeType,
            onComplete: function(t:FlxTween) {
                leftRect.x = leftShownX;
            }
        });

        FlxTween.tween(rightRect, { x: rightShownX }, tweenDuration, {
            ease: easeType,
            onComplete: function(t:FlxTween) {
                rightRect.x = rightShownX;
            }
        });
    }
    
    public function hide():Void
    {
        if (Hidding) return;
        
        Hidding = true;
        
        FlxTween.cancelTweensOf(leftRect);
        FlxTween.cancelTweensOf(rightRect);
        
        FlxTween.tween(leftRect, { x: leftHiddenX }, tweenDuration, {
            ease: easeType,
            onComplete: function(t:FlxTween) {
                leftRect.x = leftHiddenX;
            }
        });
        
        FlxTween.tween(rightRect, { x: rightHiddenX }, tweenDuration, {
            ease: easeType,
            onComplete: function(t:FlxTween) {
                rightRect.x = rightHiddenX;
            }
        });
    }
    
    public function toggle():Void
    {
        if (Hidding) {
            show();
        } else {
            hide();
        }
    }
}