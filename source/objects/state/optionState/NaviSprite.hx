package objects.state.optionState;

class NaviSprite extends FlxSpriteGroup
{
    var filePath:String = 'menuExtend/OptionsState/icons';

    public var optionSort:Int;
    public var isModsAdd:Bool = false;

    public var background:ExtraRoundRect;
    public var icon:FlxSprite;
    public var textDis:FlxText;

    

    public function new(X:Float, Y:Float, width:Float, height:Float, name:String, sort:Int, modsAdd:Bool = false) {
        super(X, Y);
        optionSort = sort;

        background = new ExtraRoundRect(0, 0, width, height, LEFT_CENTER, EenginSet.mainColor);
        add(background);

        icon = new FlxSprite().loadGraphic(Paths.image(filePath));
        //icon.

    }
}