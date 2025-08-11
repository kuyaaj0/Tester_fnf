package objects.state.optionState;

import psychlua.HScript;
import objects.state.optionState.Option;

class HScriptGroup extends OptionCata {
	public var hscriptArray:Array<HScript>;

	public function new(X:Float, Y:Float, width:Float, height:Float, path:String) {
		super(X, Y, width, height);
		hscriptArray = new Array<HScript>();
		for(fn in FileSystem.readDirectory(path)) {
			if(fn.toLowerCase().endsWith('.hx')) {
				var sc:HScript = new HScript(path + fn, this);
				sc.set("Option", Option);
				for(construct in Type.getEnumConstructs(OptionType)) {
					sc.set(construct, Reflect.getProperty(OptionType, construct));
				}
				sc.execute();
				sc.call("onCreate");
				hscriptArray.push(sc);
			}
		}
	}

	override function destroy():Void {
		if(hscriptArray.length > 0) {
			var i:Int = -1;
			while(i++ < hscriptArray.length - 1) {
				final sc = hscriptArray[i];
				sc.call("onDestroy");
				sc.destroy();
			}
		}
		hscriptArray = null;

		super.destroy();
	}
}