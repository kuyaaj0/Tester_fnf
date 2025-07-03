package options.group;

class GameplayGroup
{
	static public function add(follow:OptionBG)
	{
		var option:Option = new Option(Language.get('Gameplay'), TITLE);
		follow.addOption(option);

		var reset:ResetRect = new ResetRect(450, 20, follow);
		follow.add(reset);

		var option:Option = new Option(Language.get('downScroll'), 'downScroll', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('middleScroll'), 'middleScroll', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('flipChart'), 'flipChart', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('ghostTapping'), 'ghostTapping', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('guitarHeroSustains'), 'guitarHeroSustains', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('noReset'), 'noReset', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('NoteOffsetState'), 'NoteOffsetState', STATE);
		follow.addOption(option);

		///////////////////////////////

		var option:Option = new Option(Language.get('Opponent'), TEXT);
		follow.addOption(option);

		var option:Option = new Option(Language.get('playOpponent'), 'playOpponent', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('opponentCodeFix'), 'opponentCodeFix', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('botOpponentFix'), 'botOpponentFix', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('HealthDrainOPPO'), 'HealthDrainOPPO', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('HealthDrainOPPOMult'), 'HealthDrainOPPOMult', FLOAT, 0, 5, 1);
		follow.addOption(option);
	}
}
