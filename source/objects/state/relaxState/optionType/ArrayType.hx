package objects.state.relaxState.optionType;

class ArrayType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;
    var nowChoose:FlxText;
    var helpArray:Array<String> = [];
    var nowNum:Int = 0;
    var label:String;
    
    var isPressed:Bool = false;
    var canPress:Bool = true;
    
    var BGwidth:Int = 233;
    var BGheight:Int = 100;

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test', Assistant:Array<String>){
        super(X * (BGwidth / 2), Y * (BGheight / 2));
        
        helpArray = Assistant;
        label = labels;
        
        background = new Rect(X * (BGwidth / 2), Y * (BGheight / 2), BGwidth, BGheight, 20, 20, 0xFF403E4E);
        add(background);

        labelText = new FlxText(X * (BGwidth / 2) + 10, Y * (BGheight / 2) + 10, 295, Language.get(labels, 'relax'));
        labelText.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 19, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(X * (BGwidth / 2) + 10, 110 + Y * 45, 295, Std.string(helpInt));
        nowChoose.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 17, FlxColor.WHITE, LEFT);
        add(nowChoose);
    }
    
    var saveX = 0;
    var saveY = 0;
    
    override public function update(elapsed:Float){
        super.update(elapsed);
        if(FlxG.mouse.justPressed){
            saveX = FlxG.mouse.x;
            saveY = FlxG.mouse.y;
        }
        
        if(FlxG.mouse.pressed && canPress){
            if((saveX < FlxG.mouse.x - 5 || saveX > FlxG.mouse.x + 5) ||
              (saveY < FlxG.mouse.y - 5 || saveY > FlxG.mouse.y + 5)){
                canPress = false;
            }
        }
        
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
            isPressed = true;
        }
        
        if (isPressed && FlxG.mouse.justReleased && canPress) {
            isPressed = false;
            updateData();
        }
        
        if(FlxG.mouse.justReleased){
            canPress = true;
        }
    }
    
    function updateData(){
        nowNum++;
        if(nowNum > helpArray.length - 1) nowNum = 0;
        
        nowChoose.text = helpArray[nowNum];
        
        Reflect.setProperty(ClientPrefs.data, label, helpArray[nowNum]);
    }
}