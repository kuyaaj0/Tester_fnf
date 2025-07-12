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
    
    // 在类顶部添加这些变量
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
                buttonsStartY = rightButtons.y;
            }
        }
    
        if (FlxG.mouse.justReleased) {
            isDragging = false;
        }
    
        if (isDragging) {
            var dragOffset = FlxG.mouse.y - dragStartY;
            var newY = buttonsStartY + dragOffset;
    
            // 限制拖动范围
            var maxScroll = rightLabel.y + rightLabel.height;
            var minScroll = rightRect.y + rightRect.height - rightButtons.height;
            rightButtons.y = Math.max(minScroll, Math.min(maxScroll, newY));
        }
    
        // 精细裁剪：检查每个按钮是否部分可见
        var visibleTop = rightLabel.y + rightLabel.height;
        var visibleBottom = rightRect.y + rightRect.height;
    
        for (button in rightButtons.members) {
            // 计算按钮的全局坐标（相对于 rightRect）
            var buttonGlobalY = rightButtons.y + button.y;
    
            // 如果按钮完全不可见（在可视区域外）
            if (buttonGlobalY + button.height < visibleTop || buttonGlobalY > visibleBottom) {
                button.visible = false;
            }
            // 如果按钮部分可见（顶部被裁切）
            else if (buttonGlobalY < visibleTop) {
                var clipHeight = (buttonGlobalY + button.height) - visibleTop;
                button.clipRect = new FlxRect(
                    0,
                    button.height - clipHeight,  // 裁掉顶部不可见部分
                    button.width,
                    clipHeight  // 剩余可见高度
                );
                button.visible = true;
            }
            // 如果按钮部分可见（底部被裁切）
            else if (buttonGlobalY + button.height > visibleBottom) {
                var clipHeight = visibleBottom - buttonGlobalY;
                button.clipRect = new FlxRect(
                    0,
                    0,
                    button.width,
                    clipHeight  // 只显示到底部边界
                );
                button.visible = true;
            }
            // 完全可见
            else {
                button.clipRect = null;
                button.visible = true;
            }
        }
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