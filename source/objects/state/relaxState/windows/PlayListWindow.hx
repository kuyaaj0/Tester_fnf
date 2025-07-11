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
    public var leftButtons:Array<ListButtons> = [];
    public var rightButtons:Array<ListButtons> = [];
    private var leftLabel:FlxText;
    private var rightLabel:FlxText;
    
    public var nowChoose:Array<Int> = [0, 0];
    var creatHide:Bool = true;
    
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
        leftLabel.setFormat(Paths.font("Lang-ZH.ttf"), 32, 0xFFFFFFFF, CENTER);
        leftLabel.borderStyle = OUTLINE;
        leftLabel.borderColor = 0xFF000000;
        add(leftLabel);
        
        rightLabel = new FlxText(rightHiddenX, 55, rightRect.width, "PLAYLIST", 60);
        rightLabel.setFormat(Paths.font("Lang-ZH.ttf"), 32, 0xFFFFFFFF, CENTER);
        rightLabel.borderStyle = OUTLINE;
        rightLabel.borderColor = 0xFF000000;
        add(rightLabel);
        
        CreateRightButton();
        
        instance = this;
        
        camera = RelaxSubState.instance.camOption;
    }
    
    var leftButtonAllHeight:Float = 0;
    var rightButtonAllHeight:Float = 0;
    
    var saveMouseY:Int = 0;
	var moveData:Int = 0;
	var avgSpeed:Float = 0;
    
    override function update(e:Float){
        for(button in leftButtons) changeRect(button, 115, FlxG.height * 0.8);
        for(button in rightButtons) changeRect(button, 115, FlxG.height * 0.8);
        
        leftButtonAllHeight = leftButtons.length * 45;
        rightButtonAllHeight = rightButtons.length * 45;
        
        updateMove();
    }
    
    function updateMove(){
        if (FlxG.mouse.pressed && FlxG.mouse.overlaps(leftRect))
        {
            if (leftButtonAllHeight > leftRect.height)
            {
                if (FlxG.mouse.justPressed)
                    saveMouseY = FlxG.mouse.y;
                
                moveData = FlxG.mouse.y - saveMouseY;
                saveMouseY = FlxG.mouse.y;
        
                for (button in leftButtons) {
                    button.y += moveData;
                }
            }
        }
        
        if (FlxG.mouse.pressed && FlxG.mouse.overlaps(rightRect))
        {
            if (rightButtonAllHeight > rightRect.height)
            {
                if (FlxG.mouse.justPressed)
                    saveMouseY = FlxG.mouse.y;
                
                moveData = FlxG.mouse.y - saveMouseY;
                saveMouseY = FlxG.mouse.y;
        
                for (button in rightButtons) {
                    button.y += moveData;
                }
            }
        }
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
        
        // 对按钮进行补间
        if(leftButtons != null && leftButtons.length > 0){
            for (btn in leftButtons) {
                FlxTween.cancelTweensOf(btn);
                var tweenX:Float;
                if(creatHide) tweenX = FlxG.width * 0.3 - 5;
                else tweenX = 0;
                FlxTween.tween(btn, {x: tweenX}, tweenDuration, { ease: FlxEase.quadOut });
            }
        }
        
        if(rightButtons != null && rightButtons.length > 0){
            for (btn in rightButtons) {
                FlxTween.cancelTweensOf(btn);
                FlxTween.tween(btn, {x: -(FlxG.width * 0.3 - 10) - 5}, tweenDuration, { ease: FlxEase.quadOut });
            }
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
        
        // 对按钮进行补间
        if(leftButtons != null && leftButtons.length > 0){
            for (btn in leftButtons) {
                FlxTween.cancelTweensOf(btn);
                var tweenX:Float;
                if(creatHide) tweenX = 0;
                else tweenX = -(FlxG.width * 0.3);
                FlxTween.tween(btn, {x: tweenX}, tweenDuration, { ease: FlxEase.quadOut });
            }
        }
        
        if(rightButtons != null && rightButtons.length > 0){
            for (btn in rightButtons) {
                FlxTween.cancelTweensOf(btn);
                FlxTween.tween(btn, {x: 0}, tweenDuration, { ease: FlxEase.quadOut });
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
        
        var shit = GetInit.getListNum();
        
        for (i in 0...shit) {
            var button = new ListButtons(FlxG.width, 120 + i * 45, FlxG.width * 0.3 - 10);
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
        }
    }
    
    public function CreateLeftButton() {
        leftButtons = [];
        LeftbuttonIndexMap.clear();
        
        for (i in 0...GetInit.getList(nowChoose[0]).list.length) {
            var button:ListButtons;
            if(Hidding) {
                button = new ListButtons(leftHiddenX, 120 + i * 45, FlxG.width * 0.3 - 10);
                creatHide = true;
            }else{
                button = new ListButtons(leftShownX + 5, 120 + i * 45, FlxG.width * 0.3 - 10);
                creatHide = false;
            }
            button.setText(GetInit.getList(nowChoose[0]).list[i].name);
            
            LeftbuttonIndexMap.set(button, i);
            
            button.onClick = function() {
                nowChoose[1] = LeftbuttonIndexMap.get(button);
                handleDoubleClickCheck();
            };
            
            leftButtons.push(button);
            add(button);
        }
    }
    
    function changeRect(str:ListButtons, startY:Float, overY:Float) { //ai真的太好用了喵 --狐月影
        // 获取选项矩形的顶部和底部坐标（相对于父容器）
        var optionTop = str.y;
        var optionBottom = str.y + str.height;
        
        // 计算实际可见区域
        var visibleTop = Math.max(optionTop, startY);    // 可见顶部取两者最大值
        var visibleBottom = Math.min(optionBottom, overY); // 可见底部取两者最小值
        
        // 完全不可见的情况（在背景上方或下方）
        if (visibleBottom <= startY || visibleTop >= overY) {
            str.visible = false;
            str.allowChoose = false;
            return;
        }
        
        // 设置可见性
        str.visible = true;
        str.allowChoose = true;

        // 计算裁剪参数（基于局部坐标系）
        var clipY = Math.max(0, startY - optionTop);  // 裁剪上边距
        var clipHeight = visibleBottom - visibleTop;  // 可见高度
        
        // 创建/更新裁剪矩形
        var swagRect = str.clipRect;
        if (swagRect == null) {
            swagRect = new FlxRect(0, clipY, str.width, clipHeight);
        } else {
            swagRect.set(0, clipY, str.width, clipHeight);
        }
        
        // 应用裁剪
        str.clipRect = swagRect;
    }
}