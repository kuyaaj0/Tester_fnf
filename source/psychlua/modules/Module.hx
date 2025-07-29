package psychlua.modules;

import objects.Note;
import psychlua.LuaUtils;

class Module {
	public var game:Dynamic;
	public var IDs:String;

	public var active:Bool;

	public function new(IDs:String) {
		this.IDs = IDs;
		this.active = true;
	}

	public function onCreate() {
		// triggered when the hscript file is started, some variables weren't created yet
	}

	public function onCreatePost() {
		// end of "create"
	}

	public function onDestroy() {
		// triggered when the haxe file is ended (Song fade out finished)
	}

	public function onFocus() {
		// triggered when the game's window gains focus, some variables weren't updated yet
	}

	public function onFocusPost() {
		// end of "onFocus"
	}

	public function onFocusLost() {
		// triggered when the game's window looses focus, some variables weren't updated yet
	}

	public function onFocusLostPost() {
		// end of "onFocusLost"
	}

	// Gameplay/Song interactions
	public function onSectionHit() {
		// triggered after it goes to the next section
	}

	public function onBeatHit() {
		// triggered 4 times per section
	}

	public function onStepHit() {
		// triggered 16 times per section
	}

	public function onUpdate(elapsed:Float) {
		// start of "update", some variables weren't updated yet
	}

	public function onUpdatePost(elapsed:Float) {
		// end of "update"
	}

	public function onStartCountdown():Dynamic {
		// countdown started, duh
		// return Function_Stop if you want to stop the countdown from happening (Can be used to trigger dialogues and stuff! You can trigger the countdown with startCountdown())
		return LuaUtils.Function_Continue;
	}

	public function onCountdownStarted() {
		// called AFTER countdown started, if you want to stop it from starting, refer to the previous function (onStartCountdown)
	}

	public function onCountdownTick(tick:Countdown, counter:Int) {
		/**
		switch(tick) {
			case Countdown.THREE:
				//counter equals to 0
			case Countdown.TWO:
				//counter equals to 1
			case Countdown.ONE:
				//counter equals to 2
			case Countdown.GO:
				//counter equals to 3
			case Countdown.START:
				//counter equals to 4, this has no visual indication or anything, it's pretty much at nearly the exact time the song starts playing
		}
		**/
	}

	public function onSpawnNote(note:Note) {
		// Read the function name and you will understand what it does
	}

	public function onSongStart() {
		// Inst and Vocals start playing, songPosition = 0
	}

	public function onEndSong():Dynamic {
		// song ended/starting transition (Will be delayed if you're unlocking an achievement)
		// return Function_Stop to stop the song from ending for playing a cutscene or something.
		return LuaUtils.Function_Continue;
	}


	// Substate interactions
	public function onPause():Dynamic {
		// Called when you press Pause while not on a cutscene/etc
		// return Function_Stop if you want to stop the player from pausing the game
		return LuaUtils.Function_Continue;
	}

	public function onResume() {
		// Called after the game has been resumed from a pause (WARNING: Not necessarily from the pause screen, but most likely is!!!)
	}

	public function onGameOver():Dynamic {
		// You died! Called every single frame your health is lower (or equal to) zero
		// return Function_Stop if you want to stop the player from going into the game over screen
		return LuaUtils.Function_Continue;
	}

	public function onGameOverConfirm(retry:Bool) {
		// Called when you Press Enter/Esc on Game Over
		// If you've pressed Esc, value "retry" will be false
	}


	// Dialogue (When a dialogue is finished, it calls startCountdown again)
	public function onNextDialogue(line:Int) {
		// triggered when the next dialogue line starts, dialogue line starts with 1
	}

	public function onSkipDialogue(line:Int) {
		// triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
	}


	// Key Press/Release
	public function onKeyPress(key:Int) {
		// key can be: 0 - left, 1 - down, 2 - up, 3 - right
	}

	public function onKeyRelease(key:Int) {
		// key can be: 0 - left, 1 - down, 2 - up, 3 - right
	}

	public function onGhostTap(key:Int) {
		// key can be: 0 - left, 1 - down, 2 - up, 3 - right
	}

	// Note miss/hit
	public function goodNoteHitPre(note:Note) {
		// Function called when you hit a note (***before*** note hit calculations)
	}

	public function opponentNoteHitPre(note:Note) {
		// Works the same as goodNoteHitPre, but for Opponent's notes being hit
	}

	public function goodNoteHit(note:Note) {
		// Function called when you hit a note (***after*** note hit calculations)
	}

	public function opponentNoteHit(note:Note) {
		// Works the same as goodNoteHit, but for Opponent's notes being hit
	}

	public function noteMissPress(direction:Int) {
		// Called after the note press miss calculations
		// Player pressed a button, but there was no note to hit (ghost miss)
	}

	public function noteMiss(note:Note) {
		// Called after the note miss calculations
		// Player missed a note by letting it go offscreen
	}


	// Other function hooks
	public function onRecalculateRating():Dynamic {
		// return Function_Stop if you want to do your own rating calculation,
		// use setRatingPercent() to set the number on the calculation and setRatingString() to set the funny rating name
		// NOTE: THIS IS CALLED BEFORE THE CALCULATION!!!
		return LuaUtils.Function_Continue;
	}

	public function onMoveCamera(focus:String) {
		/*if (focus == 'boyfriend')
		{
			// called when the camera focus on boyfriend
		}
		else if (focus == 'dad')
		{
			// called when the camera focus on dad
		}*/
	}


	// Event notes hooks
	public function onEvent(name:String, value1:String, value2:String, strumTime:Float) {
		// event note triggered
		// triggerEvent() does not call this function!!

		// print('Event triggered: ', name, value1, value2, strumTime);
	}

	public function onEventPushed(name:String, value1:String, value2:String, strumTime:Float) {
		// Called for every event note, recommended to precache assets
	}

	public function eventEarlyTrigger(name:String) {
		/*
		Here's a port of the Kill Henchmen early trigger:

		if (name == 'Kill Henchmen')
			return 280;

		This makes the "Kill Henchmen" event be triggered 280 miliseconds earlier so that the kill sound is perfectly timed with the song
		*/

		// write your shit under this line, the new return value will override the ones hardcoded on the engine
	}
}