package options;

import openfl.Lib;
import lime.app.Application;
import backend.MusicBeatState;

import flixel.addons.transition.FlxTransitionableState;

import shaders.ColorblindFilter;

import objects.screen.FPS;

class Option
{
	public function new()
	{
	    disable_O = OptionsName.funcDisable();
	    enable_O = OptionsName.funcEnable();
	    MS_O = OptionsName.funcMS();
	    grid_O = OptionsName.funcGrid();
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	
	private var acceptValues = false;
	
	private var disable_O:String = '';
	private var enable_O:String = '';
	private var MS_O:String = '';
	private var grid_O:String = '';
    
    //public var onChange:Void->Void = null;
    
	public var acceptType = false;

	public var waitingType = false;
	
	public function change():Void
	{
	    //nothing
	}

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept()
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String
	{
		return updateDisplay();
	};

	public function onType(text:String)
	{
	
	}

	// Returns whether the label is to be updated.
	public function press()
	{
	
    }
	
	public function left()
	{
		return;
	}

	public function right()
	{
		return;
	}
	
	private function updateDisplay():String
	{
		return "";
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类1
class Downscroll extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.downScroll = !ClientPrefs.data.downScroll;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "DownScroll" + ": " + (ClientPrefs.data.downScroll ? enable_O : disable_O);
	}
}

class MiddleScroll extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.middleScroll = !ClientPrefs.data.middleScroll;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Middle Scroll: " + (ClientPrefs.data.middleScroll ? enable_O : disable_O);
	}
}

class FilpChart extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.filpChart = !ClientPrefs.data.filpChart;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Filp Chart: " + (ClientPrefs.data.filpChart ? enable_O : disable_O);
	}
}

class GuitarHeroSustains extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
		ClientPrefs.data.guitarHeroSustains = !ClientPrefs.data.guitarHeroSustains;
		display = updateDisplay();
    }
    
    override function right()
    {left();
    }
    
	private override function updateDisplay():String
	{
		return "Sustains Note Input: < " + (ClientPrefs.data.guitarHeroSustains ? 'New' : 'Classic') + ' >';
	}
}

class FixLNL extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.fixLNL--;
		if (ClientPrefs.data.fixLNL < 0)
			ClientPrefs.data.fixLNL = 0;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.fixLNL++;
		if (ClientPrefs.data.fixLNL > 2)
			ClientPrefs.data.fixLNL = 2;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Long Note Length Reduce: < " + ClientPrefs.data.fixLNL + " Grid >";
	}
}

class GhostTap extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.ghostTapping = !ClientPrefs.data.ghostTapping;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Ghost Tapping: " + (ClientPrefs.data.ghostTapping ? enable_O : disable_O);
	}
}

class NoReset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.noReset = !ClientPrefs.data.noReset;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Reset Button: " + (!ClientPrefs.data.noReset ? enable_O : disable_O);
	}
}

class ResultsScreen extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.resultsScreen = !ClientPrefs.data.resultsScreen;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Results Screen: " + (ClientPrefs.data.resultsScreen ? enable_O : disable_O);
	}
}

class SmoothHealth extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.snoothHealth = !ClientPrefs.data.smoothHealth;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Smooth Health: " + (ClientPrefs.data.smoothHealth ? enable_O : disable_O);
	}
}

class NoteOffset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{	
	    OptionsState.instance.openSub('NoteOffsetState');		    
	    			
    }
    
    private override function updateDisplay():String
	{
		return "Note Offset Option";
	}
}

class Judgement extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	override function press()
	{						
		var num:Int = 8;	
		OptionsState.instance.selectedCatIndex = num;
		OptionsState.instance.switchCat(OptionsState.instance.options[num], false);
		
    }

	private override function updateDisplay():String
	{
		return "Edit Judgements";
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类2
class NotesState extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{	
	    OptionsState.instance.openSub('NotesSubState');		    	    			
    }
    
    private override function updateDisplay():String
	{
		return "Note RGB Option";
	}
}

class NoteSkin extends Option
{
    public static var chooseNum:Int;
    
	public function new(desc:String)
	{
		super();
		chooseNum = 0;
		OptionsHelpers.setNoteSkin();		
			description = desc;
	}

	override function left()
	{
		chooseNum--;
		
     	OptionsHelpers.changeNoteSkin();
		display = updateDisplay();
    }

	override function right()
	{
		chooseNum++;
		
        OptionsHelpers.changeNoteSkin();
		display = updateDisplay();
    }
    
    override function change()
	{OptionsState.instance.changeNoteSkin();        
    }
    
	override function getValue():String
	{
		return "Current Noteskin: < " + ClientPrefs.data.noteSkin + " >";
	}
}

class NoteRGB extends Option
{
	public function new(desc:String)
	{
		super();	
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.noteRGB = !ClientPrefs.data.noteRGB;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Note RGB: " + (ClientPrefs.data.noteRGB ? enable_O : disable_O);
	}
}

class SplashSkin extends Option
{
    public static var chooseNum:Int;
    
	public function new(desc:String)
	{
		super();
		chooseNum = 0;
		OptionsHelpers.setSplashSkin();
		description = desc;
	}

	override function left()
	{		
		chooseNum--;
		
     	OptionsHelpers.changeSplashSkin();
		display = updateDisplay();
    }

	override function right()
	{		
		chooseNum++;
		
        OptionsHelpers.changeSplashSkin();
		display = updateDisplay();
    }

