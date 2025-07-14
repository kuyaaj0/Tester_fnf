package language;

import language.locales.*;

class Language
{
	public static function get(value:String, type:String = 'op'):String
	{
		switch (type)
		{
			case 'mm':
				return MainMenuLang.get(value);
			case 'ma':
				return MainLang.get(value);
			case 'fp':
				return FreePlayLang.get(value);
			case 'op':
				return OptionsLang.get(value);
			case 'opTip':
				return OptionsTipLang.get(value);
			case 'pa':
				return PauseLang.get(value);
		}
		return "error";
	}

	public static function resetData()
	{
		check();
		MainMenuLang.updateLang();
		MainLang.updateLang();
		FreePlayLang.updateLang();
		OptionsLang.updateLang();
		OptionsTipLang.updateLang();
		PauseLang.updateLang();
	}

	public static function check()
	{
		if (!FileSystem.isDirectory(Paths.getPath('language') + '/' + ClientPrefs.data.language))
			ClientPrefs.data.language = 'Engine';
	}

	public static function setupData(follow:Dynamic, directoryPath:Array<String>)
	{
		for (path in 0...directoryPath.length) {
			if (FileSystem.isDirectory(directoryPath[path])) {
				for (file in FileSystem.readDirectory(directoryPath[path])) {
					if (file.toLowerCase().endsWith('.lang')) {
						var outputData = CoolUtil.coolTextFile(directoryPath[path] + file);
						for (list in 0...outputData.length) {
							var line = outputData[list];
							if (line.length > 0 && line.indexOf(' => ') != -1) {
								var key = line.substr(0, line.indexOf(' => '));
								var value = line.substr(line.indexOf(' => ') + 1, line.length);
								if (path == 0)
									follow.defaultData.set(key, value);
								else
									follow.data.set(key, value);
							}
						}
					}
				}
			}
		}
	}
}
