package objects.state.freeplayState;

class SongRect extends FlxSpriteGroup // songs member for freeplay
{
	public var diffRectGroup:FlxSpriteGroup; // 我只是懒的整图层了
	public var diffRectArray:Array<DiffRect> = []; // 获取DiffRect，因为FlxSpriteGroup识别为flxSprite（粑粑haxe我服了）
	public var background:FlxSprite;

	var icon:HealthIcon;
	var songName:FlxText;
	var musican:FlxText;

	public var member:Int;
	public var name:String;
	public var haveAdd:Bool = false;

	public function new(X:Float, Y:Float, songNameS:String, songChar:String, songmusican:String, songColor:Array<Int>)
	{
		super(X, Y);

		diffRectGroup = new FlxSpriteGroup(0, 0);
		add(diffRectGroup);

		var mask:Rect = new Rect(0, 0, 700, 90, 25, 25);

		var extraLoad:Bool = false;
		var filesLoad = 'data/' + songNameS + '/background';
		if (FileSystem.exists(Paths.modFolders(filesLoad + '.png')))
		{
			extraLoad = true;
		}
		else
		{
			filesLoad = 'menuDesat';
			extraLoad = false;
		}

		background = new FlxSprite(0, 0).loadGraphic(Paths.image(filesLoad, null, false, extraLoad));

		var matrix:Matrix = new Matrix();
		var data:Float = mask.width / background.width;
		if (mask.height / background.height > data)
			data = mask.height / background.height;
		matrix.scale(data, data);
		matrix.translate(-(background.width * data - mask.width) / 2, -(background.height * data - mask.height) / 2);

		var bitmap:BitmapData = background.pixels;

		var resizedBitmapData:BitmapData = new BitmapData(Std.int(mask.width), Std.int(mask.height), true, 0x00000000);
		resizedBitmapData.draw(bitmap, matrix);
		resizedBitmapData.copyChannel(mask.pixels, new Rectangle(0, 0, mask.width, mask.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

		var putBitmapData:BitmapData = new BitmapData(Std.int(mask.width), Std.int(mask.height), true, 0x00000000);
		putBitmapData.draw(resizedBitmapData);
		putBitmapData.draw(drawLine(resizedBitmapData.width, resizedBitmapData.height));

		background.pixels = putBitmapData;
		background.antialiasing = ClientPrefs.data.antialiasing;
		if (!extraLoad)
		{
			background.color = FlxColor.fromRGB(songColor[0], songColor[1], songColor[2]);
		}
		add(background);

		icon = new HealthIcon(songChar);
		icon.setGraphicSize(Std.int(background.height * 0.8));
		icon.x += 60 - icon.width / 2;
		icon.y += background.height / 2 - icon.height / 2;
		icon.updateHitbox();
		add(icon);

		songName = new FlxText(100, 5, 0, songNameS, 25);
		songName.borderSize = 0;
		songName.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, 0xA1393939);
		songName.antialiasing = ClientPrefs.data.antialiasing;
		add(songName);

		musican = new FlxText(100, 35, 0, 'Musican: ' + songmusican, 15);
		musican.borderSize = 0;
		musican.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, 0xA1393939);
		musican.antialiasing = ClientPrefs.data.antialiasing;
		add(musican);

		this.name = songNameS;
	}

	function drawLine(width:Float, height:Float):BitmapData
	{
		var shape:Shape = new Shape();
		var lineSize:Int = 3;
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(1, 0xFFFFFF, 1);
		shape.graphics.drawRoundRect(0, 0, width, height, 25, 25);
		shape.graphics.lineStyle(0, 0, 0);
		shape.graphics.drawRoundRect(lineSize, lineSize, width - lineSize * 2, height - lineSize * 2, 20, 20);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	public var posX:Float = -70;
	public var lerpPosX:Float = 0;
	public var posY:Float = 0;
	public var lerpPosY:Float = 0;
	public var onFocus(default, set):Bool = true;
	public var ignoreCheck:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FreeplayState.instance.ignoreCheck)
			return;

		if (onFocus)
		{
			if (Math.abs(lerpPosX - posX) < 0.1)
				lerpPosX = posX;
			else
				lerpPosX = FlxMath.lerp(posX, lerpPosX, Math.exp(-elapsed * 15));
		}
		else
		{
			if (Math.abs(lerpPosX - 0) < 0.1)
			{
				lerpPosX = 0;
				if (haveDiffDis)
					desDiff();
			}
			else
				lerpPosX = FlxMath.lerp(0, lerpPosX, Math.exp(-elapsed * 15));
		}

		if (member > FreeplayState.curSelected)
		{
			if (Math.abs(lerpPosY - posY) < 0.1)
				lerpPosY = posY;
			else
				lerpPosY = FlxMath.lerp(posY, lerpPosY, Math.exp(-elapsed * 15));
		}
		else
		{
			if (Math.abs(lerpPosY - 0) < 0.1)
				lerpPosY = 0;
			else
				lerpPosY = FlxMath.lerp(0, lerpPosY, Math.exp(-elapsed * 15));
		}

		if (FlxG.mouse.justReleased)
		{
			for (num in 0...diffRectArray.length)
			{
				if (FlxG.mouse.overlaps(diffRectArray[num]))
				{
					diffRectArray[num].onFocus = true;
					FreeplayState.curDifficulty = diffRectArray[num].member;
					FreeplayState.instance.updateDiff();
				}
			}
			for (num in 0...diffRectArray.length)
			{
				if (num != FreeplayState.curDifficulty)
					diffRectArray[num].onFocus = false;
			}
		}

		if (ignoreCheck)
		{
			if (alpha - 0 < 0.05)
				alpha = 0;
			else
				alpha = FlxMath.lerp(0, alpha, Math.exp(-elapsed * 15));
		}
		else
		{
			var maxAlpha = onFocus ? 1 : 0.6;
			if (Math.abs(maxAlpha - alpha) < 0.05)
				alpha = maxAlpha;
			else
				alpha = FlxMath.lerp(1, alpha, Math.exp(-elapsed * 15));
		}
	}

	var tween:FlxTween;

	private function set_onFocus(value:Bool):Bool
	{
		if (onFocus == value)
			return onFocus;
		onFocus = value;
		if (onFocus)
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(this, {alpha: 1}, 0.2);
		}
		else
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(this, {alpha: 0.6}, 0.2);
		}
		return value;
	}

	var haveDiffDis:Bool = false;

	public function createDiff(color:FlxColor, charter:Array<String>, imme:Bool = false)
	{
		desDiff();
		haveDiffDis = true;
		for (diff in 0...Difficulty.list.length)
		{
			var chart:String = charter[diff];
			if (charter[diff] == null)
				chart = charter[0];
			var rect = new DiffRect(Difficulty.list[diff], color, chart, this);
			diffRectGroup.add(rect);
			diffRectArray.push(rect);
			rect.member = diff;
			rect.posY = background.height + 10 + diff * 70;
			if (imme)
				rect.lerpPosY = rect.posY;
			if (diff == FreeplayState.curDifficulty)
				rect.onFocus = true;
			else
				rect.onFocus = false;
		}
	}

	public function desDiff()
	{
		haveDiffDis = false;
		if (diffRectArray.length < 1)
			return;
		for (i in 0...diffRectGroup.length)
		{
			diffRectArray.shift();
		}

		for (member in diffRectGroup.members)
		{
			if (member == null)
				return; // 奇葩bug了属于
			diffRectGroup.remove(member);
			member.destroy();
		}
	}
}