	override function getValue():String
	{
		return "Current SplashSkin: < " + ClientPrefs.data.splashSkin + " >";
	}
}

class SplashRGB extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{	
		ClientPrefs.data.splashRGB = !ClientPrefs.data.splashRGB;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Splash RGB: " + (ClientPrefs.data.splashRGB ? enable_O : disable_O);
	}
}

class HitSoundType extends Option
{
    public static var chooseNum:Int;
	public function new(desc:String)
	{
		super();
		description = desc;
		OptionsHelpers.setHitSoundType();
	}
	
	override function right()
	{		
		chooseNum++;        
		display = updateDisplay();		
	}

	override function left()
	{
		chooseNum--;        
		display = updateDisplay();	
    }
    
    override function change()
	{
        OptionsHelpers.changeHitSoundType();
    }
    
    private override function updateDisplay():String
	{	    
		return "HitSound Type: < " + ClientPrefs.data.hitsoundType + " >";
	}
}

class HitSound extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}
	
	override function right()
	{
		ClientPrefs.data.hitsoundVolume += 0.1;
		if (ClientPrefs.data.hitsoundVolume > 1)
			ClientPrefs.data.hitsoundVolume = 1;
		ClientPrefs.data.hitsoundVolume = FlxMath.roundDecimal(ClientPrefs.data.hitsoundVolume, 1);
        if (ClientPrefs.data.hitsoundType == ClientPrefs.defaultData.hitsoundType) FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);
		else FlxG.sound.play(Paths.sound('hitsounds/' + ClientPrefs.data.hitsoundType), ClientPrefs.data.hitsoundVolume);
	}

	override function left()
	{
		ClientPrefs.data.hitsoundVolume -= 0.1;
		if (ClientPrefs.data.hitsoundVolume < 0)
			ClientPrefs.data.hitsoundVolume = 0;
		ClientPrefs.data.hitsoundVolume = FlxMath.roundDecimal(ClientPrefs.data.hitsoundVolume, 1);
        if (ClientPrefs.data.hitsoundType == ClientPrefs.defaultData.hitsoundType) FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);
		else FlxG.sound.play(Paths.sound('hitsounds/' + ClientPrefs.data.hitsoundType), ClientPrefs.data.hitsoundVolume);
    }
    
    private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.hitsoundVolume * 100;
		return "HitSound volume: < " + data + "% >";
	}
}

class CamZoom extends Option
{
	public function new(desc:String)
	{
		super();
        description = desc;
	}

	override function press()
	{
		ClientPrefs.data.camZooms = !ClientPrefs.data.camZooms;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Camera Zooming: " + (ClientPrefs.data.camZooms ? enable_O : disable_O);
	}
}

class ScoreZoom extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.scoreZoom = !ClientPrefs.data.scoreZoom;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Score Beat: " + (ClientPrefs.data.scoreZoom ? enable_O : disable_O);
	}
}

class KeyboardDisplayOption  extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	override function press()
	{						
		var num:Int = 9;	
		OptionsState.instance.selectedCatIndex = num;
		OptionsState.instance.switchCat(OptionsState.instance.options[num], false);
		
    }

	private override function updateDisplay():String
	{
		return "Keyboard Display";
	}
}

class JudgementCounter extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.judgementCounter = !ClientPrefs.data.judgementCounter;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Judgement Counter: " + (ClientPrefs.data.judgementCounter ? 'Show' : 'Hide');
	}
}

class HideHud extends Option
{
	public function new(desc:String)
	{
		super();        
		description = desc;

	}

	override function press()
	{//if (OptionsState.onPlayState)
		//	return;
		ClientPrefs.data.hideHud = !ClientPrefs.data.hideHud;

		if (Type.getClass(FlxG.state) == PlayState){

		/*PlayState.instance.healthBarBG.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.healthBar.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.healthBarWN.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.healthStrips.visible  = !ClientPrefs.data.hideHud;
		PlayState.instance.iconP1.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.iconP2.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.songTxt.visible = !(ClientPrefs.data.hideHud || !ClientPrefs.data.songNameDisplay);
		PlayState.instance.scoreTxt.visible = (!ClientPrefs.data.hideHud && !PlayState.instance.cpuControlled);

		PlayState.instance.judgementCounter.visible = (ClientPrefs.data.showJudgement && !ClientPrefs.data.hideHud && !PlayState.instance.cpuControlled);

		if(!ClientPrefs.data.hideHud)
			for (helem in [PlayState.instance.healthBar, PlayState.instance.iconP1, PlayState.instance.iconP2, PlayState.instance.healthBarWN, PlayState.instance.healthBarBG, PlayState.instance.healthStrips]) {
				if (helem != null) {
					helem.visible = ClientPrefs.data.visibleHealthbar;
			}  
		}*/

	    }
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "HUD: " + (ClientPrefs.data.hideHud ? 'Hide' : 'Show');
	}
}

class HideOppStrums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.opponentStrums = !ClientPrefs.data.opponentStrums;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Opponent Strums: " + (!ClientPrefs.data.opponentStrums ? 'Hide' : 'Show');
	}
}

class ShowComboNum extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.showComboNum = !ClientPrefs.data.showComboNum;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Combo Sprite: " + (ClientPrefs.data.showComboNum ? 'Show' : 'Hide');
	}
}

