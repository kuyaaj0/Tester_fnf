package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;

import substates.RelaxSubState;

class PlayListWindow extends FlxSpriteGroup
{
    public static var instance:PlayListWindow;
    public var Hidding:Bool = true;
    public var leftRect:FlxSprite;
    public var rightRect:FlxSprite;
    
    private var tweenDuration:Float = 0.3;

    private var leftHiddenX:Float;
    private var leftShownX:Float;
    private var rightHiddenX:Float;
    private var rightShownX:Float;
    
    public var nowChoose:Array<Int> = [0, 0];
    
    public function new()
    {
        super();
        
        leftRect = new FlxSprite(0, 50);
        rightRect = new FlxSprite(FlxG.width, 50);

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
        leftRect.y = 50;
        rightRect.x = rightHiddenX;
        rightRect.y = 50;
        
        add(leftRect);
        add(rightRect);
        
        createButtons();
        
        instance = this;
    }
    
    public var leftButtons:SongButtons;
    public var rightButtons:SongButtons;
    private var leftLabel:FlxText;
    private var rightLabel:FlxText;
    
    private function createButtons()
    {
        var labelHeight:Float = 30;
        
        leftLabel = new FlxText(leftShownX, 20, leftRect.width, "SONG LIST", 16);
        leftLabel.setFormat(null, 16, 0xFFFFFFFF, CENTER);
        leftLabel.borderStyle = OUTLINE;
        leftLabel.borderColor = 0xFF000000;
        add(leftLabel);
    
        leftButtons = new SongButtons(0, leftShownX, 50 + labelHeight);
        leftButtons.clipRect = new FlxRect(leftShownX, 50 + labelHeight, leftRect.width, leftRect.height - labelHeight);
        add(leftButtons);
    
        rightLabel = new FlxText(rightShownX, 20, rightRect.width, "PLAYLIST", 16);
        rightLabel.setFormat(null, 16, 0xFFFFFFFF, CENTER);
        rightLabel.borderStyle = OUTLINE;
        rightLabel.borderColor = 0xFF000000;
        add(rightLabel);
    
        rightButtons = new SongButtons(1, rightShownX, 50 + labelHeight);
        rightButtons.clipRect = new FlxRect(rightShownX, 50 + labelHeight, rightRect.width, rightRect.height - labelHeight);
        add(rightButtons);
    }
    
    public function show():Void
    {
        if (!Hidding) return;
        
        Hidding = false;
        
        FlxTween.cancelTweensOf(leftRect);
        FlxTween.cancelTweensOf(rightRect);
        FlxTween.cancelTweensOf(leftButtons);
        FlxTween.cancelTweensOf(rightButtons);
        FlxTween.cancelTweensOf(leftLabel);
        FlxTween.cancelTweensOf(rightLabel);
        
        FlxTween.tween(leftRect, { x: leftShownX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(rightRect, { x: rightShownX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(leftButtons, { x: leftShownX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(rightButtons, { x: rightShownX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(leftLabel, { x: leftShownX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(rightLabel, { x: rightShownX }, 0.2, { ease: FlxEase.quadOut });
    }
    
    public function hide():Void
    {
        if (Hidding) return;
        
        Hidding = true;
        
        FlxTween.cancelTweensOf(leftRect);
        FlxTween.cancelTweensOf(rightRect);
        FlxTween.cancelTweensOf(leftButtons);
        FlxTween.cancelTweensOf(rightButtons);
        FlxTween.cancelTweensOf(leftLabel);
        FlxTween.cancelTweensOf(rightLabel);
        
        FlxTween.tween(leftRect, { x: leftHiddenX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(rightRect, { x: rightHiddenX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(leftButtons, { x: leftHiddenX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(rightButtons, { x: rightHiddenX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(leftLabel, { x: leftHiddenX }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(rightLabel, { x: rightHiddenX }, 0.2, { ease: FlxEase.quadOut });
    }
    
    public function toggle():Void
    {
        if (Hidding) {
            show();
        } else {
            hide();
        }
    }
    
    private var _lastClickTime:Float = 0;
    private var _lastClickChoose1:Int = -1;
    private var _lastClickChoose2:Int = -1;
    private var _doubleClickThreshold:Float = 0.25;
    
    public function handleDoubleClickCheck():Void
    {
        var currentTime = Date.now().getTime() / 1000;
        
        if (currentTime - _lastClickTime < _doubleClickThreshold 
            && _lastClickChoose1 == nowChoose[0] 
            && _lastClickChoose2 == nowChoose[1])
        {
            _lastClickTime = 0;
            _lastClickChoose1 = -1;
            _lastClickChoose2 = -1;
            _onDoubleClick();
        }
        else
        {
            _lastClickTime = currentTime;
            _lastClickChoose1 = nowChoose[0];
            _lastClickChoose2 = nowChoose[1];
        }
    }

    private function _onDoubleClick():Void
    {
        RelaxSubState.instance.OtherListLoad(nowChoose);
    }
}