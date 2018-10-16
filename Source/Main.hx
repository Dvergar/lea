package;


import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.display.LineScaleMode;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.Lib;

import motion.Actuate;
import motion.easing.Cubic;



class Tool
{
    static inline public function getTextField(x:Float, y:Float, text:String, size:Int)
    {
        var font = Assets.getFont(Game.FONT);
        var format = new TextFormat(font.fontName);
        format.align = TextFormatAlign.CENTER;
        format.size = size;

        var textField = new TextField();
        textField.defaultTextFormat = format;
        textField.embedFonts = true;
        textField.selectable = false;
        textField.text = text;
        textField.x = x;
        textField.y = y;
        // textField.border = true;

        return textField;
    }
}


interface DataInterface
{
	public var title:String;
	public var words:Array<String>;
}


class OData implements DataInterface
{
	public var title = "Le son O";
	public var words = ["eau", "beau", "moto", "troll", "robot", "zoo", "alors", "chaud", "école", "bateau"];

	public function new() {}
}


class EData implements DataInterface
{
	public var title = "Le son É";
	public var words = ["après", "anniversaire", "beignet", "prairie", "maison", "traîneau", "zèbre", "fête", "chère", "neige"];

	public function new() {}
}


class SonPanel extends Sprite
{
	var data:DataInterface;
    var word:Word;
    var slots:Array<Slot> = new Array();
    var state:State = DEFAULT;

