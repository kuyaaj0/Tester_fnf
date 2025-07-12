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
        
        rightButtons.cameras = [RelaxSubState.instance.ListCam];
        
        leftButtons = new LeftList(rightButtons.nowChoose);
        leftButtons.x = hideXL;
        leftButtons.y = 120;
        add(leftButtons);
        
        leftButtons.cameras = [RelaxSubState.instance.ListCam];
        
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
    
    private var isDragging:Bool = false;       // 是否正在拖动
    private var dragStartY:Float = 0;         // 拖动起始鼠标Y
    private var buttonsStartY:Float = 0;      // 拖动起始按钮组Y
    private var velocityY:Float = 0;          // 当前Y方向速度（用于惯性）
    private var lastY:Float = 0;              // 上一帧的Y位置（计算速度）
    //private var elasticity:Float = 0.3;       // 弹性系数 (0~1)
    private var friction:Float = 0.95;        // 摩擦力 (0.9~0.99)
    
    override public function update(elapsed:Float) {
        super.update(elapsed);
    
        // 初始化弹性（只需设置一次，可以放在 create() 里）
        rightButtons.elasticity = 0.3;
        
        // 鼠标按下时开始拖动
        if (FlxG.mouse.overlaps(rightRect) && FlxG.mouse.justPressed) {
            isDragging = true;
            dragStartY = FlxG.mouse.y;
            buttonsStartY = rightButtons.y;
            velocityY = 0;
        }
    
        // 鼠标释放时停止拖动
        if (FlxG.mouse.justReleased) {
            isDragging = false;
        }
    
        // 拖动中：更新位置
        if (isDragging) {
            var deltaY = FlxG.mouse.y - dragStartY;
            rightButtons.y = buttonsStartY + deltaY;
            
            // 同步所有子元素的 y 值
            for (member in rightButtons.members) {
                member.y = rightButtons.y;
            }
            
            velocityY = (rightButtons.y - lastY) / elapsed;
            lastY = rightButtons.y;
        }
        // 非拖动中：应用惯性 + 弹性
        else if (velocityY != 0) {
            rightButtons.y += velocityY * elapsed;
            for (member in rightButtons.members) {
                member.y = rightButtons.y;
            }
            
            velocityY *= friction;
            
            // 弹性边界检查（FlxObject 的弹性会自动处理碰撞）
            var minY:Float = 0;
            var maxY:Float = FlxG.height - rightButtons.height;
            
            if (rightButtons.y < minY || rightButtons.y > maxY) {
                velocityY *= -rightButtons.elasticity; // 使用父类的弹性系数
            }
            
            if (Math.abs(velocityY) < 1) velocityY = 0;
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