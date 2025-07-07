package objects.state.optionState;

import openfl.filters.GlowFilter;
import flixel.graphics.frames.FlxFilterFrames;

enum OptionType
{
	BOOL;

	INT;
	FLOAT;
	PERCENT;

	STRING;

	STATE;
	SUBSTATE;

	TITLE;
	TEXT;
	
	//特殊化处理
	NOTE;
	SPLASH;
}

class Option extends FlxSpriteGroup
{
	public var onChange:Void->Void = null;
	public var type:OptionType = BOOL;

	public var saveHeight:Float = 0;
	var inter:Float = 10; //设置与设置间的y轴间隔

	public var variable:String = null; // Variable from ClientPrefs.hx
	public var defaultValue:Dynamic = null; //获取出来的数值
	public var description:String = ''; //简短的描述
	public var tips:String; //真正的解释

	//STRING
	public var strGroup:Array<String> = null;
	public var curOption:Int = 0;

	//INT FLOAT PERCENT;
	public var minValue:Float = 0;
	public var maxValue:Float = 0;
	public var decimals:Int = 0; //数据需要精确到小数点几位
	public var exatraDisplay:String = '';

	public var follow:OptionCata;

	/////////////////////////////////////////////

	public function new(follow:OptionCata, variable:String = '', type:OptionType = BOOL, description:String = '', tips:String = '', ?data:Dynamic)
	{
		super();

		this.follow = follow;

		this.variable = variable;
		this.type = type;
		this.description = description;
		this.tips = tips;

		///////////////////////////////////////////////////////////////////////////////////////////////////

		if (this.type != STATE && variable != '')
			this.defaultValue = Reflect.getProperty(ClientPrefs.data, variable);

		switch (type)
		{
			case BOOL:
				if (defaultValue == null)
					defaultValue = false;
			case INT, FLOAT, PERCENT:
				if (defaultValue == null)
					defaultValue = 0;
			case STRING:
				if (data.length > 0)
					defaultValue = data[0];
				if (defaultValue == null)
					defaultValue = '';
			default:
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////

		switch (type)
		{
			case BOOL:
				//bool没有特殊需要加的

			case INT:
				this.minValue = data[0];
				this.maxValue = data[1];
				if (data[2] != null) this.exatraDisplay = data[2];

			case FLOAT:
				this.minValue = data[0];
				this.maxValue = data[1];
				this.decimals = data[2];
				if (data[3] != null) this.exatraDisplay = data[3];

			case PERCENT:
				this.decimals = data[0];
				this.decimals = data[1];
				if (data[2] != null) this.exatraDisplay = data[2];
				
			case STRING:
				this.strGroup = data;
			default:
		}

		switch (type)
		{
			case STRING:
				var num:Int = strGroup.indexOf(getValue());
				if (num > -1)
					curOption = num; //定位当前选择
			default:
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////

		switch (type)
		{
			case BOOL:
				addBool();
			case INT, FLOAT, PERCENT:
				addNum();
			case STRING:
				addString();
			case TEXT:
				addTip();
			case TITLE:
				addTitle();
			case STATE:
				addState();
			default:
		}
	}

	var overlopCheck:Float;
	var alreadyShow:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		followX = follow.mainX;
		followY = follow.mainY;

		var mouse = FlxG.mouse;

       
        if (mouse.overlaps(this)) {
			overlopCheck += elapsed;
		} else {
			overlopCheck = 0;
			alreadyShow = false;
		}

		if (overlopCheck >= 0.2 && !alreadyShow) {
			OptionsState.instance.changeTip(tips);
			alreadyShow = true;
		}
	}

	////////////////////////////////////////////////////////

	var boolButton:BoolButton;
	function addBool()
	{
		baseBGAdd();

		var clacHeight = baseBG.realHeight - (baseTar.height + baseLine.height) - baseBG.mainRound * 2;
		var clacWidth = baseBG.realWidth * 0.4 - baseBG.mainRound;
		boolButton = new BoolButton(baseBG.realWidth * 0.6, baseTar.height + baseLine.height + baseBG.mainRound, clacWidth, clacHeight, this);
		add(boolButton);
	}

	var numButton:NumButton;
	function addNum()
	{
		baseBGAdd(true);

		var clacHeight = baseBG.realHeight - (baseTar.height + baseLine.height) - baseBG.mainRound * 2;
		var clacWidth = baseBG.realWidth * 0.5 - baseBG.mainRound * 2;
		numButton = new NumButton(baseBG.realWidth * 0.5 + baseBG.mainRound, baseTar.height + baseLine.height + baseBG.mainRound, clacWidth, clacHeight, this);
		add(numButton);
	}

	function addString()
	{
		baseBGAdd();
	}

	var tipsLight:Rect;
	var tipsText:FlxText;
	function addTip()
	{
		tipsText = new FlxText(0, 0, 0, description, Std.int(follow.width / 10));
		tipsText.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(follow.width / 45), 0xffffff, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        tipsText.antialiasing = ClientPrefs.data.antialiasing;
		tipsText.borderStyle = NONE;
		tipsText.active = false;
		add(tipsText);

		var data = tipsText.height * 0.5;
		tipsLight = new Rect(0, 0,  data / 6, data, data / 4, data / 4, EngineSet.mainColor);
		add(tipsLight);

		tipsLight.y += (tipsText.height - tipsLight.height) / 2;

		tipsText.x += tipsLight.width * 2;

		var glowFilter:GlowFilter = new GlowFilter(EngineSet.mainColor, 0.75, tipsLight.width * 2, tipsLight.width * 2);
		var filterFrames = FlxFilterFrames.fromFrames(tipsLight.frames, Std.int(tipsLight.width * 10), Std.int(tipsLight.height), [glowFilter]);
		filterFrames.applyToSprite(tipsLight, false, true);

		saveHeight = tipsText.height + inter;
	}

	var titleLight:Rect;
	var title:FlxText;
	var titLine:Rect;
	function addTitle()
	{
		title = new FlxText(0, 0, 0, description, Std.int(follow.width / 10));
		title.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(follow.width / 30), 0xffffff, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        title.antialiasing = ClientPrefs.data.antialiasing;
		title.borderStyle = NONE;
		title.x += follow.bg.mainRound;
		title.active = false;
		add(title);

		var data = title.height * 0.5;
		titleLight = new Rect(follow.bg.mainRound, 0,  data / 6, data, data / 4, data / 4, EngineSet.mainColor);
		add(titleLight);

		titleLight.x -= titleLight.width / 2;
		titleLight.y += (title.height - titleLight.height) / 2;

		title.x += titleLight.width * 2;

		var glowFilter:GlowFilter = new GlowFilter(EngineSet.mainColor, 0.75, titleLight.width * 2, titleLight.width * 2);
		var filterFrames = FlxFilterFrames.fromFrames(titleLight.frames, Std.int(titleLight.width * 10), Std.int(titleLight.height), [glowFilter]);
		filterFrames.applyToSprite(titleLight, false, true);

		titLine = new Rect(0, title.height, follow.bg.mainWidth, follow.width / 400, 0, 0, 0xFFFFFF, 0.3);
		titLine.active = false;
		add(titLine);

		saveHeight = title.height + titLine.height + inter;
	}

	function addState()
	{
		
	}

	public var baseBG:RoundRect;
	var baseTar:FlxText;
	var baseLine:Rect;
	var baseDesc:FlxText;
	function baseBGAdd(big:Bool = false)
	{
		var mult:Float = 1; //一些数据需要保持一致
		if (big) mult = 2;

		var calcWidth:Float = 0;
		if (!big) calcWidth = follow.bg.realWidth * ((1 - (1 / 2 / 50 * 3)) / 2);
		else calcWidth = follow.bg.realWidth * (1 - (1 / 2 / 50 * 2));

		var calcHeight:Float = 0;
		if (!big) calcHeight = calcWidth * 0.16;
		else calcHeight = calcWidth * 0.1;

		baseBG = new RoundRect(0, 0, calcWidth, calcHeight, calcWidth / 75 / mult, LEFT_UP, 0xffffff);
		baseBG.alpha = 0.1;
		baseBG.mainX = followX + innerX;
		baseBG.mainY = followY + innerY;
		add(baseBG);

		baseTar = new FlxText(0, 0, 0, 'Target: ' + variable, Std.int(follow.width / 10));
		baseTar.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(baseBG.realWidth / 30 / mult), 0xffffff, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        baseTar.antialiasing = ClientPrefs.data.antialiasing;
		baseTar.borderStyle = NONE;
		baseTar.x += baseBG.mainRound;
		baseTar.alpha = 0.3;
		baseTar.blend = ADD;
		baseTar.active = false;
		add(baseTar);

		baseLine = new Rect(0, baseTar.height, baseBG.realWidth, baseBG.realWidth / 400 / mult, 0, 0, 0xFFFFFF, 0.3);
		baseLine.active = false;
		add(baseLine);

		var calcWidth = baseBG.realWidth * 0.58;
		if (big) calcWidth = baseBG.realWidth * 0.5;
		baseDesc = new FlxText(0, baseTar.height + baseLine.height, calcWidth, description, Std.int(follow.width / 10));
		baseDesc.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), Std.int(baseBG.realWidth / 25 / mult), 0xffffff, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFFFFFFF);
        baseDesc.antialiasing = ClientPrefs.data.antialiasing;
		baseDesc.borderStyle = NONE;
		baseDesc.active = false;
		