class ComboColor extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	override function press()
	{
		ClientPrefs.data.comboColor = !ClientPrefs.data.comboColor;
		display = updateDisplay();
	}
	
	private override function updateDisplay():String
	{
		return "Combe Color: " + (ClientPrefs.data.comboColor ? enable_O : disable_O);
	}
}

class ComboOffset extends Option
{
	public function new(desc:String)
	{
		super();
        description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.comboOffsetFix = !ClientPrefs.data.comboOffsetFix;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Combo Offset Fix: " + (ClientPrefs.data.comboOffsetFix ? enable_O : disable_O);
	}
}

class ShowRating extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.showRating = !ClientPrefs.data.showRating;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Rating Sprite: " + (ClientPrefs.data.showRating ? 'Show' : 'Hide');
	}
}

class ShowSplashes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{ClientPrefs.data.showSplash = !ClientPrefs.data.showSplash;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Splash: " + (ClientPrefs.data.showSplash ? 'Show' : 'Hide');
	} 
}

class SplashAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right()
	{
		ClientPrefs.data.splashAlpha += 0.1;
		if (ClientPrefs.data.splashAlpha > 1)
			ClientPrefs.data.splashAlpha = 1;
		
		ClientPrefs.data.splashAlpha = FlxMath.roundDecimal(ClientPrefs.data.splashAlpha, 1);	
    }

	override function left()
	{
		ClientPrefs.data.splashAlpha -= 0.1;

		if (ClientPrefs.data.splashAlpha < 0)
			ClientPrefs.data.splashAlpha = 0;
		
		ClientPrefs.data.splashAlpha = FlxMath.roundDecimal(ClientPrefs.data.splashAlpha, 1);
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.splashAlpha * 100;
		return "Splash Alpha: < " + data + "% >";
	}
}

class HealthBarAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right()
	{
		ClientPrefs.data.healthBarAlpha += 0.1;
		if (ClientPrefs.data.healthBarAlpha > 1)
			ClientPrefs.data.healthBarAlpha = 1;
		ClientPrefs.data.healthBarAlpha = FlxMath.roundDecimal(ClientPrefs.data.healthBarAlpha, 1);
		
		if (Type.getClass(FlxG.state) == PlayState){
		/*PlayState.instance.healthBarBG.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBar.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBarWN.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthStrips.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP1.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP2.alpha = ClientPrefs.data.healthBarAlpha;*/
		}
    }

	override function left()
	{
		ClientPrefs.data.healthBarAlpha -= 0.1;
		if (ClientPrefs.data.healthBarAlpha < 0)
			ClientPrefs.data.healthBarAlpha = 0;
		ClientPrefs.data.healthBarAlpha = FlxMath.roundDecimal(ClientPrefs.data.healthBarAlpha, 1);
		
		if (Type.getClass(FlxG.state) == PlayState){
		/*PlayState.instance.healthBarBG.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBar.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBarWN.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthStrips.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP1.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP2.alpha = ClientPrefs.data.healthBarAlpha;*/
		}
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.healthBarAlpha * 100;
		return "Healthbar Alpha: < " + data + "% >";
	}
}

class HealthBarVersion extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{ClientPrefs.data.oldHealthBarVersion = !ClientPrefs.data.oldHealthBarVersion;
		display = updateDisplay();
    }
    
    override function right()
	{left();
    }

	private override function updateDisplay():String
	{
		return "HealthBar Version: < " + (ClientPrefs.data.oldHealthBarVersion ? '0.6.X' : '0.7.X') +' >';
	} 
}

class TimeBarType extends Option
{
    public static var chooseNum:Int;
	public function new(desc:String)
	{
		super();
        description = desc;
        OptionsHelpers.setTimeBarType();
	}

	override function left()
	{
		chooseNum--;
		display = updateDisplay();				
    }

	override function right()
	{   
	    chooseNum++;        
		display = updateDisplay();				
    }
    
    override function change()
	{
        OptionsHelpers.changeTimeBarType();
    }
	override function getValue():String
	{
		return "Time bar type: < " + ClientPrefs.data.timeBarType + " >";
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类3
class HscriptVersion extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{ClientPrefs.data.oldHscriptVersion = !ClientPrefs.data.oldHscriptVersion;
		display = updateDisplay();
    }
    
    override function right()
	{left();
    }

	private override function updateDisplay():String
	{
		return "Runhaxecode Version: < " + (ClientPrefs.data.oldHscriptVersion ? 'HScript' : 'Sscript') + ' >';
	} 
}

class PauseMusic extends Option
{
    public static var chooseNum:Int;
	public function new(desc:String)
	{
		super();
		description = desc;
		OptionsHelpers.setPauseMusicType();
	}

	override function left()
	{
	    chooseNum--;
	    OptionsHelpers.changePauseMusicType();
    }

	override function right()
	{
	    chooseNum++;
	    OptionsHelpers.changePauseMusicType();
    }

	private override function updateDisplay():String
	{
		return "Pause Music: < " + ClientPrefs.data.pauseMusic + " >";
	}
}

class PauseButton extends Option
{
    public static var chooseNum:Int;
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.pauseButton = !ClientPrefs.data.pauseButton;
		display = updateDisplay();
    }
    
	private override function updateDisplay():String
	{
		return "Pause Button: < " + (ClientPrefs.data.pauseButton ? enable_O : disable_O) + " >";
	}
}

