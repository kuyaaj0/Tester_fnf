package objects.state.relaxState;

import objects.state.relaxState.optionType.*;

class OptionButton extends FlxSpriteGroup
{
    public var test:Dynamic;
    var optionButtons:Array<Dynamic> = [];
    
    public function new(X:Float, Y:Float = 60){
        super(X, Y);
        optionButtons = [];
        
        test = new ArrayType(0, 0, 'NextSongs', ['Next', 'Restart', 'Random']);
        pushOption(test);
        //////
        test = new BoolType(1, 0, 'enableRecordRotation');
        pushOption(test);
        
        test = new BoolType(1, 1, 'enableBpmZoom');
        pushOption(test);
        //////
        test = new IntType(2, 0, 'RelaxAudioDisplayQuality', 1, 10);
        pushOption(test);
        
        test = new IntType(2, 1, 'RelaxAudioNumber', 1, 8);
        pushOption(test);
        
        test = new BoolType(2, 2, 'RelaxAudioSymmetry');
        pushOption(test);
        //////
        
        test = new ArrayType(3, 0, 'theme', ["Circle", "Straight", "None"]);
        pushOption(test);
        
        test = new ArrayType(3, 1, 'songInfo', ["None", "Middle", "topLeft", "downLeft", "topRight", "downRight"]);
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