package options;

import states.MainMenuState;
import states.FreeplayState;
import states.FreeplayStatePsych;
import mobile.substates.MobileControlSelectSubState;
import mobile.substates.MobileExtraControl;
import mobile.states.CopyState;
import backend.ClientPrefs;
import language.Language;
import backend.StageData;

class OptionsState extends MusicBeatState
{
	public static var instance:OptionsState;

	var filePath:String = 'menuExtend/OptionsState/';

	var naviArray = [];

	////////////////////////////////////////////////////////////////////////////////////////////

	public var baseColor = 0x302E3A;
	public var mainColor = 0x24232C;


	////////////////////////////////////////////////////////////////////////////////////////////

	var naviBG:RoundRect;
	var naviSpriteGroup:Array<NaviSprite> = [];
	var naviMove:MouseMove;

	var cataGroup:Array<OptionCata> = [];
	var cataMove:MouseMove;

	var downBG:Rect;
	var tipButton:TipButton;
	var specButton:FuncButton;

	var specBG:Rect;
	var searchButton:SearchButton;
	
	override function create()
	{
		persistentUpdate = persistentDraw = true;
		instance = this;

		naviArray = [
			'General',
			'User Interface',
			'GamePlay',
			'Game UI',
			'Skin',
			'Input',
			'Audio',
			'Graphics',
			'Maintenance'	
		];

		var bg = new Rect(0, 0, FlxG.width, FlxG.height, 0, 0, baseColor);
		add(bg);

		naviBG = new RoundRect(0, 0, UIScale.adjust(FlxG.width * 0.2), FlxG.height, 0, LEFT_CENTER,  mainColor);
		add(naviBG);

		for (i in 0...naviArray.length)
		{
			var naviSprite = new NaviSprite(UIScale.adjust(FlxG.width * 0.005), UIScale.adjust(FlxG.height * 0.005) + i * UIScale.adjust(FlxG.height * 0.1), UIScale.adjust(FlxG.width * 0.19), UIScale.adjust(FlxG.height * 0.09), naviArray[i], i, false);
			naviSprite.antialiasing = ClientPrefs.data.antialiasing;
			add(naviSprite);
			naviSpriteGroup.push(naviSprite);
		}
		naviMoveEvent(true);

		naviMove = new MouseMove(naviPosiData, 
								[-1 * naviSpriteGroup.length * 2 * UIScale.adjust(FlxG.height * 0.1), UIScale.adjust(FlxG.height * 0.005)],
								[	
									[UIScale.adjust(FlxG.width * 0.005), 
									UIScale.adjust(FlxG.width * 0.19)], [0, FlxG.height]
								],
								naviMoveEvent);
		add(naviMove);

		/////////////////////////////////////////////////////////////////

		for (i in 0...naviArray.length) {
			addCata(naviArray[i]);
		}

		var moveHeight:Float = 0;
		for (num in cataGroup) moveHeight += num.bg.height;
		cataMove = new MouseMove(cataPosiData, 
								[-1 * moveHeight, 100],
								[ 
									[UIScale.adjust(FlxG.width * 0.2), FlxG.width], 
									[0, FlxG.height - Std.int(UIScale.adjust(FlxG.height * 0.1))]
								],
								cataMoveEvent);
		add(cataMove);
		cataMoveEvent(true);
			
		/////////////////////////////////////////////////////////////

		downBG = new Rect(0, FlxG.height - Std.int(UIScale.adjust(FlxG.height * 0.1)), FlxG.width, Std.int(UIScale.adjust(FlxG.height * 0.1)), 0, 0, mainColor, 0.5);
		add(downBG);

		tipButton = new TipButton(
			UIScale.adjust(FlxG.width * 0.2) + UIScale.adjust(FlxG.height * 0.01), 
			downBG.y + Std.int(UIScale.adjust(FlxG.height * 0.01)),
			FlxG.width - UIScale.adjust(FlxG.width * 0.2) - UIScale.adjust(FlxG.height * 0.01) - Std.int(UIScale.adjust(FlxG.width * 0.15)) - Std.int(UIScale.adjust(FlxG.height * 0.01) * 2), 
			Std.int(UIScale.adjust(FlxG.height * 0.08))
		);
		add(tipButton);

		specButton = new FuncButton(
			FlxG.width - Std.int(UIScale.adjust(FlxG.width * 0.15)) - Std.int(UIScale.adjust(FlxG.height * 0.01)), 
			downBG.y + Std.int(UIScale.adjust(FlxG.height * 0.01)),
			Std.int(UIScale.adjust(FlxG.width * 0.15)), 
			Std.int(UIScale.adjust(FlxG.height * 0.08)),
			specChange
		);
		specButton.alpha = 0.5;
		add(specButton);

		//////////////////////////////////////////////////////////////////////

		specBG = new Rect(UIScale.adjust(FlxG.width * 0.2), 0, FlxG.width - UIScale.adjust(FlxG.width * 0.2), Std.int(UIScale.adjust(FlxG.height * 0.1)), 0, 0, mainColor, 0.5);
		add(specBG);

		searchButton = new SearchButton(specBG.x + specBG.height * 0.2, specBG.height * 0.2, specBG.width * 0.5, specBG.height * 0.6);
		add(searchButton);
		
		

		var backShape = new GeneralBack(0, 720 - 72, UIScale.adjust(FlxG.width * 0.2), UIScale.adjust(FlxG.height * 0.1), Language.get('back', 'ma'), EngineSet.mainColor, backMenu);
		add(backShape);
		

		super.create();
	}

