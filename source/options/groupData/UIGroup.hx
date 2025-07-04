package options.groupData;

class UIGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, TITLE, Language.get('GameUI', 'op'), Language.get('GameUI', 'opSub'));
		addOption(option);
		
		/////--Visble--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('Visble', 'op'), Language.get('Visble', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'hideHud', BOOL, Language.get('hideHud', 'op'), Language.get('hideHud', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'showComboNum', BOOL, Language.get('showComboNum', 'op'), Language.get('showComboNum', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'showRating', BOOL, Language.get('showRating', 'op'), Language.get('showRating', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'opponentStrums', BOOL, Language.get('opponentStrums', 'op'), Language.get('opponentStrums', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'judgementCounter', BOOL, Language.get('judgementCounter', 'op'), Language.get('judgementCounter', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'keyboardDisplay', BOOL, Language.get('keyboardDisplay', 'op'), Language.get('keyboardDisplay', 'opSub'));
		addOption(option);

		/////--TimeBar--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('TimeBar', 'op'), Language.get('TimeBar', 'opSub'));
		addOption(option);

		var TimeBarArray:Array<String> = ['Time Left', 'Time Elapsed', 'Song Name', 'Disabled'];
		var option:Option = new Option(this, 'timeBarType', STRING, Language.get('timeBarType', 'op'), Language.get('timeBarType', 'opSub'), TimeBarArray);
		addOption(option);

		/////--HealthBar--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('HealthBar', 'op'), Language.get('HealthBar', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'healthBarAlpha', FLOAT, Language.get('healthBarAlpha', 'op'), Language.get('healthBarAlpha', 'opSub'), [0, 1, 1]);
		addOption(option);

		var option:Option = new Option(this, 'oldHealthBarVersion', BOOL, Language.get('oldHealthBarVersion', 'op'), Language.get('oldHealthBarVersion', 'opSub'));
		addOption(option);

		/////--Combo--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('Combo', 'op'), Language.get('Combo', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'comboColor', BOOL, Language.get('comboColor', 'op'), Language.get('comboColor', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'comboOffsetFix', BOOL, Language.get('comboOffsetFix', 'op'), Language.get('comboOffsetFix', 'opSub'));
		addOption(option);
		
		/////--KeyBoard--\\\\\
		
		var option:Option = new Option(this, TEXT, Language.get('KeyBoard', 'op'), Language.get('KeyBoard', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'keyboardAlpha', FLOAT, Language.get('keyboardAlpha', 'op'), Language.get('keyboardAlpha', 'opSub'), [0, 1, 1]);
		addOption(option);

		var option:Option = new Option(this, 'keyboardTimeDisplay', BOOL, Language.get('keyboardTimeDisplay', 'op'), Language.get('keyboardTimeDisplay', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'keyboardTime', INT, Language.get('keyboardTime', 'op'), Language.get('keyboardTime', 'opSub'), [0, 1000, 'MS']);
		addOption(option);

		var colorStingArray = [
			'BLACK', 'WHITE', 'GRAY', 'RED', 'GREEN', 'BLUE', 'YELLOW', 'PINK', 'ORANGE', 'PURPLE', 'BROWN', 'CYAN'
		];

		var option:Option = new Option(this, 'keyboardBGColor', STRING, Language.get('keyboardBGColor', 'op'), Language.get('keyboardBGColor', 'opSub'), colorStingArray);
		addOption(option);

		var option:Option = new Option(this, 'keyboardTextColor', STRING, Language.get('keyboardTextColor', 'op'), Language.get('keyboardTextColor', 'opSub'), colorStingArray);
		addOption(option);
		
		/////--Camera--\\\\\
		
		var option:Option = new Option(this, TEXT, Language.get('Camera', 'op'), Language.get('Camera', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'camZooms', BOOL, Language.get('camZooms', 'op'), Language.get('camZooms', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'scoreZoom', BOOL, Language.get('scoreZoom', 'op'), Language.get('scoreZoom', 'opSub'));
		addOption(option);

		changeHeight(0.0000001); //初始化真正的height
	}
}
