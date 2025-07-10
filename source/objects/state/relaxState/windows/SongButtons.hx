package objects.state.relaxState.windows;

import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.input.mouse.FlxMouseEvent;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
import backend.relax.GetInit;
import backend.relax.GetInit.SongLists;

class SongButtons extends FlxSpriteGroup
{
    public var songData:SongLists;
    public var buttonHeight:Float = 28;
    public var buttonWidth:Float;
    public var padding:Float = 5;
    public var cornerRadius:Float = 8;
    
    private var isDragging:Bool = false;
    private var dragOffsetY:Float = 0;
    private var minY:Float = 0;
    private var maxY:Float = 0;
    private var dragStartPos:FlxPoint = FlxPoint.get();
    private var hasDragged:Bool = false;
    private var dragThreshold:Float = 5;
    
    public var onSongSelected:Int->SongInfo->Void;
    
    public function new(List:Int = 0, x:Float = 0, y:Float = 0)
    {
        super(x, y);
        buttonWidth = FlxG.width * 0.3 - 10;
        songData = GetInit.getList(List);
        
        createSongButtons();
        setupDrag();
    }
    
    private function createSongButtons()
    {
        var yPosition:Float = 0;
        
        for (i in 0...songData.list.length)
        {
            var songInfo = songData.list[i];
            var button = new FlxButton(0, yPosition);
            
            button.width = buttonWidth;
            button.height = buttonHeight;
            button.makeGraphic(Std.int(buttonWidth), Std.int(buttonHeight), 0x00FFFFFF, true);
            
            FlxSpriteUtil.drawRoundRect(
                button,
                0, 0,
                buttonWidth, buttonHeight,
                cornerRadius, cornerRadius,
                0xFF3A3A3A,
                { thickness: 2, color: 0xFF5A5A5A }
            );
            
            var text = new FlxText(10, 4, buttonWidth - 20, 
                '${songInfo.name} - ${songInfo.writer}', 12);
            text.color = 0xFFFFFFFF;
            text.alignment = CENTER;
            
            add(button);
            add(text);
            yPosition += buttonHeight + padding;
        }
        
        calculateDragBounds();
    }
    
    private function setupDrag()
    {
        FlxMouseEvent.add(this, 
            function(s) {
                var mousePos = FlxG.mouse.getScreenPosition();
                if (clipRect != null && !clipRect.containsPoint(mousePos)) return;
                
                dragStartPos.set(FlxG.mouse.x, FlxG.mouse.y);
                hasDragged = false;
                isDragging = true;
                dragOffsetY = FlxG.mouse.y - this.y;
            },
            null,
            function(s) { 
                isDragging = false;
                if (!hasDragged) {
                    var mousePos = FlxG.mouse.getScreenPosition();
                    if (clipRect != null && !clipRect.containsPoint(mousePos)) return;
                    
                    var clickedButton = getClickedButton();
                    if (clickedButton != null) {
                        var index = getButtonIndex(clickedButton);
                        if (index != -1) {
                            PlayListWindow.instance.handleDoubleClickCheck();
                            PlayListWindow.instance.nowChoose[1] = index;
                            
                            if (onSongSelected != null) {
                                onSongSelected(index, songData.list[index]);
                            }
                        }
                    }
                }
            },
            function(s) {
                if (isDragging) {
                    if (!hasDragged) {
                        var dx = FlxG.mouse.x - dragStartPos.x;
                        var dy = FlxG.mouse.y - dragStartPos.y;
                        if (dx * dx + dy * dy > dragThreshold * dragThreshold) {
                            hasDragged = true;
                        }
                    }
                    var newY = FlxG.mouse.y - dragOffsetY;
                    this.y = Math.max(minY, Math.min(maxY, newY));
                    
                    if (clipRect != null) {
                        clipRect.y = this.y;
                    }
                }
            }
        );
    }
    private function getClickedButton():FlxButton
    {
        for (member in members) {
            if (Std.isOfType(member, FlxButton)) {
                var button:FlxButton = cast member;
                if (button.overlapsPoint(FlxG.mouse.getPosition())) {
                    return button;
                }
            }
        }
        return null;
    }
    
    private function getButtonIndex(button:FlxButton):Int
    {
        for (i in 0...members.length) {
            if (members[i] == button) {
                return i;
            }
        }
        return -1;
    }
    
    private function calculateDragBounds()
    {
        var totalHeight = (buttonHeight + padding) * songData.list.length - padding;
        var screenHeight = FlxG.height;
        minY = screenHeight - totalHeight - this.y - 20;
        maxY = this.y + 20;
    }
    
    public function reload(List:Int = 0, newX:Float, newY:Float)
    {
        this.x = newX;
        this.y = newY;
        clear();
        songData = GetInit.getList(List);
        createSongButtons();
        calculateDragBounds();
    }
}