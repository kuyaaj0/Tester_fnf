package objects.state.optionState.backend;

import openfl.display.Shape;
import openfl.display.BitmapData;

class NumButton extends FlxSpriteGroup {

    var follow:Option;

    var innerX:Float; //该摁键在option的x
    var innerY:Float; //该摁键在option的y

    var deleteButton:FlxSprite;
    var addButton:FlxSprite;

    var moveBG:Rect;
    var moveDis:Rect;
    var rod:Rect;
	
    var max:Float;
    var min:Float;

    public function new(X:Float, Y:Float, width:Float, height:Float, follow:Option) {
        super(X, Y);

        this.follow = follow;
        this.min = follow.minValue;
        this.max = follow.maxValue;
        innerX = X;
        innerY = Y;

        deleteButton = new FlxSprite();
        deleteButton.loadGraphic(createButton(height * 0.75, 0xFF6363, '-'));
        deleteButton.antialiasing = ClientPrefs.data.antialiasing;
        deleteButton.y += (height - deleteButton.height) / 2;
        add(deleteButton);

        addButton = new FlxSprite();
        addButton.loadGraphic(createButton(height * 0.75, 0x63FF75, '+'));
        addButton.antialiasing = ClientPrefs.data.antialiasing;
        addButton.x += width - addButton.width;
        addButton.y += (height - addButton.height) / 2;
        add(addButton);

        moveBG = new Rect(deleteButton.width * 1.2, 
                         0, 
                         width - (deleteButton.width + addButton.width) * 1.2, 
                         deleteButton.height * 0.5, 
                         deleteButton.height * 0.5 * 0.5, 
                         deleteButton.height * 0.5 * 0.5,
                         0x000000,
                         0.4
                         );
        moveBG.y += (height - moveBG.height) / 2;
        add(moveBG);

        moveDis = new Rect(deleteButton.width * 1.2, 
                         0, 
                         width - (deleteButton.width + addButton.width) * 1.2, 
                         deleteButton.height * 0.5, 
                         deleteButton.height * 0.5 * 0.5, 
                         deleteButton.height * 0.5 * 0.5,
                         EngineSet.mainColor,
                         1.0
                         );
        moveDis.y += (height - moveDis.height) / 2;
        add(moveDis);

        rod = new Rect(deleteButton.width * 1.2, 
                        0, 
                        height / 10, 
                        deleteButton.height, 
                        height / 10, 
                        height / 10, 
                        0xffffff,
                        1.0
                        );
        rod.y += (height - rod.height) / 2;
        add(rod);

        initData();
    }

    function initData() {
        var percent = (follow.defaultValue - min) / (max - min);
        rectUpdate(percent);
    }

    public var onFocus:Bool = false;
    public var focusAdd:Bool = false;
    var addHoldTime:Float = 0;
    public var focusDelete:Bool = false;
    var deleteHoldTime:Float = 0;
    override function update(elapsed:Float)
	{
		super.update(elapsed);

        var mouse = FlxG.mouse;

		if (mouse.y > rod.y && mouse.y < (rod.y + rod.height) && mouse.x > (rod.x - rod.width * 2) && mouse.x < (rod.x + rod.width * 2) && mouse.justPressed)
		{
			onFocus = true;
            lastMouseX = mouse.x;
		}

		if (onFocus && mouse.pressed)
			onHold();

        if (mouse.justReleased)
		{
			onFocus = false;
		}

		if (mouse.overlaps(addButton))
		{
			if (mouse.justPressed) {  
			    changeData(true);
                focusAdd = true;
            }

            if (mouse.pressed && focusAdd) {  
			    if (addHoldTime > 0.3) {
                    addHoldTime -= 0.01;
                    changeData(true);
                } else {
                    addHoldTime += elapsed;
                }

                if (addButton.scale.x > 0.8)
                    addButton.scale.x = addButton.scale.y -= EngineSet.FPSfix(0.01);
            } else {
                addHoldTime = 0;
                focusAdd = false;
            }
		} else {
            addHoldTime = 0;
            focusAdd = false;
        }

        if (mouse.overlaps(deleteButton))
        {
			if (mouse.justPressed) {  
			    changeData(false);
                focusDelete = true;
            }

            if (mouse.pressed && focusDelete) {  
			    if (deleteHoldTime > 0.3) {
                    deleteHoldTime -= 0.01;
                    changeData(false);
                } else {
                    deleteHoldTime += elapsed;
                }

                if (deleteButton.scale.x > 0.8)
                    deleteButton.scale.x = deleteButton.scale.y -= EngineSet.FPSfix(0.01);
            } else {
                deleteHoldTime = 0;
                focusDelete = false;
            }
		} else {
            deleteHoldTime = 0;
            focusDelete = false;
        }

        if (!mouse.pressed)
        {
            if (addButton.scale.x < 1)
                addButton.scale.x = addButton.scale.y += EngineSet.FPSfix(0.01);
            if (deleteButton.scale.x < 1)
                deleteButton.scale.x = deleteButton.scale.y += EngineSet.FPSfix(0.01);
        }
	}

