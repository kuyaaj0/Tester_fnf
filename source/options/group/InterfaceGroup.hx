package options.group;

class InterfaceGroup
{
	static public function add(follow:OptionBG)
	{
		var option:Option = new Option(Language.get('UserInterface'), TITLE);
		follow.addOption(option);

		var reset:ResetRect = new ResetRect(450, 20, follow);
		follow.add(reset);

		var CustomFadeArray:Array<String> = ['Move', 'Alpha'];

		var option:Option = new Option(Language.get('CustomFade'), 'CustomFade', STRING, CustomFadeArray);
		follow.addOption(option);

		var option:Option = new Option(Language.get('CustomFadeSound'), 'CustomFadeSound', FLOAT, 0, 1, 1);
		follow.addOption(option);

		var option:Option = new Option(Language.get('CustomFadeText'), 'CustomFadeText', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('skipTitleVideo'), 'skipTitleVideo', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('audioDisplayQuality'), 'audioDisplayQuality', INT, 1, 4);
		follow.addOption(option);

		var option:Option = new Option(Language.get('audioDisplayUpdate'), 'audioDisplayUpdate', INT, 0, 200, 'MS');
		follow.addOption(option);

		var option:Option = new Option(Language.get('freeplayOld'), 'freeplayOld', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('resultsScreen'), 'resultsScreen', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('loadingScreen'), 'loadingScreen', BOOL);
		follow.addOption(option);
	}
}