#if CHECK_FOR_UPDATES
class CheckForUpdates extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.checkForUpdates = !ClientPrefs.data.checkForUpdates;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Check for Updates: " + (ClientPrefs.data.checkForUpdates ? enable_O : disable_O);
	}
}
#end

#if desktop
class DiscordRPC extends Option
{
	public function new(desc:String)
	{
		super();
	}

	override function press()
	{
		
		ClientPrefs.data.discordRPC = !ClientPrefs.data.discordRPC;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Discord Rich Presence: " + (ClientPrefs.data.discordRPC ? enable_O : disable_O);
	}
}
#end

class GameOverVibration extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.gameOverVibration = !ClientPrefs.data.gameOverVibration;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Game Over Vibration: " + (ClientPrefs.data.gameOverVibration ? enable_O : disable_O);
	}
}

class FilesCheck extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.filesCheck = !ClientPrefs.data.filesCheck;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Files setup: " + (ClientPrefs.data.filesCheck ? enable_O : disable_O);
	}
}

class ScreenSaver extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.screensaver = !ClientPrefs.data.screensaver;
		display = updateDisplay();
    }
	
	override function change()
	{
	    lime.system.System.allowScreenTimeout = ClientPrefs.data.screensaver;
	}

	private override function updateDisplay():String
	{
		return "Screen Saver: " + (ClientPrefs.data.screensaver ? enable_O : disable_O);
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类4
class PlayOpponent extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.playOpponent = !ClientPrefs.data.playOpponent;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Play Opponent: " + (ClientPrefs.data.playOpponent ? enable_O : disable_O);
	}
}

class OpponentCodeFix extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.opponentCodeFix = !ClientPrefs.data.opponentCodeFix;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Opponent Code Fix: " + (ClientPrefs.data.opponentCodeFix ? enable_O : disable_O);
	}
}

class BotOpponentFix extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.botOpponentFix = !ClientPrefs.data.botOpponentFix;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Bot Opponent Fix: " + (ClientPrefs.data.botOpponentFix ? enable_O : disable_O);
	}

}

class HealthDrainOPPO extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.HealthDrainOPPO = !ClientPrefs.data.HealthDrainOPPO;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Health Drain: " + (ClientPrefs.data.HealthDrainOPPO ? enable_O : disable_O);
	}
}

class HealthDrainOPPOMult extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
		ClientPrefs.data.HealthDrainOPPOMult -= 0.1;
		if (ClientPrefs.data.HealthDrainOPPOMult < 0) ClientPrefs.data.HealthDrainOPPOMult = 0;
		ClientPrefs.data.HealthDrainOPPOMult = FlxMath.roundDecimal(ClientPrefs.data.HealthDrainOPPOMult, 1);
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.HealthDrainOPPOMult += 0.1;
		if (ClientPrefs.data.HealthDrainOPPOMult > 1) ClientPrefs.data.HealthDrainOPPOMult = 1;
		ClientPrefs.data.HealthDrainOPPOMult = FlxMath.roundDecimal(ClientPrefs.data.HealthDrainOPPOMult, 1);
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.HealthDrainOPPOMult * 100;
		return "Health Drain multipler: < " + data + "% >";
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类5
class CustomFadeType extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
	    if (ClientPrefs.data.CustomFade == 'Move')
		    ClientPrefs.data.CustomFade = 'Alpha';
		else ClientPrefs.data.CustomFade = 'Move';
		display = updateDisplay();
    }

	override function right()
	{
	    left();
	}

	private override function updateDisplay():String
	{
		return "Custom Fade Type: < " + ClientPrefs.data.CustomFade + " >";
	}
}


class CustomFadeSound extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right()
	{
		ClientPrefs.data.CustomFadeSound += 0.1;
		if (ClientPrefs.data.CustomFadeSound > 1)
			ClientPrefs.data.CustomFadeSound = 1;
		ClientPrefs.data.CustomFadeSound = FlxMath.roundDecimal(ClientPrefs.data.CustomFadeSound, 1);
		display = updateDisplay();
    }

	override function left()
	{
		ClientPrefs.data.CustomFadeSound -= 0.1;

		if (ClientPrefs.data.CustomFadeSound < 0)
			ClientPrefs.data.CustomFadeSound = 0;
		ClientPrefs.data.CustomFadeSound = FlxMath.roundDecimal(ClientPrefs.data.CustomFadeSound, 1);
		display = updateDisplay();	
    }

	private override function updateDisplay():String
	{		    
	    var data:Float = ClientPrefs.data.CustomFadeSound * 100;
		return "Custom Fade Sound: < " + data + "% >";
	}
}

class CustomFadeText extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
	    ClientPrefs.data.CustomFadeText = !ClientPrefs.data.CustomFadeText;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Custom Fade Text: " + (ClientPrefs.data.CustomFadeText ? enable_O : disable_O);
	}
}

class SkipTitleVideo extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.skipTitleVideo = !ClientPrefs.data.skipTitleVideo;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Skip Intro Video: " + (ClientPrefs.data.skipTitleVideo ? enable_O : disable_O);
	}
}

class FreeplayStateVersion extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{	    
		ClientPrefs.data.freeplayOld = !ClientPrefs.data.freeplayOld;
		display = updateDisplay();
    }

	override function right()
	{
	    left();
	}

	private override function updateDisplay():String
	{
		return "FreePlay Base: < " + (ClientPrefs.data.freeplayOld ? 'Psych' : 'NovaFlare') + " >";
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类6

class KeyboardControls extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{	
	    OptionsState.instance.openSub('ControlsSubState');		    
	    			
    }
    
    private override function updateDisplay():String
	{
		return "Keyboard Controls";
	}
}

