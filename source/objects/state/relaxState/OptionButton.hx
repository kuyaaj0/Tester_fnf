package objects.state.relaxState;

import objects.state.relaxState.optionType.*;

class OptionButton extends FlxSpriteGroup
{
    public var test:ArrayType;
    public function new(X:Float, Y:Float = 60){
        super(X, Y);
        test = new ArrayType(0, 0, 'NextSongs', ['Next', 'Restart', 'Random']);
        add(test);
    }
}