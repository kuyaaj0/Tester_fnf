package shapeEx;

enum OriginType
{
	LEFT_UP;
    LEFT_CENTER;
	LEFT_DOWN;

    CENTER_UP;
    CENTER_CENTER;
    CENTER_DOWN;

    RIGHT_UP;
    RIGHT_CENTER;
    RIGHT_DOWN;
}

class RoundRect extends FlxSpriteGroup
{
	var leftUpRound:FlxSprite;
	var midUpRect:FlxSprite;
	var rightUpRound:FlxSprite;

	var midRect:FlxSprite;

	var leftDownRound:FlxSprite;
	var midDownRect:FlxSprite;
	var rightDownRound:FlxSprite;

	var mainColor:FlxColor;
	var mainWidth:Float;
	var mainHeight:Float;
	var mainRound:Float;
	public var mainX:Float;
	public var mainY:Float;
	var widthEase:String;
	var heightEase:String;

    public var originEase:OriginType;

    public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, round:Float, ease:OriginType = LEFT_UP, color:FlxColor = 0xffffff)
    {
        super(X, Y);
        this.mainColor = color;
        mainX = X;
        mainY = Y;
        originEase = ease;

		leftUpRound = drawRoundRect(0, 0, round, round, round, 1);
		add(leftUpRound);
		midUpRect = drawRect(leftUpRound.width, 0, width - round * 2, round);
		add(midUpRect);
		rightUpRound = drawRoundRect(leftUpRound.width + midUpRect.width, 0, round, round, round, 2);
		add(rightUpRound);

		midRect = drawRect(0, leftUpRound.height, leftUpRound.width + midUpRect.width + rightUpRound.width, height - round * 2);
		add(midRect);

		leftDownRound = drawRoundRect(0, leftUpRound.height + midRect.height, round, round, round, 3);
		add(leftDownRound);
		midDownRect = drawRect(leftDownRound.width, leftUpRound.height + midRect.height, width - round * 2, round);
		add(midDownRect);
		rightDownRound = drawRoundRect(leftDownRound.width + midDownRect.width, leftUpRound.height + midRect.height, round, round, round, 4);
		add(rightDownRound);

		mainWidth = midRect.width;
        mainHeight = leftUpRound.height + midRect.height + leftDownRound.height;
		mainRound = Std.int(round);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	//////////////////////////////////////////////////////

    var widthTweenArray:Array<FlxTween> = [];
    public function changeWidth(data:Float, time:Float = 0.6, ease:String = 'backInOut') {
        widthEase = ease;
        for (i in 0...widthTweenArray.length)
        {
            if (widthTweenArray[i] != null) widthTweenArray[i].cancel();
        }
        widthTweenArray = [];
        
        switch(originEase)
        {
            case LEFT_UP, LEFT_CENTER, LEFT_DOWN:
                var output:Float = calcData(mainWidth, data, mainRound);
                widthTween(midUpRect.scale, output, time, widthEase);
                widthTween(midUpRect, mainX - (mainWidth - data - mainRound * 2) / 2, time, widthEase);
                widthTween(rightUpRound, mainX + data - mainRound, time, widthEase);

                var output:Float = calcData(mainWidth, data, 0);
                widthTween(midRect.scale, output, time, widthEase);
                widthTween(midRect, mainX - (mainWidth - data) / 2, time, widthEase);

                var output:Float = calcData(mainWidth, data, mainRound);
                widthTween(midDownRect.scale, output, time, widthEase);
                widthTween(midDownRect, mainX - (mainWidth - data - mainRound * 2) / 2, time, widthEase);
                widthTween(rightDownRound, mainX + data - mainRound, time, widthEase);


            case CENTER_UP, CENTER_CENTER, CENTER_DOWN:
                widthTween(leftUpRound, mainX - (data - mainWidth) / 2, time, widthEase);  
                var output:Float = calcData(mainWidth, data, mainRound);
                widthTween(midUpRect.scale, output, time, widthEase);             
                widthTween(rightUpRound, mainX + (mainWidth + data) / 2 - mainRound, time, widthEase);

                var output:Float = calcData(mainWidth, data, 0);
                widthTween(midRect.scale, output, time, widthEase);              

                widthTween(leftDownRound, mainX - (data - mainWidth) / 2, time, widthEase);
                var output:Float = calcData(mainWidth, data, mainRound);
                widthTween(midDownRect.scale, output, time, widthEase);
                widthTween(rightDownRound, mainX + (mainWidth + data) / 2 - mainRound, time, widthEase);


            case RIGHT_UP, RIGHT_CENTER, RIGHT_DOWN:
                var output:Float = calcData(mainWidth, data, mainRound);
                widthTween(midUpRect.scale, output, time, widthEase);
                widthTween(midUpRect, mainX + (mainWidth - data) / 2 + mainRound, time, widthEase);
                widthTween(leftUpRound, mainX + mainWidth - data, time, widthEase);

                var output:Float = calcData(mainWidth, data, 0);
                widthTween(midRect.scale, output, time, widthEase);
                widthTween(midRect, mainX + (mainWidth - data) / 2, time, widthEase);

                var output:Float = calcData(mainWidth, data, mainRound);
                widthTween(midDownRect.scale, output, time, widthEase);
                widthTween(midDownRect, mainX + (mainWidth - data) / 2 + mainRound, time, widthEase);
                widthTween(leftDownRound, mainX + mainWidth - data, time, widthEase);
        }
    }

	function widthTween(tag:Dynamic, duration:Float, time:Float, easeType:String)
	{
		var tween = FlxTween.tween(tag, {x: duration}, time, {ease: getTweenEaseByString(easeType)});
		widthTweenArray.push(tween);
	}

	//////////////////////////////////////////////////////////////

	var heightTweenArray:Array<FlxTween> = [];
	public function changeHeight(data:Float, time:Float = 0.6, ease:String = 'backInOut')
	{
		heightEase = ease;
		for (i in 0...heightTweenArray.length)
		{
			if (heightTweenArray[i] != null)
				heightTweenArray[i].cancel();
		}
		heightTweenArray = [];
        switch(originEase)
        {
            case LEFT_UP, CENTER_UP, RIGHT_UP :
                var output:Float = calcData(mainHeight, data, mainRound);
                heightTween(midRect.scale, output, time, heightEase);
                heightTween(midRect, mainY - (mainHeight - data - mainRound * 2) / 2, time, heightEase);
                
                heightTween(leftDownRound, mainY + data - mainRound, time, heightEase);
                heightTween(midDownRect, mainY + data - mainRound, time, heightEase);  
                heightTween(rightDownRound, mainY + data - mainRound, time, heightEase);


            case LEFT_CENTER, CENTER_CENTER, RIGHT_CENTER:
                var output:Float = calcData(mainHeight, data, mainRound);
                heightTween(midRect.scale, output, time, heightEase);
                
                heightTween(leftUpRound, mainY + (mainHeight - data) / 2, time, heightEase);
                heightTween(midUpRect, mainY + (mainHeight - data) / 2, time, heightEase);  
                heightTween(rightUpRound, mainY + (mainHeight - data) / 2, time, heightEase);

                heightTween(leftDownRound, mainY + (mainHeight + data) / 2 - mainRound, time, heightEase);
                heightTween(midDownRect, mainY + (mainHeight + data) / 2 - mainRound, time, heightEase);  
                heightTween(rightDownRound, mainY + (mainHeight + data) / 2 - mainRound, time, heightEase);


            case LEFT_DOWN, CENTER_DOWN, RIGHT_DOWN:
                var output:Float = calcData(mainHeight, data, mainRound);
                heightTween(midRect.scale, output, time, heightEase);
                heightTween(midRect, mainY + (mainHeight - data) / 2 + mainRound, time, heightEase);
                
                heightTween(leftUpRound, mainY + height - data, time, heightEase);
                heightTween(midUpRect, mainY + height - data, time, heightEase);  
                heightTween(rightUpRound, mainY + height - data, time, heightEase);
        }
    }

	function heightTween(tag:Dynamic, duration:Float, time:Float, easeType:String)
	{
		var tween = FlxTween.tween(tag, {y: duration}, time, {ease: getTweenEaseByString(easeType)});
		heightTweenArray.push(tween);
	}

	//////////////////////////////////////////////////////////

	function calcData(init:Float, target:Float, assist:Float):Float
	{
		return (target - assist * 2) / (init - assist * 2);
	}

	function drawRoundRect(x:Float, y:Float, width:Float = 0, height:Float = 0, round:Float = 0, type:Int):FlxSprite
	{
		var dataArray:Array<Float> = [0, 0, 0, 0];
		dataArray[type - 1] = round; // 选择哪个角，（左上，右上，左下，右下）

		var shape:Shape = new Shape();
		shape.graphics.beginFill(mainColor);
		shape.graphics.drawRoundRectComplex(0, 0, width, height, dataArray[0], dataArray[1], dataArray[2], dataArray[3]);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
		bitmap.draw(shape);

		var sprite:FlxSprite = new FlxSprite(x, y);
		sprite.loadGraphic(bitmap);
		sprite.antialiasing = ClientPrefs.data.antialiasing;
		sprite.origin.set(0, 0);
		sprite.updateHitbox();
		return sprite;
	}

	function drawRect(x:Float, y:Float, width:Float = 0, height:Float = 0):FlxSprite
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(mainColor);
		shape.graphics.drawRect(0, 0, width, height);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
		bitmap.draw(shape);

		var sprite:FlxSprite = new FlxSprite(x, y);
		sprite.loadGraphic(bitmap);
		return sprite;
	}

	public static function getTweenEaseByString(?ease:String = '')
	{
		switch (ease.toLowerCase().trim())
		{
			case 'backin':
				return FlxEase.backIn;
			case 'backinout':
				return FlxEase.backInOut;
			case 'backout':
				return FlxEase.backOut;
			case 'bouncein':
				return FlxEase.bounceIn;
			case 'bounceinout':
				return FlxEase.bounceInOut;
			case 'bounceout':
				return FlxEase.bounceOut;
			case 'circin':
				return FlxEase.circIn;
			case 'circinout':
				return FlxEase.circInOut;
			case 'circout':
				return FlxEase.circOut;
			case 'cubein':
				return FlxEase.cubeIn;
			case 'cubeinout':
				return FlxEase.cubeInOut;
			case 'cubeout':
				return FlxEase.cubeOut;
			case 'elasticin':
				return FlxEase.elasticIn;
			case 'elasticinout':
				return FlxEase.elasticInOut;
			case 'elasticout':
				return FlxEase.elasticOut;
			case 'expoin':
				return FlxEase.expoIn;
			case 'expoinout':
				return FlxEase.expoInOut;
			case 'expoout':
				return FlxEase.expoOut;
			case 'quadin':
				return FlxEase.quadIn;
			case 'quadinout':
				return FlxEase.quadInOut;
			case 'quadout':
				return FlxEase.quadOut;
			case 'quartin':
				return FlxEase.quartIn;
			case 'quartinout':
				return FlxEase.quartInOut;
			case 'quartout':
				return FlxEase.quartOut;
			case 'quintin':
				return FlxEase.quintIn;
			case 'quintinout':
				return FlxEase.quintInOut;
			case 'quintout':
				return FlxEase.quintOut;
			case 'sinein':
				return FlxEase.sineIn;
			case 'sineinout':
				return FlxEase.sineInOut;
			case 'sineout':
				return FlxEase.sineOut;
			case 'smoothstepin':
				return FlxEase.smoothStepIn;
			case 'smoothstepinout':
				return FlxEase.smoothStepInOut;
			case 'smoothstepout':
				return FlxEase.smoothStepInOut;
			case 'smootherstepin':
				return FlxEase.smootherStepIn;
			case 'smootherstepinout':
				return FlxEase.smootherStepInOut;
			case 'smootherstepout':
				return FlxEase.smootherStepOut;
		}
		return FlxEase.linear;
	}
}
