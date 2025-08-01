package psychlua.stages;

/**
 * @see 自个查
 * 总之就是先这样再那样最后那样就没了（
 */
class HScriptSubstate extends MusicBeatSubstate {
	public static final sign:String = "substates";

	public var scriptName:String;
	public var scriptData:Null<Dynamic>;

	private var hscriptArray:Array<HScript>;

	public function new(name:String, ?data:Null<Dynamic>) {
		hscriptArray = new Array<HScript>();

		this.scriptName = name;
		this.scriptData = data;
		#if MODS_ALLOWED
		var paths:Array<String> = [];

		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), "stageScripts/" + sign + "/"))
			if(FileSystem.exists(folder) && FileSystem.isDirectory(folder)) paths.push(folder);

		Iris.error = function(content:Dynamic, ?pos:haxe.PosInfos) {
			lime.app.Application.current.window.alert('[${pos.fileName}:${pos.lineNumber}]: ' + Std.string(content), "Substate HScript Error");
			HScript.originError(content, pos);
		};
		for(path in paths) {
			for(fn in FileSystem.readDirectory(path)) {
				if(Path.extension(fn) == "hx") {
					var sc:HScript = new HScript(path + fn, this);
					sc.set("MusicBeatState", MusicBeatState);
					sc.set("MusicBeatSubstate", MusicBeatSubstate);
					sc.execute();
					hscriptArray.push(sc);
				}
			}
		}
		Iris.error = HScript.originError;
		#end

		super();
	}

	override function create() {
		callOnScript("onCreate");
		super.create();
		callOnScript("onCreatePost");
	}

	override function update(elapsed:Float) {
		callOnScript("onUpdate", [elapsed]);
		super.update(elapsed);
		callOnScript("onUpdatePost");
	}

	override function draw() {
		callOnScript("onDraw");
		super.draw();
		callOnScript("onDrawPost");
	}

	override function openSubState(SubState:FlxSubState) {
		callOnScript("onOpenSubState", [SubState]);
		super.openSubState(SubState);
		callOnScript("onOpenSubStatePost", [SubState]);
	}

	override function closeSubState() {
		callOnScript("onCloseSubState");
		super.closeSubState();
		callOnScript("onCloseSubStatePost");
	}

	override function close() {
		callOnScript("onClose");
		super.close();
		callOnScript("onClosePost");
	}

	override function onFocusLost() {
		callOnScript("onFocusLost");
		super.onFocusLost();
	}

	override function onFocus() {
		callOnScript("onFocus");
		super.onFocus();
	}

	override function onResize(Width:Int, Height:Int) {
		callOnScript("onResize", [Width, Height]);
		super.onResize(Width, Height);
	}

	override function stepHit() {
		callOnScript("onStepHit");
		super.stepHit();
	}

	override function beatHit() {
		callOnScript("onBeatHit");
		super.beatHit();
	}

	override function sectionHit() {
		callOnScript("onSectionHit");
		super.beatHit();
	}

	override function destroy() {
		if(hscriptArray != null && hscriptArray.length > 0) for(sc in hscriptArray) {
			if(sc != null) {
				if(sc.exists("onDestroy")) sc.call("onDestroy");
				sc.destroy();
			}
		}

		super.destroy();
	}

	public function callOnScript(name:String, ?args:Array<Dynamic>):Dynamic {
		if(hscriptArray != null && hscriptArray.length > 0) for(sc in hscriptArray) {
			if(sc != null && sc.exists(name)) {
				sc.call(name, args);
			}
		}

		return null;
	}
}