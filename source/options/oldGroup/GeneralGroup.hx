package options.group;

import shaders.ColorblindFilter;
import options.OptionsState;
import flixel.addons.transition.FlxTransitionableState;

class GeneralGroup
{
	static public function add(follow:OptionBG)
	{
		var option:Option = new Option(Language.get('General'), TITLE);
		follow.addOption(option);

		var reset:ResetRect = new ResetRect(450, 20, follow);
		follow.add(reset);

		var option:Option = new Option(Language.get('framerate'), 'framerate', INT, 24, 1000, 'FPS');
		follow.addOption(option);
		option.onChange = onChangeFramerate;

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
		var option:Option = new Option(Language.get('language'), 'language', STRING, langArray);
		follow.addOption(option);
		option.onChange = onChangeLanguage;

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

		var option:Option = new Option(Language.get('colorblindMode'), 'colorblindMode', STRING, colorblindFilterArray);
		follow.addOption(option);
		option.onChange = onChangeFilter;

		var option:Option = new Option(Language.get('lowQuality'), 'lowQuality', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('gameQuality'), 'gameQuality', INT, 0, 3);
		follow.addOption(option);

		var option:Option = new Option(Language.get('antialiasing'), 'antialiasing', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('flashing'), 'flashing', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('shaders'), 'shaders', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('cacheOnGPU'), 'cacheOnGPU', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('autoPause'), 'autoPause', BOOL);
		follow.addOption(option);
		option.onChange = onChangePause;

		var option:Option = new Option(Language.get('gcFreeZone'), 'gcFreeZone', BOOL);
		follow.addOption(option);
		option.onChange = onChangeGcZone;
	}

	static function onChangeFramerate()
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

	static function onChangeFilter()
	{
		ColorblindFilter.UpdateColors();
	}

	static function onChangePause()
	{
		FlxG.autoPause = ClientPrefs.data.autoPause;
	}

	static function onChangeLanguage()
	{
		Language.resetData();
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		MusicBeatState.switchState(new OptionsState());
	}

	static function onChangeGcZone()
	{
		Main.GcZoneChange();
	}
}
