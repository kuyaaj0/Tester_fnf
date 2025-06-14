package options.group;

class BackendGroup
{
	static public function add(follow:OptionBG)
	{
		var option:Option = new Option(Language.get('Backend'), TITLE);
		follow.addOption(option);

		var reset:ResetRect = new ResetRect(450, 20, follow);
		follow.add(reset);

		///////////////////////////////

		var option:Option = new Option(Language.get('Gameplaybackend'), TEXT);
		follow.addOption(option);

		var option:Option = new Option(Language.get('replayBot'), 'replayBot', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('fixLNL'), 'fixLNL', INT, 0, 2);
		follow.addOption(option);

		var MainMusicArray:Array<String> = ['None', 'freakyMenu'];
		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'music/Main Screen/'))
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.endsWith('.ogg'))
					MainMusicArray.push(file.replace('.ogg', ''));
			}

		var option:Option = new Option(Language.get('mainMusic'), 'mainMusic', STRING, MainMusicArray);
		follow.addOption(option);

		var OptionMusicArray:Array<String> = ['None'];
		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'music/Options Screen/'))
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.endsWith('.ogg'))
					OptionMusicArray.push(file.replace('.ogg', ''));
			}

		var option:Option = new Option(Language.get('optionMusic'), 'optionMusic', STRING, OptionMusicArray);
		follow.addOption(option);

		var PauseMusicArray:Array<String> = ['None', 'Breakfast', 'Tea Time'];
		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'music/Pause Screen/'))
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.endsWith('.ogg'))
					PauseMusicArray.push(file.replace('.ogg', ''));
			}

		var option:Option = new Option(Language.get('pauseMusic'), 'pauseMusic', STRING, PauseMusicArray);
		follow.addOption(option);

		var hitsoundArray:Array<String> = ['Default'];
		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'sounds/hitsounds/'))
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.endsWith('.ogg'))
					hitsoundArray.push(file.replace('.ogg', ''));
			}
		var option:Option = new Option(Language.get('hitsoundType'), 'hitsoundType', STRING, hitsoundArray);
		follow.addOption(option);
		option.onChange = onChangeHitsound;

		var option:Option = new Option(Language.get('hitsoundVolume'), 'hitsoundVolume', FLOAT, 0, 1, 1);
		follow.addOption(option);

		var option:Option = new Option(Language.get('oldHscriptVersion'), 'oldHscriptVersion', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('pauseButton'), 'pauseButton', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('CompulsionPause'), 'CompulsionPause', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('CompulsionPauseNumber'), 'CompulsionPauseNumber', INT, 1, 10);
		follow.addOption(option);

		#if android
		var option:Option = new Option(Language.get('gameOverVibration'), 'gameOverVibration', BOOL);
		follow.addOption(option);
		#end

		var option:Option = new Option(Language.get('judgement'), TEXT);
		follow.addOption(option);

		var option:Option = new Option(Language.get('ratingOffset'), 'ratingOffset', INT, -500, 500, 'MS');
		follow.addOption(option);

		var option:Option = new Option(Language.get('safeFrames'), 'safeFrames', FLOAT, 0, 10, 1);
		follow.addOption(option);

		var option:Option = new Option(Language.get('marvelousWindow'), 'marvelousWindow', INT, 0, 166, 'MS');
		follow.addOption(option);

		var option:Option = new Option(Language.get('sickWindow'), 'sickWindow', INT, 0, 166, 'MS');
		follow.addOption(option);

		var option:Option = new Option(Language.get('goodWindow'), 'goodWindow', INT, 0, 166, 'MS');
		follow.addOption(option);

		var option:Option = new Option(Language.get('badWindow'), 'badWindow', INT, 0, 166, 'MS');
		follow.addOption(option);

		var option:Option = new Option(Language.get('marvelousRating'), 'marvelousRating', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('marvelousSprite'), 'marvelousSprite', BOOL);
		follow.addOption(option);

		///////////////////////////////

		var option:Option = new Option(Language.get('Appbackend'), TEXT);
		follow.addOption(option);

		var option:Option = new Option(Language.get('discordRPC'), 'discordRPC', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('checkForUpdates'), 'checkForUpdates', BOOL);
		follow.addOption(option);

		#if mobile
		var option:Option = new Option(Language.get('screensaver'), 'screensaver', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('filesCheck'), 'filesCheck', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('filesCheckNew'), 'CopyState', STATE);
		follow.addOption(option);
		#end
	}

	static function onChangeHitsound()
	{
		if (ClientPrefs.data.hitsoundType == ClientPrefs.defaultData.hitsoundType)
		{
			// FlxG.sound.play(Paths.sound(ClientPrefs.data.hitsoundType));   为啥他会有问题啊
		}
		else
		{
			// FlxG.sound.play(Paths.sound('hitsounds/' + ClientPrefs.data.hitsoundType));
		}
	}

	static function onChangeCwd()
	{
		Sys.setCwd(SUtil.getStorageDirectory());
	}
}
