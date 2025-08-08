package objects.state.relaxState;

import flixel.text.FlxText;

class BackButtons extends FlxSpriteGroup
{
    public var backButtons:ButtonSprite;
    public var backText:FlxText;
    public var back:Void->Void = null;

    public function new(X:Float = 0, Y:Float = 0)
    {
        super(X, Y);

        backButtons = new FlxSprite().loadGraphic(Paths.image(FreeplayState.filePath + 'detailsBG1'));
        add(backButtons);

        backText = new FlxText(5, 10, 0, "Back", 24);
        backText.alignment = "center";
        backText.setFormat(Paths.font("montserrat.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(backText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
            back();
        }
    }
}