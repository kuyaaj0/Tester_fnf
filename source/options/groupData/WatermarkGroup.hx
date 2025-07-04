package options.groupData;

class WatermarkGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, TITLE, Language.get('Watermark', 'op'), Language.get('Watermark', 'opSub'));
		addOption(option);
		
		/////--FPScounter--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('FPScounter', 'op'), Language.get('FPScounter', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'showFPS', BOOL, Language.get('showFPS', 'op'), Language.get('showFPS', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'showExtra', BOOL, Language.get('showExtra', 'op'), Language.get('showExtra', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'rainbowFPS', BOOL, Language.get('rainbowFPS', 'op'), Language.get('rainbowFPS', 'opSub'));
		addOption(option);

		var memoryTypeArray:Array<String> = ["Usage", "Reserved", "Current", "Large"];

		var option:Option = new Option(this, 'memoryType', STRING, Language.get('memoryType', 'op'), Language.get('memoryType', 'opSub'), memoryTypeArray);
		addOption(option);

		var option:Option = new Option(this, 'FPSScale', FLOAT, Language.get('FPSScale', 'op'), Language.get('FPSScale', 'opSub'), [0, 5, 1]);
		addOption(option);
		
		/////--Watermark--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('Watermark', 'op'), Language.get('Watermark', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'showWatermark', BOOL, Language.get('showWatermark', 'op'), Language.get('showWatermark', 'opSub'));
		addOption(option);

		var option:Option = new Option(Language.get('WatermarkScale'), 'WatermarkScale', FLOAT, 0, 5, 1);
		var option:Option = new Option(this, 'WatermarkScale', FLOAT, Language.get('WatermarkScale', 'op'), Language.get('WatermarkScale', 'opSub'), [0, 5, 1]);
		addOption(option);

		changeHeight(0.0000001); //初始化真正的height
	}
}
