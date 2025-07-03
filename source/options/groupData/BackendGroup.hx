package options.groupData;

class BackendGroup extends OptionCata {
    public function new(X:Float, Y:Float, width:Float, height:Float)
	{
        super(X, Y, width, height);

        var option:Option = new Option(this, TITLE, Language.get('Backend', 'op'), Language.get('Backend', 'opSub'));
        addOption(option);

        /////--Gameplaybackend--\\\\\

        var option:Option = new Option(this, TEXT, Language.get('Gameplaybackend', 'op'), Language.get('Gameplaybackend', 'opSub'));
		addOption(option);

        var option:Option = new Option(this, 'replayBot', BOOL, Language.get('aureplayBottoMap', 'op'), Language.get('aureplayBottoMap', 'opSub'));
        addOption(option);

        var option:Option = new Option(this, 'fixLNL', BOOL, Language.get('fixLNL', 'op'), Language.get('fixLNL', 'opSub'));
        addOption(option);

        var MainMusicArray:Array<String> = ['None', 'freakyMenu'];
        for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'music/Main Screen', true)) {
            for (file in FileSystem.readDirectory(folder)) {
                if (file.endsWith('.ogg')) {
                    MainMusicArray.push(file.replace('.ogg', ''));
                }
            }
        }

        var option:Option = new Option(this, 'mainMusic', STRING, Language.get('mainMusic', 'op'), Language.get('mainMusic', 'opSub'), MainMusicArray);
        addOption(option);

        var OptionMusicArray:Array<String> = ['None'];
        for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'music/Options', true)) {
            for (file in FileSystem.readDirectory(folder)) {
                if (file.endsWith('.ogg')) {
                    OptionMusicArray.push(file.replace('.ogg', ''));
                }
            }
        }

        var option:Option = new Option(this, 'optionMusic', STRING, Language.get('optionMusic', 'op'), Language.get('optionMusic', 'opSub'), OptionMusicArray);
        addOption(option);

        var PauseMusicArray:Array<String> = ['None', 'Breakfast', 'Tea Time'];
        for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'music/Pause', true)) {
            for (file in FileSystem.readDirectory(folder)) {
                if (file.endsWith('.ogg')) {
                    PauseMusicArray.push(file.replace('.ogg', ''));
                }
            }
        }

        var option:Option = new Option(this, 'pauseMusic', STRING, Language.get('pauseMusic', 'op'), Language.get('pauseMusic', 'opSub'), PauseMusicArray);
        addOption(option);

        var hitsoundArray:Array<String> = ['Default'];

        for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'sounds/hitsounds/')){
			for (file in FileSystem.readDirectory(folder))
			{
				if (file.endsWith('.ogg'))
					hitsoundArray.push(file.replace('.ogg', ''));
			}
        }

        var option:Option = new Option(this, 'hitSoundType', STRING, Language.get('hitSoundType', 'op'), Language.get('hitSoundType', 'opSub'));
        addOption(option);

        option.onChange = function() {
        if (ClientPrefs.data.hitsoundType == ClientPrefs.defaultData.hitsoundType)
            {
                FlxG.sound.play(Paths.sound(ClientPrefs.data.hitsoundType));
            }
            else
            {
                FlxG.sound.play(Paths.sound('hitsounds/' + ClientPrefs.data.hitsoundType));
            }
        };

        var option:Option = new Option(this, 'hitSoundVolume', FLOAT, Language.get('hitSoundVolume', 'op'), Language.get('hitSoundVolume', 'opSub'), [0, 1, 1]);
        addOption(option);

        option.onChange = function() {
            FlxG.sound.play(Paths.sound('hitsounds/' + ClientPrefs.data.hitsoundType), ClientPrefs.data.hitSoundVolume); = ClientPrefs.data.hitSoundVolume;
        };

        var option:Option = new Option(this, 'oldHscriptVersion', BOOL, Language.get('oldHscriptVersion', 'op'), Language.get('oldHscriptVersion', 'opSub'));
        addOption(option);
    }
}