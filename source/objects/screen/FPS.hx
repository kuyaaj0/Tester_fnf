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
		versionShow.y = 7;
	}
	    
	extraShow.visible = ClientPrefs.data.showExtra;
    }
    
    private override function __enterFrame(deltaTime:Float):Void
	{	    	    	    
	    DataGet.update();
	    
	    if (DataGet.number != 0) return;
	    
	    fpsShow.update();
	    extraShow.update();
    }
    
    public function change()
    {       
        extraShow.visible = ClientPrefs.data.showExtra;
	if (!ClientPrefs.data.showExtra)
	{
		versionShow.y = 70
	}else{
		versionShow.y = 130
	}
    }
}
