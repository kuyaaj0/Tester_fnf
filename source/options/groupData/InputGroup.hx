package options.groupData;

class InputGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, TITLE, Language.get('Input', 'op'), Language.get('Input', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'ControlsSubState', STATE, Language.get('ControlsSubState', 'op'), Language.get('ControlsSubState', 'opSub'), 'ControlsSubState');
		addOption(option);
		
		/////--TouchMain--\\\\\
		
		var option:Option = new Option(this, TEXT, Language.get('TouchMain', 'op'), Language.get('TouchMain', 'opSub'));
		addOption(option);

		#if desktop
		var option:Option = new Option(this, 'needMobileControl', BOOL, Language.get('needMobileControl', 'op'), Language.get('needMobileControl', 'opSub'));
		addOption(option);
		#end

		var option:Option = new Option(this, 'controlsAlpha', FLOAT, Language.get('controlsAlpha', 'op'), Language.get('controlsAlpha', 'opSub'), [0, 1, 1]);
		addOption(option);
		
		/////--TouchGame--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('TouchGame', 'op'), Language.get('TouchGame', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'MobileControlSelectSubState', STATE, Language.get('MobileControlSelectSubState', 'op'), Language.get('MobileControlSelectSubState', 'opSub'), 'MobileControlSelectSubState');
		addOption(option);

		var option:Option = new Option(this, 'dynamicColors', BOOL, Language.get('dynamicColors', 'op'), Language.get('dynamicColors', 'opSub'));
		addOption(option);

		var hitboxLocationArray:Array<String> = ['Bottom', 'Top', 'Middle'];

		var option:Option = new Option(this, 'hitboxLocation', STRING, Language.get('hitboxLocation', 'op'), Language.get('hitboxLocation', 'opSub'), hitboxLocationArray);
		addOption(option);

		var option:Option = new Option(this, 'playControlsAlpha', FLOAT, Language.get('playControlsAlpha', 'op'), Language.get('playControlsAlpha', 'opSub'), [0, 1, 1]);
		addOption(option);

		var option:Option = new Option(this, 'extraKey', INT, Language.get('extraKey', 'op'), Language.get('extraKey', 'opSub'), [0, 4]);
		addOption(option);

		var option:Option = new Option(this, 'MobileExtraControl', STATE, Language.get('MobileExtraControl', 'op'), Language.get('MobileExtraControl', 'opSub'), 'MobileExtraControl');
		addOption(option);
	}
}
