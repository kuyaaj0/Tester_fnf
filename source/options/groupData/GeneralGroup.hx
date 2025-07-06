package options.groupData;

import shaders.ColorblindFilter;

class GeneralGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, TITLE, Language.get('General', 'op'), Language.get('General', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'framerate', INT, Language.get('framerate', 'op'), Language.get('framerate', 'opSub'), [24, 1000, 'FPS']);
		addOption(option);
		option.onChange = onChangeFramerate; //打样

		var langArray:Array<String> = [];
		var contents:Array<String> = FileSystem.readDirectory(Paths.getPath('language'));
		for (item in contents)
		{
			if (item == "JustSay")
				continue; // JustSay不能被读取为语言文件
			var itemPath = Paths.getPath('language') + '/' + item;
			if (FileSystem.isDirectory(itemPath))
			{
				langArray.push(item);
			}
		}
		Language.check();
		var option:Option = new Option(this, 'language', STRING, Language.get('language'), Language.get('language', 'onSub'), langArray);
		addOption(option);
		option.onChange = onChangeLanguage; //打样

		var colorblindFilterArray:Array<String> = [
			'None',
			'Protanopia',
			'Protanomaly',
			'Deuteranopia',
			'Deuteranomaly',
			'Tritanopia',
			'Tritanomaly',
			'Achromatopsia',
			'Achromatomaly'
		];

		var option:Option = new Option(this, 'colorblindMode', STRING, Language.get('colorblindMode', 'op'), Language.get('colorblindMode', 'opSub'), colorblindFilterArray);
		addOption(option);
		option.onChange = onChangeFilter;

		var option:Option = new Option(this, 'lowQuality', BOOL, Language.get('lowQuality', 'op'), Language.get('lowQuality', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'gameQuality', INT, Language.get('gameQuality', 'op'), Language.get('gameQuality', 'opSub'), [0, 3]);
		addOption(option);

		var option:Option = new Option(this, 'antialiasing', BOOL, Language.get('antialiasing', 'op'), Language.get('antialiasing', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'flashing', BOOL, Language.get('flashing', 'op'), Language.get('flashing', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'shaders', BOOL, Language.get('shaders', 'op'), Language.get('shaders', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'cacheOnGPU', BOOL, Language.get('cacheOnGPU', 'op'), Language.get('cacheOnGPU', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'autoPause', BOOL, Language.get('autoPause', 'op'), Language.get('autoPause', 'opSub'));
		addOption(option);
		option.onChange = onChangePause;

		var option:Option = new Option(this, 'gcFreeZone', BOOL, Language.get('gcFreeZone', 'op'), Language.get('gcFreeZone', 'opSub'));
		addOption(option);
		option.onChange = onChangeGcZone;

		changeHeight(0); //初始化真正的height
	}

	function onChangeFramerate()
	{
		if (ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	function onChangeFilter()
	{
		ColorblindFilter.UpdateColors();
	}

	function onChangePause()
	{
		FlxG.autoPause = ClientPrefs.data.autoPause;
	}

	function onChangeLanguage()
	{
		Language.resetData();
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		MusicBeatState.switchState(new OptionsState());
	}

	function onChangeGcZone()
	{
		Main.GcZoneChange();
	}
}