	public var ignoreCheck:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

	}

	override function closeSubState()
	{
		super.closeSubState();
	}

	public function addCata(type:String) {
		var obj:OptionCata = null;

		var outputX:Float = naviBG.width + UIScale.adjust(FlxG.width * (0.8 / 40)); //已被初始化
		var outputWidth:Float = UIScale.adjust(FlxG.width * (0.8 - (0.8 / 40 * 2))); //已被初始化
		var outputY:Float = 100; //等待被初始化
		var outputHeight:Float = 200; //等待被初始化

		switch (type) 
		{
			case 'General':
				obj = new GeneralGroup(outputX, outputY, outputWidth, outputHeight);
			case 'User Interface':
				obj = new InterfaceGroup(outputX, outputY, outputWidth, outputHeight);
			case 'GamePlay':
				obj = new GamePlayGroup(outputX, outputY, outputWidth, outputHeight);
			case 'Game UI':
				obj = new UIGroup(outputX, outputY, outputWidth, outputHeight);
			case 'Skin':
				obj = new SkinGroup(outputX, outputY, outputWidth, outputHeight);
			case 'Input':
				obj = new InputGroup(outputX, outputY, outputWidth, outputHeight);
			case 'Audio':
				obj = new GeneralGroup(outputX, outputY, outputWidth, outputHeight);
			case 'Graphics':
				obj = new GeneralGroup(outputX, outputY, outputWidth, outputHeight);
			case 'Maintenance':
				obj = new GeneralGroup(outputX, outputY, outputWidth, outputHeight);
			default:

		}
		cataGroup.push(obj);
		add(obj);
	}

	static public var cataPosiData:Float = 0;
	public function cataMoveEvent(init:Bool = false){
		if (!init) cataPosiData = cataMove.target;
		for (i in 0...cataGroup.length) {
			if (i == 0) cataGroup[i].y = cataPosiData;
			else cataGroup[i].y = cataGroup[i - 1].y + cataGroup[i - 1].bg.realHeight + UIScale.adjust(FlxG.width * (0.8 / 40));
		}
	}

	static public var naviPosiData:Float = 0;
	public function naviMoveEvent(init:Bool = false){
		if (!init) naviPosiData = naviMove.target;
		for (i in 0...naviSpriteGroup.length) {
			naviSpriteGroup[i].y = naviPosiData + i * UIScale.adjust(FlxG.height * 0.1);
		}
	}

	var specOpen:Bool = false;
	var specTween:Array<FlxTween> = [];
	var specTime = 0.6;
	public function specChange() {
		for (tween in specTween) {
			if (tween != null) tween.cancel();
		}

		
		if (!specOpen) {
			specOpen = true;
			var newPoint = FlxG.width;
			var tween = FlxTween.tween(specBG, {x: newPoint}, specTime, {ease: FlxEase.expoInOut});
			specTween.push(tween);
			var tween = FlxTween.tween(searchButton, {x: newPoint + specBG.height * 0.2}, specTime, {ease: FlxEase.expoInOut});
			specTween.push(tween);
			
		} else {
			specOpen = false;
			var newPoint = UIScale.adjust(FlxG.width * 0.2);
			var tween = FlxTween.tween(specBG, {x: newPoint}, specTime, {ease: FlxEase.expoInOut});
			specTween.push(tween);
			var tween = FlxTween.tween(searchButton, {x: newPoint + specBG.height * 0.2}, specTime, {ease: FlxEase.expoInOut});
			specTween.push(tween);
		}
	}

	public function moveState(type:Int)
	{
		switch (type)
		{
			case 1: // NoteOffsetState
				LoadingState.loadAndSwitchState(new NoteOffsetState());
			case 2: // NotesSubState
				persistentUpdate = false;
				openSubState(new NotesSubState());
			case 3: // ControlsSubState
				persistentUpdate = false;
				openSubState(new ControlsSubState());
			case 4: // MobileControlSelectSubState
				persistentUpdate = false;
				openSubState(new MobileControlSelectSubState());
			case 5: // MobileExtraControl
				persistentUpdate = false;
				openSubState(new MobileExtraControl());
			case 6: // CopyStates
				LoadingState.loadAndSwitchState(new CopyState(true));
		}
	}

	public static var stateType:Int = 0; //检测到底退回到哪个界面
	var backCheck:Bool = false;
	function backMenu()
	{
		if (!backCheck)
		{
			backCheck = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			ClientPrefs.saveSettings();
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
			Main.fpsVar.scaleX = Main.fpsVar.scaleY = ClientPrefs.data.FPSScale;
			Main.fpsVar.change();
			if (Main.watermark != null)
			{
				Main.watermark.scaleX = Main.watermark.scaleY = ClientPrefs.data.WatermarkScale;
				Main.watermark.y += (1 - ClientPrefs.data.WatermarkScale) * Main.watermark.bitmapData.height;
				Main.watermark.visible = ClientPrefs.data.showWatermark;
			}
			switch (stateType)
			{
				case 0:
					MusicBeatState.switchState(new MainMenuState());
				case 1:
						MusicBeatState.switchState(new FreeplayState());
				case 2:
					MusicBeatState.switchState(new PlayState());
					FlxG.mouse.visible = false;
			}
			stateType = 0;
		}
	}
}