		baseDesc.y -= (baseDesc.height - baseDesc.textField.textHeight) / 2;

		var clacHeight = baseDesc.textField.textHeight / (baseBG.realHeight - baseTar.height + baseLine.height);
		if (clacHeight > 1) baseDesc.size = Std.int(baseDesc.size / clacHeight / 1.05); //原理来讲不应该超过这个高度的，这个玩意纯粹的防止蠢人

		baseDesc.x += baseBG.mainRound;
		baseDesc.y += (baseBG.realHeight - baseTar.height + baseLine.height - baseDesc.textField.textHeight) / 2;
		add(baseDesc);

		saveHeight = baseBG.realHeight + inter;
	}

	///////////////////////////////////////////////

	public function change()
	{
		if (onChange != null)
			onChange();
	}

	dynamic public function getValue():Dynamic
	{
		var value = Reflect.getProperty(ClientPrefs.data, variable);
		return value;
	}

	dynamic public function setValue(value:Dynamic)
	{
		return Reflect.setProperty(ClientPrefs.data, variable, value);
	}

	public function resetData()
	{
		if (variable == '' || type == STATE)
			return;
		Reflect.setProperty(ClientPrefs.data, variable, Reflect.getProperty(ClientPrefs.defaultData, variable));
		defaultValue = Reflect.getProperty(ClientPrefs.defaultData, variable);
		switch (type)
		{
			
			default:
		}
	}

	////////////////////////////////////////////////

	public var followX:Float = 0;  //optioncata位置
	public var innerX:Float = 0; //optioncata内部位置
	public var xOff:Float = 0;
	var xTween:FlxTween = null;
	public function changeX(data:Float, isMain:Bool = true, time:Float = 0.6) {
		var output = isMain ? followX : xOff;
		output += data;

		if (xTween != null) xTween.cancel();
		var tween = FlxTween.tween(this, {x: followX + innerX + xOff}, time, {ease: FlxEase.expoInOut});
		xTween = (tween);
	}

	public function initX(data:Float, innerData:Float) {
		followX = data;
		innerX = innerData;
		if (type == TITLE) return;
		this.x = followX + innerX;
	}

	public var followY:Float = 0;  //optioncata在主体的位置
	public var innerY:Float = 0; //optioncata内部位置
	public var yOff:Float = 0;
	var yTween:FlxTween = null;
	public function changeY(data:Float, isMain:Bool = true, time:Float = 0.6) {
		var output = isMain ? followY : xOff;
		output += data;

		if (yTween != null) yTween.cancel();
		var tween = FlxTween.tween(this, {y: followY + innerY + yOff}, time, {ease: FlxEase.expoInOut});
		yTween = (tween);
	}

	public function initY(data:Float, innerData:Float) {
		followY = data;
		innerY = innerData;
		this.y = followY + innerY;
	}
}
