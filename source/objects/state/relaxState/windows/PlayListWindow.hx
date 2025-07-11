package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;
import backend.relax.GetInit;
import objects.state.relaxState.windows.ListButtons;

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
    
    public var LeftbuttonIndexMap:Map<ListButtons, Int> = new Map();
    public var RightbuttonIndexMap:Map<ListButtons, Int> = new Map();
    public var leftButtons:Array<ListButtons>;
    public var rightButtons:Array<ListButtons>;
    private var leftLabel:FlxText;
    private var rightLabel:FlxText;
    
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
        
        leftLabel = new FlxText(leftHiddenX, 55, leftRect.width, "SONG LIST", 60);
        leftLabel.setFormat(Paths.font("montserrat.ttf"), 32, 0xFFFFFFFF, CENTER);
        leftLabel.borderStyle = OUTLINE;
        leftLabel.borderColor = 0xFF000000;
        add(leftLabel);
        
        rightLabel = new FlxText(rightHiddenX, 55, rightRect.width, "PLAYLIST", 60);
        rightLabel.setFormat(Paths.font("montserrat.ttf"), 32, 0xFFFFFFFF, CENTER);
        rightLabel.borderStyle = OUTLINE;
        rightLabel.borderColor = 0xFF000000;
        add(rightLabel);
        
        CreateRightButton();
        
        instance = this;
    }
    
    public function show():Void {
    if (!Hidding) return;
    Hidding = false;
    
    FlxTween.cancelTweensOf(leftRect);
    FlxTween.cancelTweensOf(rightRect);
    FlxTween.cancelTweensOf(leftLabel);
    FlxTween.cancelTweensOf(rightLabel);
    
    FlxTween.tween(leftRect, { x: leftShownX }, tweenDuration, { ease: FlxEase.quadOut });
    FlxTween.tween(rightRect, { x: rightShownX }, tweenDuration, { ease: FlxEase.quadOut });
    
    FlxTween.tween(leftLabel, { x: leftShownX }, tweenDuration, { ease: FlxEase.quadOut });
    FlxTween.tween(rightLabel, { x: rightShownX }, tweenDuration, { ease: FlxEase.quadOut });
    
    try {
        if(leftButtons != null && leftButtons.length > 0) {
            for (btn in leftButtons) {
                btn.active = true;
                btn.visible = true;
                FlxTween.cancelTweensOf(btn);
                btn.x = leftHiddenX;
                FlxTween.tween(btn, { x: leftShownX }, tweenDuration, { ease: FlxEase.quadOut });
            }
        }
        if(rightButtons != null && rightButtons.length > 0) {
            for (btn in rightButtons) {
                btn.active = true; // 确保按钮激活
                btn.visible = true;
                FlxTween.cancelTweensOf(btn);
                btn.x = rightHiddenX; // 从隐藏位置开始
                FlxTween.tween(btn, { x: rightShownX }, tweenDuration, { ease: FlxEase.quadOut });
            }
        }
    } catch(e:Dynamic) {
        trace("Show animation error: " + e);
    }
}

    public function hide():Void {
        if (Hidding) return;
        Hidding = true;
        
        FlxTween.cancelTweensOf(leftRect);
        FlxTween.cancelTweensOf(rightRect);
        FlxTween.cancelTweensOf(leftLabel);
        FlxTween.cancelTweensOf(rightLabel);
        
        FlxTween.tween(leftRect, { x: leftHiddenX }, tweenDuration, { ease: FlxEase.quadOut });
        FlxTween.tween(rightRect, { x: rightHiddenX }, tweenDuration, { ease: FlxEase.quadOut });
        
        FlxTween.tween(leftLabel, { x: leftHiddenX }, tweenDuration, { ease: FlxEase.quadOut });
        FlxTween.tween(rightLabel, { x: rightHiddenX }, tweenDuration, { ease: FlxEase.quadOut });
        
        try {
            if(leftButtons != null && leftButtons.length > 0) {
                for (btn in leftButtons) {
                    FlxTween.cancelTweensOf(btn);
                    FlxTween.tween(btn, { x: leftHiddenX }, tweenDuration, { 
                        ease: FlxEase.quadOut,
                        onComplete: function() {
                            btn.active = false;
                            btn.visible = false;
                        }
                    });
                }
            }
            if(rightButtons != null && rightButtons.length > 0) {
                for (btn in rightButtons) {
                    FlxTween.cancelTweensOf(btn);
                    FlxTween.tween(btn, { x: rightHiddenX }, tweenDuration, { 
                        ease: FlxEase.quadOut,
                        onComplete: function() {
                            btn.active = false;
                            btn.visible = false;
                        }
                    });
                }
            }
        }
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

    public function CreateRightButton() {
        rightButtons = [];
        RightbuttonIndexMap.clear();
        
        for (i in 0...GetInit.getListNum()) {
            var button = new ListButtons(rightShownX, 60 + i * 45, FlxG.width * 0.3 - 10);
            var helpMap = GetInit.getAllListName();
            button.setText(helpMap.get(i));
            
            RightbuttonIndexMap.set(button, i);
            
            button.onClick = function() {
                nowChoose[0] = RightbuttonIndexMap.get(button);
                if (leftButtons != null) {
                    for (btn in leftButtons) {
                        remove(btn);
                        btn.destroy();
                    }
                }
                CreateLeftButton();
            };
            
            rightButtons.push(button);
            add(button);
            button.camera = RelaxSubState.instance.camOption;
        }
    }
    
    public function CreateLeftButton() {
        leftButtons = [];
        LeftbuttonIndexMap.clear();
        
        for (i in 0...GetInit.getList(nowChoose[0]).list.length) {
            var button = new ListButtons(leftShownX, 60 + i * 45, FlxG.width * 0.3 - 10);
            button.setText(GetInit.getList(nowChoose[0]).list[i].name);
            
            LeftbuttonIndexMap.set(button, i);
            
            button.onClick = function() {
                nowChoose[1] = LeftbuttonIndexMap.get(button);
                handleDoubleClickCheck();
            };
            
            leftButtons.push(button);
            add(button);
            button.camera = RelaxSubState.instance.camOption;
        }
    }
}