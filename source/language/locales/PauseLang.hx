package language.locales;

import haxe.Json;

typedef PauseData =
{
	restart:String,
	continues:String,
	difficulty:String,
	editor:String,
	options:String,
	exit:String,
	back:String,
	debug:String,
}

class PauseLang
{
	static var data:PauseData;
	static var defaultData:PauseData;

	static public function get(value:String):String
	{
		var getValue:String = Reflect.getProperty(data, value);
		if (getValue == null)
			getValue = Reflect.getProperty(defaultData, value);
		if (getValue == null)
			getValue = value + ' (missed interpret)';
		return getValue;
	}

	static public function updateLang()
	{
		if (FileSystem.exists(Paths.getPath('language') + '/' + 'English' + '/pause.json'))
			data = defaultData = Json.parse(Paths.getTextFromFile('language/' + 'English' + '/pause.json'));
		if (FileSystem.exists(Paths.getPath('language') + '/' + ClientPrefs.data.language + '/pause.json'))
			data = Json.parse(Paths.getTextFromFile('language/' + ClientPrefs.data.language + '/pause.json'));
	}
}
