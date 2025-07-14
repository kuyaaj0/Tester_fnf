package language.locales;

class OptionsTipLang
{
	static var data:Map<String, String> = [];
	static var defaultData:Map<String, String> = [];

	static public function get(value:String):String
	{
		var getValue:String = data.get(value);
		if (getValue == null)
			getValue = defaultData.get(value);
		if (getValue == null)
			getValue = value + ' (missed interpret)';
		return getValue;
	}

	static public function updateLang()
	{
		data.clear();
		defaultData.clear();
		
		var minorPath:String = '/optionsTip';
		var directoryPath:Array<String> = [Paths.getPath('language') + '/' + 'English' + minorPath];

		var path = Paths.getPath('language') + '/' + ClientPrefs.data.language + minorPath;
		if (!FileSystem.exists(path)) directoryPath.push(Paths.getPath('language') + '/' + 'English' + minorPath);
		else directoryPath.push(path);

		Language.setupData(MainMenuLang, directoryPath);
	}
}
