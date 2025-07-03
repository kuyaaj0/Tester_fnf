package objects.state.optionState.backend;

enum OptionType
{
	BOOL;

	INT;
	FLOAT;
	PERCENT;

	STRING;

	STATE;
	SUBSTATE;

	TITLE;
	TEXT;
	
	//特殊化处理
	NOTE;
	SPLASH;
}

class Option extends FlxSpriteGroup
{
	public var saveHeight:Int = 0;

	public var onChange:Void->Void = null;
	public var type:OptionType = BOOL;

	public var variable:String = null; // Variable from ClientPrefs.hx
	public var defaultValue:Dynamic = null; //获取出来的数值
	public var description:String = '';
	public var tips:String;

	//STRING
	public var strGroup:Array<String> = null;
	public var curOption:Int = 0;

	//INT FLOAT PERCENT;
	public var minValue:Float = 0;
	public var maxValue:Float = 0;
	public var decimals:Int = 0;
	public var exatraDisplay:String = '';

	public var follow:OptionCata;

	/////////////////////////////////////////////

	public function new(variable:String = '', type:OptionType = BOOL, description:String, tips:String, ?data:Dynamic)
	{
		super();

		this.variable = variable;
		this.type = type;
		this.description = description;
		this.tips = tips;
		if (this.type != STATE && variable != '')
			this.defaultValue = Reflect.getProperty(ClientPrefs.data, variable);

		switch (type)
		{
			case BOOL:
				if (defaultValue == null)
					defaultValue = false;
			case INT, FLOAT, PERCENT:
				if (defaultValue == null)
					defaultValue = 0;
			case STRING:
				if (data.length > 0)
					defaultValue = data[0];
				if (defaultValue == null)
					defaultValue = '';
			default:
		}

		switch (type)
		{
			case BOOL:
				//bool没有特殊需要加的

			case INT:
				this.minValue = data[0];
				this.maxValue = data[1];
				if (data[2] != null) this.exatraDisplay = data[2];

			case FLOAT:
				this.minValue = data[0];
				this.maxValue = data[1];
				this.decimals = data[2];
				if (data[3] != null) this.exatraDisplay = data[3];

			case PERCENT:
				this.decimals = data[0];
				this.decimals = data[1];
				if (data[2] != null) this.exatraDisplay = data[2];
				
			case STRING:
				this.strGroup = data;
			default:
		}

		//if (getValue() == null && variable != '' && type != STATE)
		//	setValue(defaultValue);

		switch (type)
		{
			case STRING:
				var num:Int = strGroup.indexOf(getValue());
				if (num > -1)
					curOption = num; //定位当前选择
			default:
		}

		switch (type)
		{
			case BOOL:
				addBool();
			case INT, FLOAT, PERCENT:
				addData();
			case STRING:
				addString();
			case TEXT:
				addText();
			case TITLE:
				addTitle();
			case STATE:
				addState();
			default:
		}
	}



	function addBool()
	{
		
	}



	function addData()
	{
		
	}

	function addString()
	{
		
	}

	function addText()
	{
		
	}

	function addTitle()
	{
		
	}

	function addState()
	{
		
	}

	public function change()
	{
		if (onChange != null)
			onChange();
	}

	dynamic public function getValue():Dynamic
	{
		var value = Reflect.getProperty(ClientPrefs.data, variable);
		return value;
	}

	dynamic public function setValue(value:Dynamic)
	{
		return Reflect.setProperty(ClientPrefs.data, variable, value);
	}

	public function resetData()
	{
		if (variable == '' || type == STATE)
			return;
		Reflect.setProperty(ClientPrefs.data, variable, Reflect.getProperty(ClientPrefs.defaultData, variable));
		defaultValue = Reflect.getProperty(ClientPrefs.defaultData, variable);
		switch (type)
		{
			
			default:
		}
	}
}
