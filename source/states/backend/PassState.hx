package states.backend;

import flixel.FlxGame;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxSave;

import server.online.LoginClient;

class PassState extends FlxState {
    private var username:PsychUIInputText;
    private var password:PsychUIInputText;
    private var submitButton:FlxButton;
    
    private var loginclient:LoginClient;
    
    var save:FlxSave = new FlxSave();
    
    override public function create():Void {
        super.create();
        FlxG.camera.bgColor = FlxColor.GRAY;
        
        loginclient = new LoginClient();
        
        save.bind("MyUserPass");
        
        if(save.data.user != null && save.data.pass != null){
            loginFunc(save.data.user, save.data.pass);
        }
        
        username = new PsychUIInputText(
            FlxG.width / 2 - 150,
            FlxG.height / 2 - 60,
            300,
            "UserName",
            16
            
        );
        username.textObj.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		username.textObj.antialiasing = ClientPrefs.data.antialiasing;
        //username.alignment = CENTER;
        add(username);
        
        password = new PsychUIInputText(
            FlxG.width / 2 - 150,
            FlxG.height / 2,
            300,
            "PassWord",
            16
        );
        //password.alignment = CENTER;
        password.textObj.font = Paths.font(Language.get('fontName', 'ma') + '.ttf');
		password.textObj.antialiasing = ClientPrefs.data.antialiasing;
        add(password);
        
        submitButton = new FlxButton(
            FlxG.width / 2 - 50,
            FlxG.height / 2 + 60,
            "OK",
            onSubmit
        );
        submitButton.setGraphicSize(100, 40);
        submitButton.updateHitbox();
        add(submitButton);
    }
    
    private function onSubmit():Void {
        var user = username.text;
        var pass = password.text;
        save.data.user = user;
        save.data.pass = pass;
        save.flush();
        loginFunc(user, pass);
    }
    
    private function loginFunc(user:String, pass:String):Void{
        loginclient.login(user,pass);

        loginclient.decision = function(response:Dynamic) {

            if (response.message == "Good") {
                if(response.member == 'admin'){
                    FlxG.switchState(new InitState());
                }
            } else if (response.message == "Bad") {
            trace("登录失败: " + response.message);
            } else {
            trace("请求错误: " + response.message);
            }
        };
    }
}