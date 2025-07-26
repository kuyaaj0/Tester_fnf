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

    public function new(X:Int = 0, Y:Int = 0, lable:String = 'test', Assistant:Array<String>){
        super(X, Y);
        
        helpArray = Assistant;
        this.label = label;
        
        background = new Rect(X, Y, 300, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(X + 5, Y + 5, 295, Language.get(label, 'relax'););
        labelText.autoSize = true;
        labelText.setFormat(Paths.font("montserrat.ttf"), 20, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(labelText.x, labelText.y + labelText.height, 295, Reflect.getProperty(ClientPrefs.data, label));
        nowChoose.autoSize = true;
        nowChoose.setFormat(Paths.font("montserrat.ttf"), 16, FlxColor.WHITE, LEFT);
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
        
        if(FlxG.mouse.Pressed && canPress){
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
        ClientPrefs.saveSettings();
    }
}