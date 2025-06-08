package objects.screen;

/*
    author: beihu235
    bilibili: https://b23.tv/SnqG443
    github: https://github.com/beihu235
    youtube: https://youtube.com/@beihu235?si=NHnWxcUWPS46EqUt
    discord: @beihu235

    thanks Chiny help me adjust data
    github: https://github.com/dmmchh
*/

class FPS extends Sprite
{
	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;
		
		create();
	}
    
    public static var fpsShow:FPSCounter;
    public static var extraShow:ExtraCounter;    
    public static var versionShow:VersionCounter;

    public var isHiding:Bool = true;
    
    function create()
    {        
        fpsShow = new FPSCounter(10, 10);
        addChild(fpsShow);
        fpsShow.update();
	    
        extraShow = new ExtraCounter(10, 70);
        addChild(extraShow);
	extraShow.update();

	versionShow = new VersionCounter(10, 130);
	addChild(versionShow);

	if (!ClientPrefs.data.showExtra)
	{
		versionShow.y = 70;
	}
	    
	extraShow.visible = ClientPrefs.data.showExtra;
    }
    
    private override function __enterFrame(deltaTime:Float):Void
	{	    	    	    
	    DataGet.update();
	    
	    if (DataGet.number != 0) return;
	    
	    fpsShow.update();
	    extraShow.update();
	    versionShow.update();

	    if(isPointInFPSCounter()){
		    if(FlxG.mouse.justPressed){
			    if(isHiding){
				    isHiding = false;
			    }else{
				    isHiding = true;
			    }
		    }
	    }
	    if(isHiding && extraShow.alpha > 0.1 && versionShow.alpha > 0.1){
			extraShow.alpha -= 0.1;
		        versionShow.alpha -= 0.1;
	    }else if(!isHiding && extraShow.alpha < 1 && versionShow.alpha < 1){
			extraShow.alpha += 0.1;
		        versionShow.alpha += 0.1;
	    }
    }
    
    public function change()
    {       
        extraShow.visible = ClientPrefs.data.showExtra;
	if (!ClientPrefs.data.showExtra)
	{
		versionShow.y = 70;
		versionShow.change();
	}else{
		versionShow.y = 130;
		versionShow.change();
	}
    }
    private function isPointInFPSCounter():Bool
    {
        var fpsX = fpsShow.x;
        var fpsY = fpsShow.y;
        var fpsWidth = fpsShow.width;
        var fpsHeight = fpsShow.height;

        return FlxG.mouse.x >= fpsX && FlxG.mouse.x <= fpsX + fpsWidth && FlxG.mouse.y >= fpsY && FlxG.mouse.y <= fpsY + fpsHeight;
    }
}
