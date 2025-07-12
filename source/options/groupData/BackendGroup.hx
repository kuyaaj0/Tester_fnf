package options.groupData;

class BackendGroup extends OptionCata
{
    public function new(X:Float, Y:Float, width:Float, height:Float)
	{
        super(X, Y, width, height);

        var option:Option = new Option(this, TITLE, Language.get('Backend', 'op'), Language.get('Backend', 'opSub'));
        addOption(option);

        /////--Gameplaybackend--\\\\\

        

        
		
		/////--judgement--\\\\\
		
		

        changeHeight(0); //初始化真正的height
    }
}