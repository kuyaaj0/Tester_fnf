package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioDisplayExpand extends FlxSpriteGroup
{
    var analyzer:SpectralAnalyzer;

	public var snd:Array<FlxSound> = [];
	public var sndAnalyzer:Array<SpectralAnalyzer> =[];

	var _height:Int;
	var line:Int;

    public function new(snd:Array<FlxSound> = [], X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, symmetry:Bool = false)
	{
	    super(X, Y);

		this.snd = snd;
		this.line = line;
		this.symmetry = symmetry;

		for (i in 0...line)
		{
			var newLine = new FlxSprite().makeGraphic(Std.int(Width / line - gap), 1, Color);
			newLine.x = (Width / line) * i;
			add(newLine);
		}

		_height = Height;
		@:privateAccess
		if(snd.length > 0){
		    for (sound in snd){
		        if (snd != null)
        		{
        			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
        			analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
        			sndAnalyzer.push(analyzer);
        		}
		    }
		}
	}
	
	public var stopUpdate:Bool = false;

	var saveTime:Float = 0;
	var getValues:Array<funkin.vis.dsp.Bar>;

	override function update(elapsed:Float)
	{
		if (stopUpdate)
			return;

		if (saveTime < ClientPrefs.data.audioDisplayUpdate)
		{
			saveTime += (elapsed * 1000);

			updateLine(elapsed);
			return;
		}
		else
		{
			saveTime = 0;
		}
		
		var bruh:Array<funkin.vis.dsp.Bar> =[];
		
		for (i in 0...(sndAnalyzer[0].length - 1)){
		    var sum = 0.0;
		    for (group in sndAnalyzer){
		       sum += group.getLevels()[i];
		    }
		    bruh.push(sum / sndAnalyzer[0].length);
		}

		getValues = bruh;
		
		updateLine(elapsed);

		super.update(elapsed);
	}

	function addAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		if (snd != null && analyzer == null)
		{
			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
			analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
		}
	}

	var animFrame:Int = 0;

	function updateLine(elapsed:Float)
	{
		if (getValues == null)
			return;

		for (i in 0...members.length)
		{
			if (i >= members.length / 2 && symmetry)
			{
				animFrame = Math.round(getValues[members.length - 1 - i].value * _height);
			}
			else
			{
				animFrame = Math.round(getValues[i].value * _height);
			}

			animFrame = Math.round(animFrame * FlxG.sound.volume);

			members[i].scale.y = FlxMath.lerp(animFrame, members[i].scale.y, Math.exp(-elapsed * 16));
			if (members[i].scale.y < _height / 40)
				members[i].scale.y = _height / 40;
			
			members[i].y = this.y - members[i].scale.y / 2;
		}
	}

	public function changeAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		analyzer.changeSnd(snd._channel.__audioSource);

		stopUpdate = false;
	}

	public function clearUpdate()
	{
		for (i in 0...members.length)
		{
			members[i].scale.y = _height / 40;
			members[i].y = this.y - members[i].scale.y / 2;
		}
	}
}

class AudioCircleDisplayExpand extends FlxSpriteGroup
{
	var analyzer:SpectralAnalyzer;

	public var snd:FlxSound;

	var _height:Int;
	public var line:Int;

	public var Radius:Float = 0;
	
	var symmetry:Bool = true;
	var Number:Int = 1;
	
	public var snd:Array<FlxSound> = [];
	public var sndAnalyzer:Array<SpectralAnalyzer> =[];

	public function new(snd:Array<FlxSound> = [], X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, symmetry:Bool = true, Number:Int = 3)
	{
		super(X, Y);

		this.snd = snd;
		this.line = line;
		this.Radius = Radius;
		this.symmetry = symmetry;
		if (Number < 1)
			Number = 1;

		this.Number = Number;

		for (i in 0...line * Number)
		{
			var newLine = new FlxSprite().makeGraphic(gap, 1, Color);
			var angle = (360 / (line * Number)) * i;
			newLine.angle = angle;
			newLine.origin.y = 1;
			var correctedAngle = angle - 90;
			var radians = correctedAngle * Math.PI / 180;
			var moveX = Math.cos(radians) * Radius;
			var moveY = Math.sin(radians) * Radius;
			newLine.x += moveX;
			newLine.y += moveY;
			add(newLine);
		}
		_height = Height;
		@:privateAccess
		
		if(snd.length > 0){
		    for (sound in snd){
		        if (snd != null)
        		{
        			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
        			analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
        			sndAnalyzer.push(analyzer);
        		}
		    }
		}
	}

	public var stopUpdate:Bool = false;

	var saveTime:Float = 0;
	var getValues:Array<funkin.vis.dsp.Bar>;

	override function update(elapsed:Float)
	{
		if (stopUpdate)
			return;

		if (saveTime < ClientPrefs.data.audioDisplayUpdate)
		{
			saveTime += (elapsed * 1000);

			updateLine(elapsed);
			return;
		}
		else
		{
			saveTime = 0;
		}

		var bruh:Array<funkin.vis.dsp.Bar> =[];
		
		for (i in 0...(sndAnalyzer[0].length - 1)){
		    var sum = 0.0;
		    for (group in sndAnalyzer){
		       sum += group.getLevels()[i];
		    }
		    bruh.push(sum / sndAnalyzer[0].length)
		}

		getValues = bruh;
		updateLine(elapsed);

		super.update(elapsed);
	}

	function addAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		if (snd != null && analyzer == null)
		{
			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
			analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
		}
	}

	var animFrame:Int = 0;

	function updateLine(elapsed:Float)
	{
		if (getValues == null)
			return;

		for (i in 0...line)
		{
			if (i >= line / 2 && symmetry)
			{
				animFrame = Math.round(getValues[line - i].value * _height);
			}
			else
			{
				animFrame = Math.round(getValues[i].value * _height);
			}

			animFrame = Math.round(animFrame * FlxG.sound.volume);

			for (i1 in 0...Number)
			{
				var nowLine:Int = i + (i1 * line);
				members[nowLine].scale.y = FlxMath.lerp(animFrame, members[nowLine].scale.y, Math.exp(-elapsed * 16));
				if (members[nowLine].scale.y < _height / 40)
					members[nowLine].scale.y = _height / 40;
			}
		}
	}

	public function changeAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		analyzer.changeSnd(snd._channel.__audioSource);

		stopUpdate = false;
	}

	public function clearUpdate()
	{
		for (i in 0...members.length)
		{
			members[i].scale.y = _height / 40;
			members[i].y = this.y - members[i].scale.y / 2;
		}
	}
}