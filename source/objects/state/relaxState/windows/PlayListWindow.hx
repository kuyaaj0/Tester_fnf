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
    
    override public function update(){
        for (member in [leftButtons ,rightButtons]){
            for (Button in member)
                changeRect(Button, 115, Math.floor(FlxG.height * 0.8));
        }
        
        handleButtonDrag(leftButtons, elapsed);
        handleButtonDrag(rightButtons, elapsed);
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
    
    private var dragData:Map<FlxSpriteGroup, {
        isDragging:Bool,
        lastY:Float,
        velocity:Float,
        targetY:Float
    }> = new Map();
    
    private function handleButtonDrag(buttons:FlxSpriteGroup, elapsed:Float):Void {
        // 初始化拖动数据
        if (!dragData.exists(buttons)) {
            dragData.set(buttons, {
                isDragging: false,
                lastY: buttons.y,
                velocity: 0,
                targetY: buttons.y
            });
        }
        var data = dragData.get(buttons);
    
        // 鼠标按下时开始拖动
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(buttons)) {
            data.isDragging = true;
            data.lastY = FlxG.mouse.y;
        }
    
        // 鼠标释放时停止拖动
        if (FlxG.mouse.justReleased) {
            data.isDragging = false;
        }
    
        // 拖动中：更新目标位置
        if (data.isDragging) {
            var deltaY = FlxG.mouse.y - data.lastY;
            data.targetY += deltaY;
            data.lastY = FlxG.mouse.y;
        }
    
        // 计算缓冲和摩擦力
        if (!data.isDragging) {
            // 施加摩擦力（逐渐减速）
            data.velocity *= Math.pow(0.9, elapsed * 60); // 0.9 是摩擦系数，可以调整
        } else {
            // 直接跟随鼠标（拖动时无缓冲）
            data.velocity = 0;
            buttons.y = data.targetY;
            return;
        }
    
        // 应用缓冲运动
        var damping = 0.2; // 缓冲系数（越小越平滑）
        buttons.y += (data.targetY - buttons.y) * damping + data.velocity;
    
        // 限制拖动范围（防止拖出边界）
        var minY = 120; // 初始Y位置
        var maxY = minY + leftRect.height - buttons.height; // 最大可拖动范围
    
        if (buttons.y < minY) {
            buttons.y = minY;
            data.targetY = minY;
            data.velocity = 0;
        } else if (buttons.y > maxY) {
            buttons.y = maxY;
            data.targetY = maxY;
            data.velocity = 0;
        }
    }
}