    var lastMouseX = 0;
    function onHold()
	{
        var deltaX:Float = FlxG.mouse.x - lastMouseX;
        lastMouseX = FlxG.mouse.x;
        if (deltaX == 0) return;

		rod.x += deltaX;

        var startX = follow.followX + follow.innerX + innerX + deleteButton.width * 1.2;
		if (rod.x < startX)
			rod.x = startX;
		if (rod.x + rod.width > startX + moveBG.width)
			rod.x = startX + moveBG.width - rod.width;

		var percent = (rod.x - moveBG.x) / (moveBG.width - rod.width);
        var outputData = FlxMath.roundDecimal(min + (max - min) * percent, follow.decimals);
        rectUpdate(percent, outputData);
	}

    function changeData(isAdd:Bool)
	{
		var outputData:Float = follow.getValue();
		if (isAdd)
			outputData += Math.pow(0.1, follow.decimals);
		else
			outputData -= Math.pow(0.1, follow.decimals);

		if (outputData < min)
			outputData = min;
		if (outputData > max)
			outputData = max;

		outputData = FlxMath.roundDecimal(outputData, follow.decimals);
		var percent = (outputData - min) / (max - min);

		rectUpdate(percent, outputData);
	}

    function rectUpdate(percent:Float, ?outputData)
	{
		moveDis._frame.frame.width = moveDis.width * percent;
		if (moveDis._frame.frame.width < 1)
			moveDis._frame.frame.width = 1;
		rod.x = follow.followX + follow.innerX + innerX + deleteButton.width * 1.2 + (moveBG.width - rod.width) * percent;

        if (outputData == null) return;
        follow.setValue(outputData);
		//follow.valueText.text = follow.getValue() + follow.display;
		if (follow.type == PERCENT)
			//follow.valueText.text = Std.string(follow.getValue() * 100) + '%';
		follow.change();
        follow.updateNumText();
	}
    
    private function createButton(size:Float, color:Int, symbol:String) {
        // 绘制按钮背景
        var button = new Shape();
        button.graphics.beginFill(color);
        button.graphics.drawRoundRect(0, 0, size, size, size / 4, size / 4);
        button.graphics.endFill();
        
        // 绘制符号
        button.graphics.lineStyle(3, 0xffffff); // 白色线条，3像素粗
        
        if (symbol == "+") {
            // 绘制加号：横线
            button.graphics.moveTo(size * 0.2, size * 0.5);
            button.graphics.lineTo(size * 0.8, size * 0.5);
            // 绘制加号：竖线
            button.graphics.moveTo(size * 0.5, size * 0.2);
            button.graphics.lineTo(size * 0.5, size * 0.8);
        } else if (symbol == "-") {
            // 绘制减号：横线
            button.graphics.moveTo(size * 0.2, size * 0.5);
            button.graphics.lineTo(size * 0.8, size * 0.5);
        }
        var bitmap:BitmapData = new BitmapData(Std.int(size), Std.int(size), true, 0);
		bitmap.draw(button);
		return bitmap;
    }
}