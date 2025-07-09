package objects.state.optionState.backend;

import flixel.math.FlxRect;

class StringRect extends FlxSpriteGroup
{
    var follow:Option;

    public var background:Rect;
    public var slider:Rect;

    public var options:Array<String>;
    public var optionSprites:Array<ChooseRect>;
    
    public var isDragging:Bool = false;

    public var currentSelection:Int = 0;
    
    public function new(X:Float, Y:Float, width:Float, height:Float, follow:Option)
    {
        super(X, Y);

        this.follow = follow;
        this.options = follow.strGroup;
        
        background = new Rect(0, 0, width, height, width / 75, width / 75, 0xffffff, 0.5);
        add(background);

        var init = 160;

        var calcWidth = width * (init - 1) / init;
        optionSprites = [];
        for (i in 0...options.length)
        {
            var option = new ChooseRect(0, i * height / 5, calcWidth, height / 5, options[i], i, this);
            add(option);
            optionSprites.push(option);
        }
        
        // 创建滑块
        var calcWidth = width / init;
        var calcHeight = height * 5 / options.length;
        if (calcHeight > height) calcHeight = height;
        slider = new Rect(width - calcWidth, 0, calcWidth, calcHeight, calcWidth / 5, calcWidth / 5, 0xffffff, 0.8);
        add(slider);
        
        // 设置初始选择
        //updateSelection(0);
        
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    
        var mouse = FlxG.mouse;
        
        // 检查鼠标是否在选项上
        if (FlxG.mouse.justPressed)
        {
            for (i in 0...optionSprites.length)
            {
                if (optionSprites[i].overlapsPoint(FlxG.mouse.getWorldPosition()))
                {
                    updateSelection(i);
                    break;
                }
            }
            
            // 检查是否点击了滑块
            if (slider.overlapsPoint(FlxG.mouse.getWorldPosition()))
            {
                isDragging = true;
            }
        }
        
        // 拖动滑块
        if (isDragging && FlxG.mouse.pressed)
        {
            /*
            var mouseY = FlxG.mouse.getWorldPosition().y;
            mouseY = FlxMath.bound(mouseY, sliderTrack.y + slider.height / 2, sliderTrack.y + sliderTrack.height - slider.height / 2);
            
            slider.y = mouseY;
            
            // 根据滑块位置更新可见区域
            var sliderPos = (slider.y - sliderTrack.y - slider.height / 2) / (sliderTrack.height - slider.height);
            var visibleHeight = height - 2 * padding;
            var contentHeight = options.length * background.height;
            var scrollY = (contentHeight - visibleHeight) * sliderPos;
            
            // 使用FlxRect切割选项显示
            for (i in 0...optionSprites.length)
            {
                var optionY = y + padding + (i * background.height) - scrollY;
                var optionRect = FlxRect.get(x + padding, optionY, 
                    realWidth - sliderWidth - 3 * padding, background.height - padding);
                
                // 检查选项是否在可见区域内
                var visibleRect = FlxRect.get(x + padding, y + padding, 
                    realWidth - sliderWidth - 3 * padding, realWidth - 2 * padding);
                
                var clippedRect = optionRect.intersection(visibleRect);
                
                if (clippedRect != null && clippedRect.height > 0)
                {
                    optionSprites[i].visible = true;
                    optionSprites[i].setPosition(clippedRect.x, clippedRect.y);
                    optionSprites[i].setGraphicSize(Std.int(clippedRect.width), Std.int(clippedRect.height));
                }
                else
                {
                    optionSprites[i].visible = false;
                }
            }
                */
        }
        else if (isDragging && FlxG.mouse.justReleased)
        {
            isDragging = false;
        }
    }
    
    private function updateSelection(index:Int):Void
    {
        /*
        if (index < 0 || index >= options.length) return;
        
        // 重置所有选项颜色
        for (option in optionSprites)
        {
            option.color = 0xffffff;
        }
        
        // 高亮当前选择
        optionSprites[index].color = FlxColor.GREEN;
        currentSelection = index;
        
        trace("Selected: " + options[index]);
        */ 
    }
}


class ChooseRect extends FlxSpriteGroup {
    public var background:Rect;
    public var textDis:FlxText;

    public var optionSort:Int;

    ///////////////////////////////////////////////////////////////////////////////

    public function new(X:Float, Y:Float, width:Float, height:Float, name:String, sort:Int, follow:StringRect) {
        super(X, Y);

        optionSort = sort;

        background = new Rect(0, 0, width, height, height / 5, height / 5, EngineSet.mainColor, 0.3);
        add(background);

        textDis = new FlxText(0, 0, 0, name, Std.int(height * 0.15));
		textDis.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(height * 0.45), 0xffffff, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        textDis.borderStyle = NONE;
		textDis.antialiasing = ClientPrefs.data.antialiasing;
        //textDis.x += height / 5;
        textDis.y += (height - textDis.height) * 0.5;
		add(textDis);
    }

    public var onFocus:Bool = false;
    public var onPress:Bool = false;
    public var onChoose:Bool = false;
    override function update(elapsed:Float)
	{
		super.update(elapsed);

        var mouse = FlxG.mouse;

		onFocus = mouse.overlaps(this);

		if (onFocus) {
            if (background.alpha < 0.5) background.alpha += EngineSet.FPSfix(0.015);

            if (mouse.justPressed) {
                
            }

            if (mouse.pressed) {
                onChoose = true;
            }

            if (mouse.justReleased) {
            }
        } else {
            if (background.alpha > 0) background.alpha -= EngineSet.FPSfix(0.015);
        }

        if (!mouse.pressed)
        {
            
        }
	}
}