class AndroidControls extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{		
		OptionsState.instance.openSub('MobileControl');		    		
    }
    
    private override function updateDisplay():String
	{
		return "Mobile Controls";
	}
}

class ExtraControls extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{		
		OptionsState.instance.openSub('MobileExtraControl');		
    }
    
    private override function updateDisplay():String
	{
		return "Extra Controls";
	}
}

class ExtraControlsNum extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
	}

	override function right()
	{
		ClientPrefs.data.extraKey += 1;
		if (ClientPrefs.data.extraKey > 4)
			ClientPrefs.data.extraKey = 4;
		display = updateDisplay();
    }

	override function left()
	{
		ClientPrefs.data.extraKey -= 1;

		if (ClientPrefs.data.extraKey < 0)
			ClientPrefs.data.extraKey = 0;
		display = updateDisplay();	
    }

	private override function updateDisplay():String
	{
		return "Mobile Extra Controls: < " + ClientPrefs.data.extraKey + " key >";
	}	
}

class MoblieControl extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function press()
	{
		ClientPrefs.data.needMobileControl = !ClientPrefs.data.needMobileControl;
		display = updateDisplay();
    }
    
    override function change(){
        OptionsState.instance.controlCheck();        
    }
    
	private override function updateDisplay():String
	{
		return "Mobile Control: " + (ClientPrefs.data.needMobileControl ? enable_O : disable_O);
	}
}

class ControlsAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right()
	{
		ClientPrefs.data.controlsAlpha += 0.1;
		if (ClientPrefs.data.controlsAlpha > 1)
			ClientPrefs.data.controlsAlpha = 1;
		ClientPrefs.data.controlsAlpha = FlxMath.roundDecimal(ClientPrefs.data.controlsAlpha, 1);
		display = updateDisplay();
    }

	override function left()
	{
		ClientPrefs.data.controlsAlpha -= 0.1;

		if (ClientPrefs.data.controlsAlpha < 0)
			ClientPrefs.data.controlsAlpha = 0;
		ClientPrefs.data.controlsAlpha = FlxMath.roundDecimal(ClientPrefs.data.controlsAlpha, 1);
			
		display = updateDisplay();	
    }
     
    override function change(){
        if (Type.getClass(FlxG.state) == OptionsState)
            OptionsState.instance.changeControlAlpha();
        else 
            OptionsSubstate.instance.changeControlAlpha();
    }

	private override function updateDisplay():String
	{	   
	    var data:Float = ClientPrefs.data.controlsAlpha * 100;
		return "Mobile Controls Alpha: < " + data + "% >";
	}
}

class PlayControlsAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right()
	{
		ClientPrefs.data.playControlsAlpha += 0.1;
		if (ClientPrefs.data.playControlsAlpha > 1)
			ClientPrefs.data.playControlsAlpha = 1;
		ClientPrefs.data.playControlsAlpha = FlxMath.roundDecimal(ClientPrefs.data.playControlsAlpha, 1);
		display = updateDisplay();
    }

	override function left()
	{
		ClientPrefs.data.playControlsAlpha -= 0.1;

		if (ClientPrefs.data.playControlsAlpha < 0)
			ClientPrefs.data.playControlsAlpha = 0;
		ClientPrefs.data.playControlsAlpha = FlxMath.roundDecimal(ClientPrefs.data.playControlsAlpha, 1);
		display = updateDisplay();	
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.playControlsAlpha * 100;
		return "Mobile Play Controls Alpha: < " + data + "% >";
	}
}

class HitboxLocation extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function left()
	{
		if (ClientPrefs.data.hitboxLocation == 'Bottom')
		    ClientPrefs.data.hitboxLocation = 'Top';
		else ClientPrefs.data.hitboxLocation = 'Bottom';
		display = updateDisplay();
    }

	override function right()
	{
		left();
    }       

	private override function updateDisplay():String
	{
		return "Hitbox Extra Controls Location: < " + ClientPrefs.data.hitboxLocation + " >";
	}
}

class HitboxSkin extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function left()
	{
		if (ClientPrefs.data.hitboxSkin == 'Classic')
		    ClientPrefs.data.hitboxSkin = 'New';
		else ClientPrefs.data.hitboxSkin = 'Classic';
		display = updateDisplay();
    }

	override function right()
	{
		left();
    }       

	private override function updateDisplay():String
	{
		return "Hitbox Skin: < " + ClientPrefs.data.hitboxSkin + " >";
	}
}

