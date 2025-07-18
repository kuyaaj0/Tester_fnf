package options.groupData;

class InputGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, 'Input', TITLE);
		addOption(option);

		var option:Option = new Option(this, 'ControlsSubState', STATE);
		option.onChange = changeState;
		addOption(option);
		
		/////--TouchMain--\\\\\
		
		var option:Option = new Option(this, 'TouchMain', TEXT);
		addOption(option);

		#if desktop
		var option:Option = new Option(this, 'needMobileControl', BOOL);
		addOption(option);
		#end

		var option:Option = new Option(this, 'controlsAlpha', FLOAT, [0, 1, 1]);
		addOption(option);
		
		/////--TouchGame--\\\\\

		var option:Option = new Option(this, 'TouchGame', TEXT);
		addOption(option);

		var option:Option = new Option(this, 'MobileControlSelectSubState', STATE);
		addOption(option);

		var hitboxLocationArray:Array<String> = ['Bottom', 'Top', 'Middle'];
		var option:Option = new Option(this, 'hitboxLocation', STRING, hitboxLocationArray);
		addOption(option);

		var option:Option = new Option(this, 'dynamicColors', BOOL);
		addOption(option, true);

		var option:Option = new Option(this, 'playControlsAlpha', FLOAT, [0, 1, 1]);
		addOption(option);

		var option:Option = new Option(this, 'extraKey', INT, [0, 4]);
		addOption(option);

		var option:Option = new Option(this, 'MobileExtraControl', STATE, 'MobileExtraControl');
		addOption(option);

		changeHeight(0); //初始化真正的height
	}

	function changeState() {
		OptionsState.instance.moveState(3);
	}
}
