package psychlua.modules;

import psychlua.HScript;
import haxe.io.Path;
import crowplexus.iris.Iris;

class ModuleHandler {
	private static var moduleArray:Array<Module> = [];
	private static final supportExtension:Array<String> = ["hxc", "hxs"];

	public static function init() {
		#if MODS_ALLOWED
		var directoryPath:String = #if mobile mobile.backend.SUtil.getStorageDirectory() + #end "mods/modules/";
		if(FileSystem.exists(directoryPath) && FileSystem.isDirectory(directoryPath)) {
			var files:Array<String> = FileSystem.readDirectory(directoryPath);
			Iris.error = function(content:Dynamic, pos: haxe.Posinfos) {
				lime.app.Application.current.window.alert(Std.string(content), '[${pos.fileName}:${pos.lineNumber}]');
				HScript.originError(content, pos);
			};

			for(fn in files) {
				if(supportExtension.contains(Path.extension(fn))) {
					var sc:ModuleHScript = new ModuleHScript(directoryPath + fn);
					sc.execute();
				}
			}

			Iris.error = HScript.originError;
		}
		#end

		for(fp in ScriptedModule.__sc_scriptClassLists()) {
			var instance:Module = ScriptedModule.createScriptClassInstance(fp);
			moduleArray.push(instance);
		}
	}

	public static function call(name:String, ?args:Array<Dynamic>):Dynamic {
		for(module in moduleArray) {
			if(module.active) {
				var func:Dynamic = Reflect.getProperty(module, name);
				if(Reflect.isFunction(func)) {
					var result:Dynamic = Reflect.callMethod(null, func, args ?? []);
					if(result == LuaUtils.Function_Stop) return result;
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
		super.preset(parent);
	}
}