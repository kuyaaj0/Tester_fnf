package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;
import backend.relax.GetInit;
import objects.state.relaxState.windows.ListButtons;

import shapeEx.Rect;

import substates.RelaxSubState;

class PlayListWindow extends FlxSpriteGroup
{
    public static var instance:PlayListWindow;
    
    public var Hidding:Bool = true;
    
    public var leftRect:FlxSprite;
    public var rightRect:FlxSprite;
    
    private var leftLabel:FlxText;
    private var rightLabel:FlxText;
    
    public var leftButtons:LeftList;
    public var rightButtons:RightList;
    
    var hideXL:Float;
    var hideXR:Float;
    var showXL:Float;
    var showXR:Float;
    
    public var nowChoose:Array<Int> = [0, 0];
    
    public function new()
    {
        super();

        var width:Int = Math.floor(FlxG.width * 0.3);
        var height:Int = Math.floor(FlxG.height * 0.8);
        var cornerRadius:Int = 20;
        
        leftRect = new Rect(-width, 50, width, height, cornerRadius, cornerRadius, 0xFF24232C);
        rightRect = new Rect(FlxG.width, 50, width, height, cornerRadius, cornerRadius, 0xFF24232C);
        
        add(leftRect);
        add(rightRect);
        
        hideXL = -width;
        hideXR = FlxG.width;
        showXL = 0;
        showXR = FlxG.width - width;
        
        leftLabel = new FlxText(hideXL, 55, leftRect.width, "SONG LIST", 60);
        leftLabel.setFormat(Paths.font("montserrat.ttf"), 32, 0xFFFFFFFF, CENTER);
        leftLabel.borderStyle = OUTLINE;
        leftLabel.borderColor = 0xFF000000;
        add(leftLabel);
        
        rightLabel = new FlxText(hideXR, 55, rightRect.width, "PLAYLIST", 60);
        rightLabel.setFormat(Paths.font("montserrat.ttf"), 32, 0xFFFFFFFF, CENTER);
        rightLabel.borderStyle = OUTLINE;
        rightLabel.borderColor = 0xFF000000;
        add(rightLabel);
        
        rightButtons = new RightList();
        rightButtons.x = hideXR;
        rightButtons.y = 120;
        add(rightButtons);
        
        leftButtons = new LeftList(rightButtons.nowChoose);
        leftButtons.x = hideXL;
        leftButtons.y = 120;
        add(leftButtons);
        
        rightButtons.onButtonClicked = function(choose:Int){
            leftButtons.updateList(choose);
        };
        
        instance = this;
        
        camera = RelaxSubState.instance.camOption;
    }
    
    public function show():Void {
        if (!Hidding) return;
        Hidding = false;
        
        FlxTween.cancelTweensOf([for (o in [
            leftRect,
            rightRect,
            leftLabel,
            rightLabel,
            rightButtons,
            leftButtons
        ]) o]);
        
        for (obj in [leftRect, leftLabel, leftButtons])
            FlxTween.tween(obj,
                { x: showXL },
                0.2,
                { ease: FlxEase.quadOut }
            );
            
        for (obj in [rightRect, rightLabel, rightButtons])
            FlxTween.tween(obj,
                { x: showXR },
                0.2,
                { ease: FlxEase.quadOut });
                
        //这俩单独放出来是因为他们需要处于背景窗口的中间
        FlxTween.tween(leftButtons,{ x: showXL + 5 }, 0.2, { ease: FlxEase.quadOut });
        FlxTween.tween(rightButtons,{ x: showXR - 5 }, 0.2, { ease: FlxEase.quadOut });
    }

    public function hide():Void {
        if (Hidding) return;
        Hidding = true;
        
        FlxTween.cancelTweensOf([for (o in [
            leftRect,
            rightRect,
            leftLabel,
            rightLabel,
            rightButtons,
            leftButtons
        ]) o]);
        
        for (obj in [leftRect, leftLabel, leftButtons])
            FlxTween.tween(obj,
                { x: hideXL },
                0.2,
                { ease: FlxEase.quadOut }
            );
            
        for (obj in [rightRect, rightLabel, rightButtons])
            FlxTween.tween(obj,
                { x: hideXR },
                0.2,
                { ease: FlxEase.quadOut });
    }
    
    public function toggle():Void
    {
        if (Hidding) {
            show();
        } else {
            hide();
        }
    }
    
    override public function update(elapsed:Float){
        super.update(elapsed);
        
        for (str in rightButtons.members) {
            changeRect(str, 115, Math.floor(FlxG.height * 0.8));
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
    
    //找ai写的双击触发函数 --MaoPou
    private var _lastClickTime:Float = 0;
    private var _lastClickChoose1:Int = -1;
    private var _lastClickChoose2:Int = -1;
    private var _doubleClickThreshold:Float = 0.25; //双击间隔时间

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