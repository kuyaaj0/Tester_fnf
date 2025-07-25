package objects.state.freeplayState;

class MusicLine extends FlxSpriteGroup
{
	var blackLine:FlxSprite;
	var whiteLine:FlxSprite;

	var timeDis:FlxText;
	var timeMaxDis:FlxText;

	public var playRate:FlxText;

	var timeAddRect:MusicRect;
	var timeReduceRect:MusicRect;

	var rateAddRect:MusicRect;
	var rateReduceRect:MusicRect;

	public function new(X:Float, Y:Float, width:Float = 0)
	{
		super(X, Y);

		blackLine = new FlxSprite().makeGraphic(Std.int(width), 5);
		blackLine.color = 0xffffff;
		blackLine.alpha = 0.5;
		add(blackLine);

		whiteLine = new FlxSprite().makeGraphic(1, 5);
		add(whiteLine);

		timeDis = new FlxText(0, 20, 0, '0', 18);
		timeDis.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		timeDis.alignment = LEFT;
		timeDis.antialiasing = ClientPrefs.data.antialiasing;
		add(timeDis);

		timeAddRect = new MusicRect(410, 23, '+1S');
		add(timeAddRect);
		timeReduceRect = new MusicRect(70, 23, '-1S');
		add(timeReduceRect);

		rateAddRect = new MusicRect(320, 23, '+5%');
		add(rateAddRect);
		rateReduceRect = new MusicRect(160, 23, '-5%');
		add(rateReduceRect);

		timeMaxDis = new FlxText(0, 20, 0, '0', 18);
		timeMaxDis.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		timeMaxDis.alignment = RIGHT;
		timeMaxDis.antialiasing = ClientPrefs.data.antialiasing;
		add(timeMaxDis);

		playRate = new FlxText(0, 20, 0, '1', 18);
		playRate.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		timeDis.alignment = CENTER;
		playRate.antialiasing = ClientPrefs.data.antialiasing;
		add(playRate);
		playRate.x += width / 2 - playRate.width / 2;

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			timeMaxDis.text = Std.string(FlxStringUtil.formatTime(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2)));
			timeMaxDis.x = X + width - timeMaxDis.width;

			timeDis.text = Std.string(FlxStringUtil.formatTime(FlxMath.roundDecimal(FlxG.sound.music.time / 1000, 2)));

			playRate.text = Std.string(FlxG.sound.music.pitch);
			playRate.x = X + width / 2 - playRate.width / 2;
		}, 0);
	}

	var holdTime:Float = 0;
	var canHold:Bool = false;

	override function update(e:Float)
	{
		super.update(e);

		whiteLine.scale.x = FlxG.sound.music.time / FlxG.sound.music.length * blackLine.width;

		whiteLine.x = blackLine.x + whiteLine.scale.x / 2;

		if (this.visible == false)
			return; // 奇葩bug

		if (FreeplayState.instance.ignoreCheck)
			return;

		if (FlxG.mouse.justReleased)
		{
			holdTime = 0;
			canHold = false;
		}

		if (FlxG.mouse.overlaps(timeAddRect) || FlxG.mouse.overlaps(timeReduceRect) || FlxG.mouse.overlaps(rateAddRect) || FlxG.mouse.overlaps(rateReduceRect))
		{
			if (FlxG.mouse.justPressed)
			{
				canHold = true;
				if (FlxG.mouse.overlaps(timeAddRect))
					FreeplayState.instance.updateMusicTime(1, false);
				else if (FlxG.mouse.overlaps(timeReduceRect))
					FreeplayState.instance.updateMusicTime(-1, false);
				else if (FlxG.mouse.overlaps(rateAddRect))
					FreeplayState.instance.updateMusicRate(1);
				else if (FlxG.mouse.overlaps(rateReduceRect))
					FreeplayState.instance.updateMusicRate(-1);
			}

			if (FlxG.mouse.pressed)
			{
				holdTime += e;
			}

			if (holdTime > 0.5 && canHold)
			{
				holdTime -= 0.1;
				if (FlxG.mouse.overlaps(timeAddRect))
					FreeplayState.instance.updateMusicTime(1, true);
				else if (FlxG.mouse.overlaps(timeReduceRect))
					FreeplayState.instance.updateMusicTime(-1, true);
				else if (FlxG.mouse.overlaps(rateAddRect))
					FreeplayState.instance.updateMusicRate(1);
				else if (FlxG.mouse.overlaps(rateReduceRect))
					FreeplayState.instance.updateMusicRate(-1);
			}
		}
	}
}
