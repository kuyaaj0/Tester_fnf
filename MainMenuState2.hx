import states.MainMenuState;

import tjson.TJSON;



var state = FlxG.state;

var bg;

var textList = [];

var boppers = [];



function onCreate()

{

	state.camFollow.screenCenter();



	var version1 = state.members[state.members.length-1];

	var version2 = state.members[state.members.length-2];

	state.remove(version1, true);

	state.remove(version2, true);



	bg = new FlxSprite(0, 0, Paths.image("scrollingBG"));

	bg.antialiasing = ClientPrefs.data.antialiasing;

	bg.velocity.set(-40, -40);

	state.add(bg);



	var characterData = TJSON.parse(Paths.getTextFromFile("images/mainmenu/characters.json"));

	var curCharacter = FlxG.random.int(0, characterData.characters.length - 1);

	if (characterData.force != null && characterData.force >= 0 && characterData.force < characterData.characters.length)

		curCharacter = characterData.force;

	var curCharacterData = characterData.characters[curCharacter];



	for (c in curCharacterData)

	{

		var sprite = new FlxSprite(c.spritePos[0], c.spritePos[1]);

		sprite.antialiasing = ClientPrefs.data.antialiasing;

		sprite.frames = Paths.getSparrowAtlas("mainmenu/characters/"+c.atlas);

		sprite.animation.addByPrefix("idle", c.prefix, 24, c.looped);

		sprite.animation.play("idle");

		sprite.scale.set(c.scale[0], c.scale[1]);

		sprite.updateHitbox();

		if (!c.looped)

			boppers.push(sprite);

		state.add(sprite);

	}



	var leftSide = new FlxSprite(-60, 0, Paths.image('Credits_LeftSide'));

	leftSide.antialiasing = ClientPrefs.data.antialiasing;

	state.add(leftSide);



	var logo = new FlxSprite(40, -40);

	logo.frames = Paths.getSparrowAtlas('logoBumpin');

	logo.antialiasing = ClientPrefs.data.antialiasing;

	logo.scale.set(0.5, 0.5);

	logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);

	logo.animation.play('bump');

	logo.updateHitbox();

	state.add(logo);



	var i = 0;

	for (m in state.optionShit)

	{

		var fancyText = m.split("_");

		for (j in 0...fancyText.length)

			fancyText[j] = fancyText[j].substr(0, 1).toUpperCase() + fancyText[j].substr(1);



		var txt = new FlxText(50, 370 + (i * 40), 0, fancyText.join(" "));

		txt.setFormat(Paths.font('riffic.ttf'), 27, FlxColor.WHITE, "left");

		txt.antialiasing = ClientPrefs.data.antialiasing;

		txt.setBorderStyle(OUTLINE, 0xFFFF7CFF, 2);

		textList.push(txt);

		state.add(txt);

		i++;

	}



	state.add(version1);

	state.add(version2);



	onChangeItem();

}



function onUpdate(elapsed)

{

	if (bg.x < -200)

		bg.x += 200;

	if (bg.y < -200)

		bg.y += 200;

}



function onBeatHit()

{

	for (b in boppers)

		b.animation.play("idle", true);

}



function onChangeItem()

{

	state.camFollow.screenCenter();



	var i = 0;

	for (button in textList)

	{

		if (i == MainMenuState.curSelected)

			button.borderColor = 0xFFFFCFFF;

		else

			button.borderColor = 0xFFFF7CFF;

		i++;

	}

}
