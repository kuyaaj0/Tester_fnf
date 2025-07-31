package psychlua.stages;

class GlobalHandler {
	private static var grp:Array<HScript>;

	public static function init() {
		grp = [];

		#if MODS_ALLOWED
		var paths:Array<String> = [];

		var globalPath:String = Paths.mods("stageScripts/globals/");
		var topPath:String = Paths.mods(Mods.currentModDirectory + "/stageScripts/globals/");
		if(FileSystem.exists(globalPath) && FileSystem.isDirectory(globalPath)) paths.push(globalPath);
		if(FileSystem.exists(topPath) && FileSystem.isDirectory(topPath)) paths.push(topPath);

		Iris.error = function(content:Dynamic, ?pos:haxe.PosInfos) {
			lime.app.Application.current.window.alert('[${pos.fileName}:${pos.lineNumber}]: ' + Std.string(content), "Global HScript Error");
			HScript.originError(content, pos);
		};
		for(path in paths) {
			for(fn in FileSystem.readDirectory(path)) {
				if(Path.extension(fn) == "hx") {
					var sc:HScript = new HScript(path + fn);
					sc.execute();
					sc.call("onCreate");
					grp.push(sc);
				}
			}
		}
		Iris.error = HScript.originError;
		#end

		globalHandler();
	}

	static var sbCallbacks:Map<String, haxe.Constraints.Function>;
	private static function globalHandler() {
		if(sbCallbacks != null) {
			for(k=>v in sbCallbacks) {
				switch(k) {
					case "onStateSwitch":
						FlxG.signals.preStateSwitch.remove(cast v);
					case "onStateSwitchPost":
						FlxG.signals.postStateSwitch.remove(cast v);
					case "onStateCreate":
						FlxG.signals.preStateCreate.remove(cast v);
					case "onGameResized":
						FlxG.signals.gameResized.remove(cast v);
					case "onGameReset":
						FlxG.signals.preGameReset.remove(cast v);
					case "onGameResetPost":
						FlxG.signals.postGameReset.remove(cast v);
					case "onGameStart":
						FlxG.signals.preGameStart.remove(cast v);
					case "onGameStartPost":
						FlxG.signals.postGameStart.remove(cast v);
					case "onUpdate":
						FlxG.signals.preUpdate.remove(cast v);
					case "onUpdatePost":
						FlxG.signals.postUpdate.remove(cast v);
					case "onDraw":
						FlxG.signals.preDraw.remove(cast v);
					case "onDrawPost":
						FlxG.signals.postDraw.remove(cast v);
					case "onFocusGained":
						FlxG.signals.focusGained.remove(cast v);
					case "onFocusLost":
						FlxG.signals.focusLost.remove(cast v);
					case _:
				}
			}
		}

		sbCallbacks = new Map();
		for(id in ["onStateSwitch", "onStateSwitchPost", "onStateCreate", "onGameResized", "onGameReset", "onGameResetPost", "onGameStart", "onGameStartPost", "onUpdate", "onUpdatePost", "onDraw", "onDrawPost", "onFocusGained", "onFocusLost"]) {
			switch(id) {
				case "onStateSwitch":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.preStateSwitch.add(cast sbCallbacks.get(id));
				case "onStateSwitchPost":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.postStateSwitch.add(cast sbCallbacks.get(id));
				case "onStateCreate":
					sbCallbacks.set(id, function(state:FlxState) {
						GlobalHandler.call(id, [state]);
					});
					FlxG.signals.preStateCreate.add(cast sbCallbacks.get(id));
				case "onGameResized":
					sbCallbacks.set(id, function(width:Int, height:Int) {
						GlobalHandler.call(id, [width, height]);
					});
					FlxG.signals.gameResized.add(cast sbCallbacks.get(id));
				case "onGameReset":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.preGameReset.add(cast sbCallbacks.get(id));
				case "onGameResetPost":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.postGameReset.add(cast sbCallbacks.get(id));
				case "onGameStart":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.preGameStart.add(cast sbCallbacks.get(id));
				case "onGameStartPost":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.postGameStart.add(cast sbCallbacks.get(id));
				case "onUpdate":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id, [FlxG.elapsed]);
					});
					FlxG.signals.preUpdate.add(cast sbCallbacks.get(id));
				case "onUpdatePost":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id, [FlxG.elapsed]);
					});
					FlxG.signals.postUpdate.add(cast sbCallbacks.get(id));
				case "onDraw":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.preDraw.add(cast sbCallbacks.get(id));
				case "onDrawPost":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.postDraw.add(cast sbCallbacks.get(id));
				case "onFocusGained":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.focusGained.add(cast sbCallbacks.get(id));
				case "onFocusLost":
					sbCallbacks.set(id, function() {
						GlobalHandler.call(id);
					});
					FlxG.signals.focusLost.add(cast sbCallbacks.get(id));
				case _:
			}
		}
	}

	public static function call(funcName:String, ?args:Array<Dynamic>):Dynamic {
		if(grp != null && grp.length > 0) {
			for(sc in grp) {
				if(sc != null && sc.exists(funcName)) {
					sc.call(funcName, args);
				}
			}
		}

		return null;
	}
}