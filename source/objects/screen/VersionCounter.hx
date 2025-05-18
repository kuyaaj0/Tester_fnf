package objects.screen;

import states.MainMenuState;

class VersionCounter extends Sprite
{
        public var EngineName:TextField;
        public var Version:TextField;
        
        public var bgSprite:FPSBG;

        public function new(x:Float = 10, y:Float = 10)
	{
                super();

		this.x = x;
		this.y = y;		
		
		bgSprite = new FPSBG();
		addChild(bgSprite);

                this.EngineName = new TextField();
                this.Version = new TextField();

                for(label in [this.EngineName, this.Version]) {	
			label.x = 0;
			label.y = 0;
			label.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, 15, 0xFFFFFFFF, false, null, null, LEFT, 0, 0);			
			label.multiline = label.wordWrap = false;
			label.selectable = false; 
			label.mouseEnabled = false;
			addChild(label);
		}

                this.EngineName.y = this.Version.y = 20;
                
                this.EngineName.y += 2;
		this.Version.y += 2;

                this.EngineName.text = "NovaFlare Engine";
                this.Version.text = MainMenuState.novaFlareEngineVersion;

                this.EngineName.width = 300;
		this.Version.width = 300;

                this.EngineName.x += 4;
		this.Version.x += 4;
        }
}
