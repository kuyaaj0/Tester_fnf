package options.group;

class WatermarkGroup
{
	static public function add(follow:OptionBG)
	{
		var option:Option = new Option(Language.get('Watermark'), TITLE);
		follow.addOption(option);

		var reset:ResetRect = new ResetRect(450, 20, follow);
		follow.add(reset);

		///////////////////////////////

		var option:Option = new Option(Language.get('FPScounter'), TEXT);
		follow.addOption(option);

		var option:Option = new Option(Language.get('showFPS'), 'showFPS', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('showExtra'), 'showExtra', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('rainbowFPS'), 'rainbowFPS', BOOL);
		follow.addOption(option);

		var memoryTypeArray:Array<String> = ["Usage", "Reserved", "Current", "Large"];

		var option:Option = new Option(Language.get('memoryType'), 'memoryType', STRING, memoryTypeArray);
		follow.addOption(option);

		var option:Option = new Option(Language.get('FPSScale'), 'FPSScale', FLOAT, 0, 5, 1);
		follow.addOption(option);

		var option:Option = new Option(Language.get('Watermark'), TEXT);
		follow.addOption(option);

		var option:Option = new Option(Language.get('showWatermark'), 'showWatermark', BOOL);
		follow.addOption(option);

		var option:Option = new Option(Language.get('WatermarkScale'), 'WatermarkScale', FLOAT, 0, 5, 1);
		follow.addOption(option);
	}
}