	public function new(data:DataInterface)
	{
		super();

		this.data = data;

		// BACKGROUND
        this.graphics.beginFill(0x9c3848);
        this.graphics.drawRect(0, 0, Main.WINDOW_WIDTH, Main.WINDOW_HEIGHT);
        this.graphics.endFill();

        // WORD
        var wordText = getRandomWord();
        this.word = new Word(wordText);
        this.word.x = Main.WINDOW_WIDTH / 2;
        this.word.y = 200;
        addChild(this.word);

        // SLOTS
        var widthSlot = 140;
        var space = 40;
        var numLetters = wordText.length;
        var widthTotal = (widthSlot + space) * numLetters - space;
        var xSlot = (Main.WINDOW_WIDTH - widthTotal) / 2;

        for(k in 1...(numLetters + 1))
        {
            var slot = new Slot();
            slot.x = xSlot;
            slot.y = 700;
            slots.push(slot);
            addChild(slot);

            xSlot += widthSlot + space;
        }

        // LETTERS
        var lettersPerRow = 6;
        var widthLetter = 134;
        var heightLetter = 147;
        var space = 30;
        var yLetter = 1000;
        var widthTotal = (widthLetter + space) * lettersPerRow - space;
        var xLetter = (Main.WINDOW_WIDTH - widthTotal) / 2;

        var abc:Array<RawLetter> = new Array();

        abc.push({text:"z", sizeFactor:0.7, dkx:0, dky:-0.1});
        abc.push({text:"y", sizeFactor:0.7, dkx:0, dky:-0.1});
        abc.push({text:"x", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"w", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"v", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"u", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"t", sizeFactor:0.8, dkx:0, dky:-0.3});
        abc.push({text:"s", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"r", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"q", sizeFactor:0.7, dkx:0, dky:-0.1});
        abc.push({text:"p", sizeFactor:0.7, dkx:0, dky:-0.1});
        abc.push({text:"o", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"n", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"m", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"l", sizeFactor:0.7, dkx:0, dky:-0.5});
        abc.push({text:"k", sizeFactor:0.7, dkx:0, dky:-0.5});
        abc.push({text:"j", sizeFactor:0.6, dkx:0, dky:-0.2});
        abc.push({text:"i", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"h", sizeFactor:0.7, dkx:0, dky:-0.5});
        abc.push({text:"g", sizeFactor:0.7, dkx:0, dky:-0.1});
        abc.push({text:"f", sizeFactor:0.5, dkx:0, dky:-0.5});
        abc.push({text:"e", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"d", sizeFactor:0.8, dkx:0, dky:-0.3});
        abc.push({text:"c", sizeFactor:1, dkx:0, dky:0});
        abc.push({text:"b", sizeFactor:0.7, dkx:0, dky:-0.5});
        abc.push({text:"a", sizeFactor:1, dkx:0, dky:0});

        for(i in 0...4)
        {
            for(j in 0...lettersPerRow)
            {
                var letter = new Letter(abc.pop(), xLetter, yLetter);
                letter.makeShadow();
                addChild(letter);

                xLetter += widthLetter + space;
            }

            xLetter = (Main.WINDOW_WIDTH - widthTotal) / 2;
            yLetter += heightLetter + space;
        }

        for(j in 0...lettersPerRow)
        {
            if(j == 2 || j == 3)
            {
                var letter = new Letter(abc.pop(), xLetter, yLetter);
                letter.makeShadow();
                addChild(letter);
            }

            xLetter += widthLetter + space;
        }

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	public function getRandomWord()
	{
		return data.words[Std.random(data.words.length)];
	}

    function checkWord()
    {
        trace("checkWord");

        var complete = true;
        for(slot in slots)
            if(slot.letter == null)
            {
                complete = false;
                break;
            }

        if(complete)
        {
            trace("complete");
            var t = 0.5;
            for(i in 0...word.text.length)
            {
                var trueLetter = word.text.charAt(i);
                var userLetter = slots[i].letter.raw.text;
                trace("true " + trueLetter + " / user " + userLetter);

                Actuate.timer(t).onComplete(function()
                {
                    if(trueLetter == userLetter)
                        slots[i].letter.valid();
                    else
                        slots[i].letter.wrong();
                });

                t += 0.5;
            }
        }

    }

    var dragging:Letter = null;
    function onMouseDown(e)
    {
        if(Std.is(e.target, Letter))
        {
            var letter:Letter = e.target;
            if(letter.copy)
            {
                removeChild(letter);
                for(slot in slots)
                    if(slot.letter == letter)
                        slot.letter = null;
            }
            else
            {
                dragging = letter;
            }
        }
    }

    function onMouseUp(e)
    {
        function resetDrag()
        {
            removeChild(dragging.shadow);
            dragging.x = dragging.trueX;
            dragging.y = dragging.trueY;
            dragging = null;
        }

        if(nowSlot != null)
        {
            var slotLetter = dragging.getCopy();
            nowSlot.attach(slotLetter);
            addChild(slotLetter);
            nowSlot = null;

            checkWord();
        }

        if(dragging != null)
        {
            resetDrag();
        }
    }

    var nowSlot = null;
    var minDistance:Float = 200;
    function onEnterFrame(e)
    {
        if(dragging != null)
        {
            dragging.x = mouseX - dragging.width / 2;
            dragging.y = mouseY - dragging.height / 2;

            var dSlot = minDistance;
            var closestSlot = null;
            for(slot in slots)
            {
                var d = Math.sqrt(Math.pow(slot.x - dragging.x, 2) + Math.pow(slot.y - dragging.y, 2));
                
                if(d < dSlot)
                {
                    dSlot = d;
                    closestSlot = slot;
                }
            }

            // IF SWITCH TO SLOT
            if(closestSlot != nowSlot)
            {
                // TOO FAR FROM SLOT
                if(closestSlot == null)
                {
                    removeChild(dragging.shadow);
                }
                else
                {
                    // NEW SLOT
                    addChild(dragging.shadow);
                    dragging.shadow.x = closestSlot.x;
                    dragging.shadow.y = closestSlot.y;
                }

                nowSlot = closestSlot;
            }
        }
    }
}


typedef RawLetter = {text:String, sizeFactor:Float, dkx:Float, dky:Float}


enum State {
    DEFAULT;
    DRAGGING;
    SLOTED;
}


class Letter extends Sprite
{
    public var trueX:Float;
    public var trueY:Float;
    public var shadow:Letter;
    public var copy = false;
    public var raw:RawLetter;

    public function new(raw:RawLetter, x, y)
    {
        super();

        trueX = x;
        trueY = y;
        this.x = trueX;
        this.y = trueY;
        this.raw = raw;

        this.mouseChildren = false;
        var bmp = new Bitmap(Assets.getBitmapData("assets/letter.png"));
        addChild(bmp);

        // TEXT
        var size = 150;
        var tf = Tool.getTextField(0, 0, raw.text, Std.int(size * raw.sizeFactor));
        tf.textColor = 0xb06323;
        tf.width = 130;
        tf.height = 130;
        tf.x = size * raw.dkx;
        tf.y -= size / 2 + size * raw.dky;

        addChild(tf);
    }

    public function wrong()
    {
        this.transform.colorTransform = new openfl.geom.ColorTransform(1, 0.7, 0.7);
        Actuate.tween(this, 0.2, {scaleX: 1.1, scaleY: 1.1}).repeat(1).reflect().ease(Cubic.easeInOut);
    }

    public function valid()
    {
        this.transform.colorTransform = new openfl.geom.ColorTransform(0.7, 1, 0.7);
        Actuate.tween(this, 0.2, {scaleX: 1.1, scaleY: 1.1}).repeat(1).reflect().ease(Cubic.easeInOut);
    }

