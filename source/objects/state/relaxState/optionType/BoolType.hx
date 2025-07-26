package objects.state.relaxState.optionType;

class BoolType extends FlxSpriteGroup
{
    var background:FlxSprite;
    var labelText:FlxText;
    var nowChoose:FlxText;
    
    var isPressed:Bool = false;
    var canPress:Bool = true;
    
    var helpBool:Bool;

    public function new(X:Int = 0, Y:Int = 0, lable:String = 'test'){
        this.label = label;
        
        background = new Rect(X, Y, 300, 150, 20, 20, 0xFF403E4E);
        add(background);
        
        labelText = new FlxText(X + 5, Y + 5, 295, Language.get(label, 'relax'););
        labelText.autoSize = true;
        labelText.setFormat(Paths.font("montserrat.ttf"), 20, FlxColor.WHITE, LEFT);
        add(labelText);
        
        helpBool = Reflect.getProperty(ClientPrefs.data, label);
        
        nowChoose = new FlxText(labelText.x, labelText.y + labelText.height, 295, Std.string(helpBool));
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
        
        if(helpBool){
            background.color = FlxColor.interpolate(background.color, 0xFFB5B0DD, 0.3);
        }else{
            background.color = FlxColor.interpolate(background.color, 0xFF403E4E, 0.3);
        }
    }
    
    function updateData(){
        nowChoose.text = Std.string(!helpBool);
        
        Reflect.setProperty(ClientPrefs.data, label, !helpBool);
        ClientPrefs.saveSettings();
    }
}