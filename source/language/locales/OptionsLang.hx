package language.locales;

import haxe.Json;

typedef OptionData =
{
	Reset:String,
	// ==General==\\
	General:String,
	framerate:String,
	language:String,
	colorblindMode:String,
	lowQuality:String,
	gameQuality:String,
	antialiasing:String,
	flashing:String,
	shaders:String,
	cacheOnGPU:String,
	autoPause:String,

	// ==Gameplay==\\
	Gameplay:String,
	////////
	downScroll:String,
	middleScroll:String,
	flipChart:String,
	ghostTapping:String,
	guitarHeroSustains:String,
	noReset:String,
	////////
	Opponent:String,
	////////
	playOpponent:String,
	opponentCodeFix:String,
	botOpponentFix:String,
	HealthDrainOPPO:String,
	HealthDrainOPPOMult:String,

	// ==Backend==\\
	Backend:String,
	Gameplaybackend:String,
	replayBot:String,
	fixLNL:String,
	pauseMusic:String,
	hitsoundType:String,
	hitsoundVolume:String,
	oldHscriptVersion:String,
	pauseButton:String,
	CompulsionPause:String,
	gameOverVibration:String,
	ratingOffset:String,
	NoteOffsetState:String,
	judgement:String,
	safeFrames:String,
	marvelousWindow:String,
	sickWindow:String,
	goodWindow:String,
	badWindow:String,
	marvelousRating:String,
	marvelousSprite:String,
	////////
	Appbackend:String,
	////////
	discordRPC:String,
	checkForUpdates:String,
	screensaver:String,
	filesCheck:String,

	// ==Game UI==\\
	GameUI:String,
	GameUITitle:String,
	////////
	Visble:String,
	////////
	hideHud:String,
	showComboNum:String,
	showRating:String,
	opponentStrums:String,
	judgementCounter:String,
	keyboardDisplay:String,
	////////
	TimeBar:String,
	////////
	timeBarType:String,
	////////
	HealthBar:String,
	healthBarAlpha:String,
	oldHealthBarVersion:String,
	////////
	Combo:String,
	////////
	comboColor:String,
	comboOffsetFix:String,
	////////
	KeyBoard:String,
	////////
	keyboardAlpha:String,
	keyboardTime:String,
	keyboardTimeDisplay:String,
	keyboardBGColor:String,
	keyboardTextColor:String,
	////////
	Camera:String,
	////////
	camZooms:String,
	scoreZoom:String,

	// ==Skin==\\
	Skin:String,
	////////
	Note:String,
	noteSkin:String,
	noteRGB:String,
	NotesSubState:String,
	////////
	Splash:String,
	////////
	splashSkin:String,
	splashRGB:String,
	showSplash:String,
	splashAlpha:String,

	// ==Input==\\
	Input:String,
	////////
	ControlsSubState:String,
	////////
	TouchMain:String,
	////////
	needMobileControl:String,
	controlsAlpha:String,
	////////
	TouchGame:String,
	////////
	MobileControlSelectSubState:String,
	dynamicColors:String,
	hitboxLocation:String,
	playControlsAlpha:String,
	extraKey:String,
	MobileExtraControl:String,

	// ==User Interface==\\
	UserInterface:String,
	UserInterfaceTitle:String,
	////////
	CustomFade:String,
	CustomFadeSound:String,
	CustomFadeText:String,
	skipTitleVideo:String,
	audioDisplayQuality:String,
	audioDisplayUpdate:String,
	freeplayOld:String,
	resultsScreen:String,
	loadingScreen:String,

	// ==Watermark==\\
	Watermark:String,
	////////
	FPScounter:String,
	////////
	showFPS:String,
	showExtra:String,
	rainbowFPS:String,
	memoryType:String,
	FPSScale:String,

	showWatermark:String,
	WatermarkScale:String
}

class OptionsLang
{
	static var data:OptionData;
	static var defaultData:OptionData;

	static public function get(value:String):String
	{
		var getValue:String = Reflect.getProperty(data, value);
		if (getValue == null)
			getValue = Reflect.getProperty(defaultData, value);
		if (getValue == null)
			getValue = value + ' (missed interpret)';
		return getValue;
	}

	static public function updateLang()
	{
		if (FileSystem.exists(Paths.getPath('language') + '/' + 'English' + '/options.json'))
			data = defaultData = Json.parse(Paths.getTextFromFile('language/' + 'English' + '/options.json'));
		if (FileSystem.exists(Paths.getPath('language') + '/' + ClientPrefs.data.language + '/options.json'))
			data = Json.parse(Paths.getTextFromFile('language/' + ClientPrefs.data.language + '/options.json'));
	}
}
