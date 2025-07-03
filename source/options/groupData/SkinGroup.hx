package options.groupData;

class SkinGroup extends OptionCata
{
	public function new(X:Float, Y:Float, width:Float, height:Float)
	{
		super(X, Y, width, height);

		var option:Option = new Option(this, TITLE, Language.get('Skin', 'op'), Language.get('Skin', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, TEXT, Language.get('Note', 'op'), Language.get('Note', 'opSub'));
		addOption(option);

		var noteSkins:Array<String> = [];
		if (Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared').length > 0)
			noteSkins = Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared');
		else
			noteSkins = CoolUtil.coolTextFile(Paths.getSharedPath('shared/images/noteSkins/list.txt'));
		if (noteSkins.length > 0)
		{
			noteSkins.insert(0, ClientPrefs.defaultData.noteSkin);

			var option:Option = new Option(this, 'noteSkin', STRING, Language.get('noteSkin', 'op'), Language.get('noteSkin', 'opSub'), noteSkins);
			addOption(option);
		}

		var option:Option = new Option(this, 'noteRGB', BOOL, Language.get('noteRGB', 'op'), Language.get('noteRGB', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'NotesSubState', STATE, Language.get('NotesSubState', 'op'), Language.get('NotesSubState', 'opSub'), 'NotesSubState');
		addOption(option);
		
		/////--Splash--\\\\\

		var option:Option = new Option(this, TEXT, Language.get('Splash', 'op'), Language.get('Splash', 'opSub'));
		addOption(option);

		var noteSplashes:Array<String> = [];
		if (Mods.mergeAllTextsNamed('images/noteSplashes/list.txt', 'shared').length > 0)
			noteSplashes = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt', 'shared');
		else
			noteSplashes = CoolUtil.coolTextFile(Paths.getSharedPath('shared/images/noteSplashes/list.txt'));

		if (noteSplashes.length > 0)
		{
			noteSplashes.insert(0, ClientPrefs.defaultData.splashSkin);

			var option:Option = new Option(this, 'splashSkin', STRING, Language.get('splashSkin', 'op'), Language.get('splashSkin', 'opSub'), noteSplashes);
			addOption(option);
		}

		var option:Option = new Option(this, 'splashRGB', BOOL, Language.get('splashRGB', 'op'), Language.get('splashRGB', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'showSplash', BOOL, Language.get('showSplash', 'op'), Language.get('showSplash', 'opSub'));
		addOption(option);

		var option:Option = new Option(this, 'splashAlpha', FLOAT, Language.get('splashAlpha', 'op'), Language.get('splashAlpha', 'opSub'), [0, 1, 1]);
		addOption(option);
	}
}
