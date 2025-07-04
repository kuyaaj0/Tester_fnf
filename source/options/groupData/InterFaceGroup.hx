package options.groupData;

class InterfaceGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, TITLE, Language.get('UserInterface', 'op'), Language.get('UserInterface', 'opSub'));
		addOption(option);

		var CustomFadeArray:Array<String> = ['Move', 'Alpha'];

		var option:Option = new Option(this, 'CustomFade', STRING, Language.get('CustomFade', 'op'), Language.get('CustomFade', 'opSub'), CustomFadeArray);
		addOption(option);

		var option:Option = new Option(this, 'CustomFadeSound', FLOAT, Language.get('CustomFadeSound', 'op'), Language.get('CustomFadeSound', 'opSub'), [0, 1, 1]);
		addOption(option);

		var option:Option = new Option(this, 'CustomFadeText', BOOL, Language.get('CustomFadeText', 'op'), Language.get('CustomFadeText', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'skipTitleVideo', BOOL, Language.get('skipTitleVideo', 'op'), Language.get('skipTitleVideo', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'audioDisplayQuality', INT, Language.get('audioDisplayQuality', 'op'), Language.get('audioDisplayQuality', 'opSub'), [1, 4]);
		addOption(option);

		var option:Option = new Option(this, 'audioDisplayUpdate', INT, Language.get('audioDisplayUpdate', 'op'), Language.get('audioDisplayUpdate', 'opSub'), [0, 200, 'MS']);
		addOption(option);

		var option:Option = new Option(this, 'freeplayOld', BOOL, Language.get('freeplayOld', 'op'), Language.get('freeplayOld', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'resultsScreen', BOOL, Language.get('resultsScreen', 'op'), Language.get('resultsScreen', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'loadingScreen', BOOL, Language.get('loadingScreen', 'op'), Language.get('loadingScreen', 'opSub'));
		addOption(option);

		changeHeight(0.0000001); //初始化真正的height
	}
}