    public function makeShadow()
    {
        this.shadow = new Letter(raw, trueX, trueY);
        this.shadow.alpha = 0.3;
    }

    public function getCopy()
    {
        var newLetter = new Letter(raw, trueX, trueY);
        newLetter.copy = true;
        return newLetter;
    }
}



class Slot extends Sprite
{
    public var letter:Letter;

    public function new()
    {
        super();
        this.alpha = 0.3;

        var bmp = new Bitmap(Assets.getBitmapData("assets/slot.png"));
        addChild(bmp);
    }

    public function attach(letter:Letter)
    {
        letter.x = this.x;
        letter.y = this.y;
        this.letter = letter;
    }
}


class Word extends Sprite
{
    public var text:String;

    public function new(text:String)
    {
        super();
        this.text = text;

        var tf = Tool.getTextField(0, 0, text, 160);
        tf.x -= tf.textWidth / 2;
        tf.textColor = 0xf5e663;
        addChild(tf);

        // BACKGROUND
        var textWidth = tf.textWidth + 200;
        var textHeightPad = 20;
        this.graphics.beginFill(0x47a8bd);
        this.graphics.drawRoundRect(-textWidth / 2, -textHeightPad / 2,
                                    textWidth, tf.textHeight + textHeightPad,
                                    250, 250);
        this.graphics.endFill();
    }
}


class Game extends Sprite
 {
	public static inline var FONT = "assets/Cursive standard.ttf";
	public static inline var MENU_WIDTH = 800;
	public static inline var MENU_HEIGHT = 200;
	public static inline var MENU_SPACE = 150;

	var datas:Array<DataInterface> = [new OData(), new EData()];
	var menuEntries:Map<Sprite, DataInterface> = new Map();

 	public function new()
 	{
 		super();
 		// POSITIONS
 		var centerX = Main.WINDOW_WIDTH / 2 - MENU_WIDTH / 2;
 		var menuY = Main.WINDOW_HEIGHT / 2 - (datas.length * MENU_HEIGHT + (datas.length - 1) * MENU_SPACE) / 2;

 		// MENU ENTRIES
 		for(data in datas)
 		{
 			var menuEntry = getMenuEntry(data.title);
 			menuEntry.x = centerX;
 			menuEntry.y = menuY;

 			menuY += MENU_HEIGHT + MENU_SPACE;

 			addChild(menuEntry);
 			menuEntries.set(menuEntry, data);
 		}

 		// EVENTS
 		this.addEventListener(MouseEvent.CLICK, onMouseClick);
 	}

    private function onMouseClick(event:MouseEvent)
    {
    	for(menuEntry in menuEntries.keys())
    	{
    		if(event.target == menuEntry)
    		{
    			var data = menuEntries.get(menuEntry);
    			addChild(new SonPanel(data));
    		}
    	}
    }


 	public function getMenuEntry(text:String)
 	{
 		var sprite = new Sprite();
 		// EVENTS
 		sprite.mouseChildren = false;
 		sprite.buttonMode = true;

 		// CONTAINER
	    var container = new Shape();
        container.graphics.beginFill(0xef5fa5);
        container.graphics.drawRect(0, 0, MENU_WIDTH, MENU_HEIGHT);
        container.graphics.endFill();

        // TEXT
        var menuText = Tool.getTextField(0, 0, text, 80);
        menuText.width = MENU_WIDTH;
        menuText.y += menuText.textHeight / 3;

        sprite.addChild(container);
        sprite.addChild(menuText);

        return sprite;
 	}
 }


class Main extends Sprite
{
	public static inline var WINDOW_WIDTH = 1080;
	public static inline var WINDOW_HEIGHT = 1920;

	public function new ()
	{
		super();
        #if android
        var scaleRatio = 1;
        #else
		var scaleRatio = 0.5;
        #end
		Lib.application.window.resize(Std.int(WINDOW_WIDTH * scaleRatio), Std.int(WINDOW_HEIGHT * scaleRatio));

	    var shape = new Shape();
        shape.graphics.beginFill(0x4286f4, 1);
        shape.graphics.drawRect(0, 0, WINDOW_WIDTH - 4, WINDOW_HEIGHT - 4);
        shape.graphics.endFill();

	    var sprite = new Sprite();
        sprite.addChild(shape);

		addChild(sprite);

		sprite.scaleX = scaleRatio;
		sprite.scaleY = scaleRatio;

		sprite.addChild(new Game());
	}
}