class ControlColor extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function press()
	{
		ClientPrefs.data.dynamicColors = !ClientPrefs.data.dynamicColors;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Controls color as note: " + (ClientPrefs.data.dynamicColors ? enable_O : disable_O);
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类7
/*
class Language extends Option
{
    
	public function new(desc:String)
	{
		super();
		description = desc;
	}		

	override function left()
	{
		ClientPrefs.data.language--;
		if (ClientPrefs.data.language < 0)
		ClientPrefs.data.language = OptionsHelpers.languageArray.length -1;
		
		FlxTransitionableState.skipNextTransIn = true;
		MusicBeatState.switchState(new options.OptionsState()); //reset substate for real
		
    }

	override function right()
	{
		ClientPrefs.data.language++;
		if (ClientPrefs.data.language > OptionsHelpers.languageArray.length -1)
		ClientPrefs.data.language = 0;
		
		FlxTransitionableState.skipNextTransIn = true;
		MusicBeatState.switchState(new options.OptionsState());	//reset substate for real		
		        
    }

	private override function updateDisplay():String
	{
		return "Language: < " + OptionsHelpers.languageArray[ClientPrefs.data.language] + " >";
	}
}
*/

class FPSCap extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}
	
	override function left()
	{
		if (ClientPrefs.data.framerate <= 24)
			ClientPrefs.data.framerate = 24;
		else
			ClientPrefs.data.framerate = ClientPrefs.data.framerate - 1;
    }
    
    override function right()
	{
		if (ClientPrefs.data.framerate >= 290)
		{
			ClientPrefs.data.framerate = 290;            
		}
		else
			ClientPrefs.data.framerate = ClientPrefs.data.framerate + 1;		  
    }

    override function change()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}
	
	private override function updateDisplay():String
	{
		return "FPS Cap: < " + ClientPrefs.data.framerate + " >";
	}
}

class ColorblindMode extends Option
{
    
	public function new(desc:String)
	{
		super();
		description = desc;
	}		

	override function left()
	{
		ClientPrefs.data.colorblindMode--;
		if (ClientPrefs.data.colorblindMode < 0)
		ClientPrefs.data.colorblindMode = OptionsHelpers.colorblindFilterArray.length -1;		
		ColorblindFilter.UpdateColors();
    }

	override function right()
	{
		ClientPrefs.data.colorblindMode++;
		if (ClientPrefs.data.colorblindMode > OptionsHelpers.colorblindFilterArray.length -1)
		ClientPrefs.data.colorblindMode = 0;
	    ColorblindFilter.UpdateColors();
    }	
	
	override function change()
	{
	    ColorblindFilter.UpdateColors();
	}

	private override function updateDisplay():String
	{
		return "ColorblindFilter: < " + OptionsHelpers.colorblindFilterArray[ClientPrefs.data.colorblindMode] + " >";
	}
}

class Shaders extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.shaders = !ClientPrefs.data.shaders;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Shaders: " + (ClientPrefs.data.shaders ? enable_O : disable_O);
	}
}

class GPUcache extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.cacheOnGPU = !ClientPrefs.data.cacheOnGPU;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "GPU Cache: " + (ClientPrefs.data.cacheOnGPU ? enable_O : disable_O);
	}
}

class LoadingScreen extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}	

	override function press()
	{
		ClientPrefs.data.loadingScreen = !ClientPrefs.data.loadingScreen;
		display = updateDisplay();		
	}
	
	private override function updateDisplay():String
	{
		return "Loading Screen: " + (ClientPrefs.data.loadingScreen ? enable_O : disable_O);
	}
}

class FlashingLights extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.flashing = !ClientPrefs.data.flashing;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Flashing Lights: " + (ClientPrefs.data.flashing ? enable_O : disable_O);
	}
}

class QualityLow extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{     		
        ClientPrefs.data.lowQuality = !ClientPrefs.data.lowQuality;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Low Quality: " + (ClientPrefs.data.lowQuality ? enable_O : disable_O);
	} 
}

class GameQuality extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
        ClientPrefs.data.gameQuality -= 1;
        if (ClientPrefs.data.gameQuality < 0) ClientPrefs.data.gameQuality = 0;
		display = updateDisplay();
    }
    
    override function right()
	{
        ClientPrefs.data.gameQuality += 1;
        if (ClientPrefs.data.gameQuality > 3) ClientPrefs.data.gameQuality = 3;
		display = updateDisplay();
    }
    
    override function change()
	{
	    switch (ClientPrefs.data.gameQuality)
	    {
	        case 0:
	            FlxG.game.stage.quality = openfl.display.StageQuality.LOW;
	        case 1:
	            FlxG.game.stage.quality = openfl.display.StageQuality.HIGH;
	        case 2:
	            FlxG.game.stage.quality = openfl.display.StageQuality.MEDIUM;
	        case 3:
	            FlxG.game.stage.quality = openfl.display.StageQuality.BEST;
	    }
	}

	private override function updateDisplay():String
	{
		return "Game Quality: " + OptionsHelpers.qualityArray[ClientPrefs.data.gameQuality];
	} 
}

class Antialiasing extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		
		ClientPrefs.data.antialiasing = !ClientPrefs.data.antialiasing;
            
		display = updateDisplay();
    }	    
	
	private override function updateDisplay():String
	{
		return "Antialiasing: " + (ClientPrefs.data.antialiasing ? enable_O : disable_O);
	}
}

class AutoPause extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.autoPause = !ClientPrefs.data.autoPause;
        FlxG.autoPause = ClientPrefs.data.autoPause;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "AutoPause: " + (ClientPrefs.data.autoPause ? enable_O : disable_O);
	} 
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类8
class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{	
		ClientPrefs.data.showFPS = !ClientPrefs.data.showFPS;							
		display = updateDisplay();
    }
    
    override function change()
	{	
	    if(Main.fpsVar != null)
		Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter: " + (ClientPrefs.data.showFPS ? enable_O : disable_O);
	} 
}

class FPSRainbowOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
        ClientPrefs.data.rainbowFPS = !ClientPrefs.data.rainbowFPS;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "FPS Color Indication: " + (ClientPrefs.data.rainbowFPS ? enable_O : disable_O);
	} 
}

class FPSScale extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.FPSScale -= 0.05;
		if (ClientPrefs.data.FPSScale < 0.3)
			ClientPrefs.data.FPSScale = 0.3;
		ClientPrefs.data.FPSScale = FlxMath.roundDecimal(ClientPrefs.data.FPSScale, 2);
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.FPSScale += 0.05;
		if (ClientPrefs.data.FPSScale > 3)
			ClientPrefs.data.FPSScale = 3;
		ClientPrefs.data.FPSScale = FlxMath.roundDecimal(ClientPrefs.data.FPSScale, 2);
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.FPSScale * 100;
		return "FPS Counter Scale: < " + data + "% >";
	}
	
	override function change()
	{	
	    if(Main.fpsVar != null) {
		    Main.fpsVar.scaleX = Main.fpsVar.scaleY = ClientPrefs.data.FPSScale;	
		}
	}
}

class ExtraOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
	    ClientPrefs.data.showExtra = !ClientPrefs.data.showExtra;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Extra Counter: " + (ClientPrefs.data.showExtra ? enable_O : disable_O);
	} 
	
	override function change()
	{	
	    if(Main.fpsVar != null)
		FPS.change();
	}
}

class MEMType extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
	    ClientPrefs.data.memoryType--;
	    if (ClientPrefs.data.memoryType < 0) ClientPrefs.data.memoryType = OptionsHelpers.memoryTypeArray.length - 1;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.memoryType++;
		if (ClientPrefs.data.memoryType > OptionsHelpers.memoryTypeArray.length - 1) ClientPrefs.data.memoryType = 0;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Memory Data: < " + OptionsHelpers.memoryTypeArray[ClientPrefs.data.memoryType] + " >";
	} 
}

class WaterMarkOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{	
		ClientPrefs.data.showWatermark = !ClientPrefs.data.showWatermark;
		
		
					
		display = updateDisplay();
    }
    
    override function change()
	{	
	    if(Main.watermark != null)
		Main.watermark.visible = ClientPrefs.data.showWatermark;
	}

	private override function updateDisplay():String
	{
		return "Watermark: " + (ClientPrefs.data.showWatermark ? 'Show' : 'Hide');
	} 
}

class WaterMarkScale extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.WatermarkScale -= 0.05;
		if (ClientPrefs.data.WatermarkScale < 0.3)
			ClientPrefs.data.WatermarkScale = 0.3;
		ClientPrefs.data.WatermarkScale = FlxMath.roundDecimal(ClientPrefs.data.WatermarkScale, 2);
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.WatermarkScale += 0.05;
		if (ClientPrefs.data.WatermarkScale > 3)
			ClientPrefs.data.WatermarkScale = 3;
		ClientPrefs.data.WatermarkScale = FlxMath.roundDecimal(ClientPrefs.data.WatermarkScale, 2);
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.WatermarkScale * 100;
		return "Watermark Scale: < " + data + "% >";
	}
	
	override function change()
	{
	    if(Main.watermark != null) {
		    Main.watermark.scaleX = Main.watermark.scaleY = ClientPrefs.data.WatermarkScale;		    
		}
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类9
class FrameOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.safeFrames -= 0.1 ;
		if (ClientPrefs.data.safeFrames < 0)
			ClientPrefs.data.safeFrames = 0;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.safeFrames += 0.1;
		if (ClientPrefs.data.safeFrames > 10)
			ClientPrefs.data.safeFrames = 10;
		display = updateDisplay();
    }

	override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.safeFrames = 10;
	}

	private override function updateDisplay():String
	{
		return "safeFrames: < " + ClientPrefs.data.safeFrames + " >";
	}
}

class RatingOffset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.ratingOffset--;
		if (ClientPrefs.data.ratingOffset < -30)
			ClientPrefs.data.ratingOffset = -30;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.ratingOffset++;
		if (ClientPrefs.data.ratingOffset > 30)
			ClientPrefs.data.ratingOffset = 30;
		display = updateDisplay();
    }

	private override function updateDisplay():String
	{
		return "Rating Offset: < " + ClientPrefs.data.ratingOffset + " >";
	}		
}

class MarvelousMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.marvelousWindow--;
		if (ClientPrefs.data.marvelousWindow < 0)
			ClientPrefs.data.marvelousWindow = 0;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.marvelousWindow++;
		if (ClientPrefs.data.marvelousWindow > 166)
			ClientPrefs.data.marvelousWindow = 166;
		display = updateDisplay();
    }

	override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.marvelousWindow = 45;
	}

	private override function updateDisplay():String
	{
		return "Marvelous Hit Window: < " + ClientPrefs.data.marvelousWindow + MS_O + " >";
	}
}

class SickMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.sickWindow--;
		if (ClientPrefs.data.sickWindow < 0)
			ClientPrefs.data.sickWindow = 166;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.sickWindow++;
		if (ClientPrefs.data.sickWindow > 166)
			ClientPrefs.data.sickWindow = 166;
		display = updateDisplay();
    }

	override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.sickWindow = 45;
	}

	private override function updateDisplay():String
	{
		return "Sick Hit Window: < " + ClientPrefs.data.sickWindow + MS_O + " >";
	}
}

class GoodMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.goodWindow--;
		if (ClientPrefs.data.goodWindow < 0)
			ClientPrefs.data.goodWindow = 0;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.goodWindow++;
		if (ClientPrefs.data.goodWindow > 166)
			ClientPrefs.data.goodWindow = 166;
		display = updateDisplay();
    }

	override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.goodWindow = 90;
	}

	private override function updateDisplay():String
	{
		return "Good Hit Window: < " + ClientPrefs.data.goodWindow + MS_O + " >";
	}
}

class BadMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptType = true;
	}

	override function left()
	{
		ClientPrefs.data.badWindow--;
		if (ClientPrefs.data.badWindow < 0)
			ClientPrefs.data.badWindow = 0;
		display = updateDisplay();
    }

	override function right()
	{
		ClientPrefs.data.badWindow++;
		if (ClientPrefs.data.badWindow > 166)
			ClientPrefs.data.badWindow = 166;
		display = updateDisplay();
    }

	override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.badWindow = 135;
	}

	private override function updateDisplay():String
	{
		return "Bad Hit Window: < " + ClientPrefs.data.badWindow + MS_O + " >";
	}
}

class MarvelousRating extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.marvelousRating = !ClientPrefs.data.marvelousRating;
		display = updateDisplay();
    }
       
	private override function updateDisplay():String
	{
		return "Marvelous Rating: " + (ClientPrefs.data.marvelousRating ? enable_O : disable_O);
	}
}

class MarvelousSprite extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
		ClientPrefs.data.marvelousSprite = !ClientPrefs.data.marvelousSprite;
		display = updateDisplay();
    }    
    
    override function right()
	{
		left();
    }    

	private override function updateDisplay():String
	{
		return "Marvelous Sprite: < " + (ClientPrefs.data.marvelousSprite ? 'marvelous' : 'sick') + ' >';
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//大类10

class KeyboardDisplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function press()
	{
		ClientPrefs.data.keyboardDisplay = !ClientPrefs.data.keyboardDisplay;
		display = updateDisplay();
    }
       
	private override function updateDisplay():String
	{
		return "Display: " + (ClientPrefs.data.keyboardDisplay ? enable_O : disable_O);
	}
}


class KeyboardAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right()
	{
		ClientPrefs.data.keyboardAlpha += 0.1;
		if (ClientPrefs.data.keyboardAlpha > 1)
			ClientPrefs.data.keyboardAlpha = 1;
		
		ClientPrefs.data.keyboardAlpha = FlxMath.roundDecimal(ClientPrefs.data.keyboardAlpha, 1);	
    }

	override function left()
	{
		ClientPrefs.data.keyboardAlpha -= 0.1;

		if (ClientPrefs.data.keyboardAlpha < 0)
			ClientPrefs.data.keyboardAlpha = 0;
		
		ClientPrefs.data.keyboardAlpha = FlxMath.roundDecimal(ClientPrefs.data.keyboardAlpha, 1);
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.keyboardAlpha * 100;
		return "Alpha: < " + data + "% >";
	}
}

class KeyboardTime extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right()
	{
		ClientPrefs.data.keyboardTime += 10;
		if (ClientPrefs.data.keyboardTime > 1000)
			ClientPrefs.data.keyboardTime = 1000;
		
		ClientPrefs.data.keyboardTime = FlxMath.roundDecimal(ClientPrefs.data.keyboardTime, 1);	
    }

	override function left()
	{
		ClientPrefs.data.keyboardTime -= 10;

		if (ClientPrefs.data.keyboardTime < 0)
			ClientPrefs.data.keyboardTime = 0;
		
		ClientPrefs.data.keyboardTime = FlxMath.roundDecimal(ClientPrefs.data.keyboardTime, 1);
    }

	private override function updateDisplay():String
	{
	    var data:Float = ClientPrefs.data.keyboardTime;
		return "Sustain time: < " + data + " MS >";
	}
}

class KeyboardBGColor extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
        ClientPrefs.data.keyboardBGColor -= 1;
        if (ClientPrefs.data.keyboardBGColor < 0) ClientPrefs.data.keyboardBGColor = 0;
		display = updateDisplay();
    }
    
    override function right()
	{
        ClientPrefs.data.keyboardBGColor += 1;
        if (ClientPrefs.data.keyboardBGColor > OptionsHelpers.colorStingArray.length - 1) ClientPrefs.data.keyboardBGColor = OptionsHelpers.colorStingArray.length - 1;
		display = updateDisplay();
    }
    
	private override function updateDisplay():String
	{
		return "BG Color: " + OptionsHelpers.colorStingArray[ClientPrefs.data.keyboardBGColor];
	} 
}

class KeyboardTextColor extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	override function left()
	{
        ClientPrefs.data.keyboardTextColor -= 1;
        if (ClientPrefs.data.keyboardTextColor < 0) ClientPrefs.data.keyboardTextColor = 0;
		display = updateDisplay();
    }
    
    override function right()
	{
        ClientPrefs.data.keyboardTextColor += 1;
        if (ClientPrefs.data.keyboardTextColor > OptionsHelpers.colorStingArray.length - 1) ClientPrefs.data.keyboardTextColor = OptionsHelpers.colorStingArray.length - 1;
		display = updateDisplay();
    }
    
	private override function updateDisplay():String
	{
		return "Text Color: " + OptionsHelpers.colorStingArray[ClientPrefs.data.keyboardTextColor];
	} 
}
