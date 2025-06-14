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
		PauseLang.updateLang();
	}

	public static function check()
	{
		if (!FileSystem.isDirectory(Paths.getPath('language') + '/' + ClientPrefs.data.language))
			ClientPrefs.data.language = 'Engine';
	}
}
