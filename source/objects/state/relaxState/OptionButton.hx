package objects.state.relaxState;

import objects.state.relaxState.optionType.*;

class OptionButton extends FlxSpriteGroup
{
    public var test:ArrayType;
    var optionButtons:Array = [];
    
    public function new(X:Float, Y:Float = 60){
        super(X, Y);
        optionButtons = [];
        
        test = new ArrayType(0, 0, 'NextSongs', ['Next', 'Restart', 'Random']);
        pushOption(test);
        
        
        
        addOption();
    }
    
    public function pushOption(option:Dynamic){
        optionButtons.push(option);
    }
    
    public function addOption(){
        for (i in optionButtons){
            add(i);
        }
    }
}