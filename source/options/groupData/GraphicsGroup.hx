package options.groupData;

class GraphicsGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, 'Graphics', TITLE);
		addOption(option);
		
		/////--FPScounter--\\\\\

		var option:Option = new Option(this, 'FPScounter', TEXT);
		addOption(option);

		var option:Option = new Option(this, 'showFPS', BOOL);
		addOption(option);

		var option:Option = new Option(this, 'showExtra', BOOL);
		addOption(option, true);

		var option:Option = new Option(this, 'rainbowFPS', BOOL);
		addOption(option);

		var memoryTypeArray:Array<String> = ["Usage", "Reserved", "Current", "Large"];

		var option:Option = new Option(this, 'memoryType', STRING, memoryTypeArray);
		addOption(option, true);

		var option:Option = new Option(this, 'FPSScale', FLOAT, [0, 5, 1]);
		addOption(option);
		
		/////--Watermark--\\\\\

		var option:Option = new Option(this, 'Watermark', TEXT);
		addOption(option);

		var option:Option = new Option(this, 'showWatermark', BOOL);
		addOption(option);

		var option:Option = new Option(this, 'WatermarkScale', FLOAT, [0, 5, 1]);
		addOption(option);

		changeHeight(0); //初始化真正的height
	}
}
