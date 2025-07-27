package objects.state.relaxState.optionType;

class BoolType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;
    var nowChoose:FlxText;
    var label:String;
    
    var isPressed:Bool = false;
    var canPress:Bool = true;
    
    var helpBool:Bool;

    public function new(X:Int = 0, Y:Int = 0, labels:String = 'test'){
        super(X * 177.5, Y * 77.5);
        
        label = labels;
        helpBool = Reflect.getProperty(ClientPrefs.data, label);
        
        background = new Rect(X * 177.5, Y * 77.5, 350, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(background.x + 10, background.y + 10, 295, Language.get(labels, 'relax'));
        labelText.autoSize = true;
        labelText.setFormat(Paths.font("montserrat.ttf"), 28, FlxColor.WHITE, LEFT);
        add(labelText);
        
        nowChoose = new FlxText(labelText.x, 110 + Y * 67.5, 295, Reflect.getProperty(ClientPrefs.data, label));
        nowChoose.autoSize = true;
        nowChoose.setFormat(Paths.font("montserrat.ttf"), 25, FlxColor.WHITE, LEFT);
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
        
        if(helpBool){
            background.color = FlxColor.interpolate(background.color, 0xFFB5B0DD, 0.3);
        }else{
            background.color = FlxColor.interpolate(background.color, 0xFF403E4E, 0.3);
        }
    }
    
    function updateData(){
        nowChoose.text = Std.string(!helpBool);
        Reflect.setProperty(ClientPrefs.data, label, !helpBool);
        
        helpBool = !helpBool;
    }
}