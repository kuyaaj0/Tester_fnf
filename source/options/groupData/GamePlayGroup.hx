package options.groupData;

class GamePlayGroup extends OptionCata
{
    public function new(X:Float, Y:Float, width:Float, height:Float)
	{
        super(X, Y, width, height);

        var option:Option = new Option(this, TITLE, Language.get('GamePlay', 'op'), Language.get('GamePlay', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'downScroll', BOOL, Language.get('downScroll', 'op'), Language.get('downScroll', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'middleScroll', BOOL, Language.get('middleScroll', 'op'), Language.get('middleScroll', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'flipChart', BOOL, Language.get('flipChart', 'op'), Language.get('flipChart', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'ghostTapping', BOOL, Language.get('ghostTapping', 'op'), Language.get('ghostTapping', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'guitarHeroSustains', BOOL, Language.get('guitarHeroSustains', 'op'), Language.get('guitarHeroSustains', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'noReset', BOOL, Language.get('noReset', 'op'), Language.get('noReset', 'opSub'));
        addOption(option);

        /////--Opponent--\\\\\

        var option:Option = new Option(this, TEXT, Language.get('Opponent', 'op'), Language.get('Opponent', 'opSub'));
		addOption(option);

        var option:Option = new Option(this, 'playOpponent', BOOL, Language.get('playOpponent', 'op'), Language.get('playOpponent', 'opSub'));
        addOption(option);
        
        var option:Option = new Option(this, 'opponentCodeFix', BOOL, Language.get('opponentCodeFix', 'op'), Language.get('opponentCodeFix', 'opSub'));
        addOption(option);
        
        var option:Option = new Option(this, 'botOpponentFix', BOOL, Language.get('botOpponentFix', 'op'), Language.get('botOpponentFix', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'HealthDrainOPPO', BOOL, Language.get('HealthDrainOPPO', 'op'), Language.get('HealthDrainOPPO', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'HealthDrainOPPOMult', FLOAT, Language.get('HealthDrainOPPOMult', 'op'), Language.get('HealthDrainOPPOMult', 'opSub'), [0, 5, 1]);
        addOption(option);
    }
}