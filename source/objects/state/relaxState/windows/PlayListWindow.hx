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
        
        rightButtons.scrollFactor.set(1, 1); // 确保可以滚动
        rightButtons.clipRect = new FlxRect(
            rightRect.x,
            rightLabel.y + rightLabel.height,  // 从 rightLabel 下方开始
            rightRect.width,
            rightRect.height - (rightLabel.y + rightLabel.height - rightRect.y)  // 剩余高度
        );
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
    
    private var isDragging:Bool = false;
    private var dragStartY:Float = 0;
    private var buttonsStartY:Float = 0;

    override public function update(elapsed:Float) {
        super.update(elapsed);
    
        // 拖动逻辑
        if (FlxG.mouse.overlaps(rightRect)) {
            if (FlxG.mouse.justPressed) {
                isDragging = true;
                dragStartY = FlxG.mouse.y;
                buttonsStartY = rightButtons.y; // 记录初始Y（全局坐标）
            }
        }
    
        if (FlxG.mouse.justReleased) {
            isDragging = false;
        }
    
        if (isDragging) {
            var dragOffset = FlxG.mouse.y - dragStartY; // 鼠标移动的偏移量（全局坐标）
            var newY = buttonsStartY + dragOffset; // 新Y（全局坐标）
    
            // 计算可视区域高度（容器内部）
            var visibleHeight = Math.floor(FlxG.height * 0.8);
            var contentHeight = rightButtons.height; // 所有按钮的总高度
    
            // 如果内容高度 <= 可视高度，不允许滚动，固定在顶部
            if (contentHeight <= visibleHeight) {
                rightButtons.y = rightRect.y + (rightLabel.y + rightLabel.height - rightRect.y);
            }
            // 否则，限制滚动范围
            else {
                // 上边界：容器顶部（全局坐标）
                var topBound = rightRect.y + (rightLabel.y + rightLabel.height - rightRect.y);
                // 下边界：容器底部 - 内容高度（全局坐标）
                var bottomBound = rightRect.y + rightRect.height - contentHeight;
    
                rightButtons.y = Math.max(bottomBound, Math.min(topBound, newY));
            }
        }
    
        // 更新裁剪区域（确保超出部分不可见）
        rightButtons.clipRect = new FlxRect(
            rightRect.x,
            rightLabel.y + rightLabel.height,
            rightRect.width,
            rightRect.height - (rightLabel.y + rightLabel.height - rightRect.y)
        );
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