package psychlua.modules;

import psychlua.HScript;
import haxe.io.Path;
import crowplexus.iris.Iris;
#if MODS_ALLOWED
import backend.Mods;
#end

class ModuleHandler {
	private static var moduleArray:Array<Module> = [];
	private static final supportExtension:Array<String> = ["hxc", "hxs"];

	public static function init() {
		moduleArray = [];

		#if MODS_ALLOWED
		var paths:Array<String> = [];

		var topMod:Null<String> = null;
		var list = Mods.parseList()?.enabled;
		if(list != null && list[0] != null) {
			topMod = list[0];
		}
		var globalPath:String = #if mobile mobile.backend.SUtil.getStorageDirectory() + #end "mods/modules/";
		var topPath:String = #if mobile mobile.backend.SUtil.getStorageDirectory() + #end "mods/" + topMod + "/modules/";
		if(FileSystem.exists(globalPath) && FileSystem.isDirectory(globalPath)) paths.push(globalPath);
		if(FileSystem.exists(topPath) && FileSystem.isDirectory(topPath)) paths.push(topPath);

		Iris.error = function(content:Dynamic, ?pos:haxe.PosInfos) {
			lime.app.Application.current.window.alert('[${pos.fileName}:${pos.lineNumber}]: ' + Std.string(content), "Module Error");
			HScript.originError(content, pos);
		};
		for(path in paths) {
			for(fn in FileSystem.readDirectory(path)) {
				if(supportExtension.contains(Path.extension(fn))) {
					var sc:ModuleHScript = new ModuleHScript(path + fn);
					sc.execute();
				}
			}
		}
		Iris.error = HScript.originError;
		#end

		for(fp in ScriptedModule.__sc_scriptClassLists()) {
			var instance:Module = ScriptedModule.createScriptClassInstance(fp);
			instance.onCreate();
			moduleArray.push(instance);
		}

		globalHandler();
	}

	static var sbCallbacks:Map<String, haxe.Constraints.Function>;
	private static function globalHandler() {
		if(sbCallbacks != null) {
			for(k=>v in sbCallbacks) {
				switch(k) {
					case "onStateSwitch":
						FlxG.signals.preStateSwitch.remove(v);
					case "onStateSwitchPost":
						FlxG.signals.postStateSwitch.remove(v);
					case "onStateCreate":
						FlxG.signals.preStateCreate.remove(v);
					case "onGameResized":
						FlxG.signals.gameResized.remove(v);
					case "onGameReset":
						FlxG.signals.preGameReset.remove(v);
					case "onGameResetPost":
						FlxG.signals.postGameReset.remove(v);
					case "onGameStart":
						FlxG.signals.preGameStart.remove(v);
					case "onGameStartPost":
						FlxG.signals.postGameStart.remove(v);
					case "onUpdate":
						FlxG.signals.preUpdate.remove(v);
					case "onUpdatePost":
						FlxG.signals.postUpdate.remove(v);
					case "onDraw":
						FlxG.signals.preDraw.remove(v);
					case "onDrawPost":
						FlxG.signals.postDraw.remove(v);
					case "onFocusGained":
						FlxG.signals.focusGained.remove(v);
					case "onFocusLost":
						FlxG.signals.focusLost.remove(v);
					case _:
				}
			}
		}

		sbCallbacks = new Map();
		for(id in ["onStateSwitch", "onStateSwitchPost", "onStateCreate", "onGameResized", "onGameReset", "onGameResetPost", "onGameStart", "onGameStartPost", "onUpdate", "onUpdatePost", "onDraw", "onDrawPost", "onFocusGained", "onFocusLost"]) {
			switch(id) {
				case "onStateSwitch":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.preStateSwitch.add(sbCallbacks.get(id));
				case "onStateSwitchPost":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.postStateSwitch.add(sbCallbacks.get(id));
				case "onStateCreate":
					sbCallbacks.set(id, function(state:FlxState) {
						ModuleHandler.call(id, [state]);
					});
					FlxG.signals.preStateCreate.add(sbCallbacks.get(id));
				case "onGameResized":
					sbCallbacks.set(id, function(width:Int, height:Int) {
						ModuleHandler.call(id, [width, height]);
					});
					FlxG.signals.gameResized.add(sbCallbacks.get(id));
				case "onGameReset":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.preGameReset.add(sbCallbacks.get(id));
				case "onGameResetPost":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.postGameReset.add(sbCallbacks.get(id));
				case "onGameStart":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.preGameStart.add(sbCallbacks.get(id));
				case "onGameStartPost":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.postGameStart.add(sbCallbacks.get(id));
				case "onUpdate":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id, [FlxG.elapsed]);
					});
					FlxG.signals.preUpdate.add(sbCallbacks.get(id));
				case "onUpdatePost":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id, [FlxG.elapsed]);
					});
					FlxG.signals.postUpdate.add(sbCallbacks.get(id));
				case "onDraw":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.preDraw.add(sbCallbacks.get(id));
				case "onDrawPost":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.postDraw.add(sbCallbacks.get(id));
				case "onFocusGained":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.focusGained.add(sbCallbacks.get(id));
				case "onFocusLost":
					sbCallbacks.set(id, function() {
						ModuleHandler.call(id);
					});
					FlxG.signals.focusLost.add(sbCallbacks.get(id));
				case _:
			}
		}
	}

	public static function call(name:String, ?args:Array<Dynamic>):Dynamic {
		for(module in moduleArray) {
			if(module.active) {
				var func:Dynamic = Reflect.getProperty(module, name);
				if(Reflect.isFunction(func)) {
					var result:Dynamic = Reflect.callMethod(null, func, args ?? []);
				}
			}
		}

		return null;
	}
}

class ModuleHScript extends HScript {
	public function new(path:String) {
		super(path);
		interp.allowScriptClass = interp.allowScriptEnum = true;
	}

	override function preset(parent:Dynamic) {
		set("ScriptedModule", ScriptedModule);
		set("Applicaton", lime.app.Application);
		super.preset(parent);
	}
}