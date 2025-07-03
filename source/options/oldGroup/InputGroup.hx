package options.group;

class InputGroup
{
	static public function add(follow:OptionBG)
	{
		var option:Option = new Option(Language.get('Input'), TITLE);
		follow.addOption(option);

		var reset:ResetRect = new ResetRect(450, 20, follow);
		follow.add(reset);

		///////////////////////////////

		var option:Option = new Option(Language.get('ControlsSubState'), 'ControlsSubState', STATE);
		follow.addOption(option);

		var option:Option = new Option(Language.get('TouchMain'), TEXT);
		follow.addOption(option);

		#if desktop
		var option:Option = new Option(Language.get('needMobileControl'), 'needMobileControl', BOOL);
		follow.addOption(option);
		#end

		var option:Option = new Option(Language.get('controlsAlpha'), 'controlsAlpha', FLOAT, 0, 1, 1);
		follow.addOption(option);

		var option:Option = new Option(Language.get('TouchGame'), TEXT);
		follow.addOption(option);

		var option:Option = new Option(Language.get('MobileControlSelectSubState'), 'MobileControlSelectSubState', STATE);
		follow.addOption(option);

		var option:Option = new Option(Language.get('dynamicColors'), 'dynamicColors', BOOL);
		follow.addOption(option);

		var hitboxLocationArray:Array<String> = ['Bottom', 'Top', 'Middle'];

		var option:Option = new Option(Language.get('hitboxLocation'), 'hitboxLocation', STRING, hitboxLocationArray);
		follow.addOption(option);

		var option:Option = new Option(Language.get('playControlsAlpha'), 'playControlsAlpha', FLOAT, 0, 1, 1);
		follow.addOption(option);

		var option:Option = new Option(Language.get('extraKey'), 'extraKey', INT, 0, 4);
		follow.addOption(option);

		var option:Option = new Option(Language.get('MobileExtraControl'), 'MobileExtraControl', STATE);
		follow.addOption(option);
	}
}
