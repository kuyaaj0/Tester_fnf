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

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test', Assistant:Array<String>){
        super(X * 177.5, Y * 77.5);
        
        helpArray = Assistant;
        label = labels;
        
        background = new Rect(X * 177.5, Y * 77.5, 350, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(X * 177.5 + 10, Y * 77.5 + 10, 295, Language.get(labels, 'relax'));
        labelText.autoSize = true;
        labelText.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 28, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(X * 177.5 + 10, 110 + Y * 67.5, 295, Reflect.getProperty(ClientPrefs.data, label));
        nowChoose.autoSize = true;
        nowChoose.setFormat(Paths.font(Language.get('fontName', 'ma') + '.ttf'), 25, FlxColor.WHITE, LEFT);
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