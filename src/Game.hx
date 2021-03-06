package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import Particle;
import openfl.events.MouseEvent;
import Actions;

/**
 * ...
 * @author 01101101
 */
class Game extends Sprite
{
	
	static public var TAR:Rectangle = new Rectangle();
	static public var TAP:Point = new Point();
	
	static public var WIDTH:Int = 960;
	static public var HEIGHT:Int = 640;
	
	static public var INST:Game;

	var canvas:Bitmap;
	var canvasData:BitmapData;
	
	var shakeAmount:Int = 3;
	var shakeTick:Int;
	var shakeMode:ShakeMode;
	
	public var currentScreen:Screen;
	
	public var stageDifficulty:Int = 0;

	public var clickButtons:Sprite;
	public var clickScreen:Sprite;
	public var clickTitleScreen:Sprite;

	public function new () 
	{
		if (INST != null)
			throw new Error("Game already instanciated!");
		else
			INST = this;
		
		super();
		
		// Setup canvas
		canvasData = new BitmapData(WIDTH, HEIGHT, false);
		canvas = new Bitmap(canvasData);
		canvas.x = canvas.y = 0;
		addChild(canvas);
		
		clickButtons = new Sprite();
		for (i in 0...5)
		{
			var b = new Sprite();
			b.graphics.beginFill(Std.random(256*256*256), 0);
			b.graphics.drawRect(5, 5, 80, 80);
			b.graphics.endFill();
			b.buttonMode = true;
			b.x = 90 * i;
			clickButtons.addChild(b);

			if (i == 0)			b.addEventListener(MouseEvent.CLICK, clickHandlerA);
			else if (i == 1)	b.addEventListener(MouseEvent.CLICK, clickHandlerB);
			else if (i == 2)	b.addEventListener(MouseEvent.CLICK, clickHandlerC);
			else if (i == 3)	b.addEventListener(MouseEvent.CLICK, clickHandlerD);
			else if (i == 4)	b.addEventListener(MouseEvent.CLICK, clickHandlerE);
		}
		clickButtons.x = 255;
		clickButtons.y = HEIGHT - 120;

		clickScreen = new Sprite();
		clickScreen.graphics.beginFill(0xFFFF00, 0);
		clickScreen.graphics.drawRect(0, 0, Game.WIDTH, Game.HEIGHT);
		clickScreen.graphics.endFill();
		clickScreen.buttonMode = true;
		clickScreen.addEventListener(MouseEvent.CLICK, clickScreenHandler);

		clickTitleScreen = new Sprite();
		clickTitleScreen.graphics.beginFill(0x0000FF, 0);
		clickTitleScreen.graphics.drawRect(0, 0, Game.WIDTH, Game.HEIGHT);
		clickTitleScreen.graphics.endFill();
		clickTitleScreen.buttonMode = true;
		clickTitleScreen.addEventListener(MouseEvent.CLICK, clickTitleScreenHandler);

		addEventListener(Event.ENTER_FRAME, update);
		
		changeScreen(new TitleScreen());

		SoundMan.playLoop(SoundMan.MUSIC);
	}

	public function clickHandlerA (e:MouseEvent)
	{
		var lvl:Level;
		if (currentScreen != null && Std.is(currentScreen, Level)) {
			lvl = cast currentScreen;
			lvl.click(ActionType.DEFEND_FRONT);
			if (contains(clickButtons))
				removeChild(clickButtons);
		}
	}
	public function clickHandlerB (e:MouseEvent)
	{
		var lvl:Level;
		if (currentScreen != null && Std.is(currentScreen, Level)) {
			lvl = cast currentScreen;
			lvl.click(ActionType.DEFEND_UP);
			if (contains(clickButtons))
				removeChild(clickButtons);
		}
	}
	public function clickHandlerC (e:MouseEvent)
	{
		var lvl:Level;
		if (currentScreen != null && Std.is(currentScreen, Level)) {
			lvl = cast currentScreen;
			lvl.click(ActionType.ATTACK_FRONT);
			if (contains(clickButtons))
				removeChild(clickButtons);
		}
	}
	public function clickHandlerD (e:MouseEvent)
	{
		var lvl:Level;
		if (currentScreen != null && Std.is(currentScreen, Level)) {
			lvl = cast currentScreen;
			lvl.click(ActionType.ATTACK_UP);
			if (contains(clickButtons))
				removeChild(clickButtons);
		}
	}
	public function clickHandlerE (e:MouseEvent)
	{
		var lvl:Level;
		if (currentScreen != null && Std.is(currentScreen, Level)) {
			lvl = cast currentScreen;
			lvl.click(ActionType.REST);
			if (contains(clickButtons))
				removeChild(clickButtons);
		}
	}
	
	public function changeScreen (s:Screen)
	{
		currentScreen = s;
	}
	
	function update (e:Event)
	{
		if (currentScreen != null)
		{
			// Update level
			currentScreen.update();
			currentScreen.filterDead();
			currentScreen.postUpdate();
			// Render
			currentScreen.render(canvasData);
		}
		
		// Screen shake
		if (shakeTick > 0)
		{
			if (shakeMode == ShakeMode.HORIZONTAL || shakeMode == ShakeMode.OMNI)
				canvas.x = shakeAmount * Std.random(2) * 2 - 1;
			if (shakeMode == ShakeMode.VERTICAL || shakeMode == ShakeMode.OMNI)
				canvas.y = shakeAmount * Std.random(2) * 2 - 1;
			shakeTick--;
		}
		else if (shakeTick == 0)
		{
			canvas.x = canvas.y = 0;
			shakeTick--;
		}
	}
	
	public function filterDead (e:Entity) :Bool
	{
		return !e.isDead;
	}
	
	public function shake (amount:Int, duration:Int, mode:ShakeMode = null)
	{
		if (mode == null) mode = ShakeMode.OMNI;
		
		if (shakeTick == -1 || amount >= shakeAmount || mode == ShakeMode.OMNI)
		{
			shakeAmount = amount;
			shakeTick = duration;
			shakeMode = mode;
		}
	}
	
	public function spawnParticles (t:ParticleType, px:Float, py:Float, amount:Int = 1)
	{
		if (currentScreen == null)	return;

		switch (t)
		{
			default:
				for (i in 0...amount)
				{
					var p = new Particle(t);
					p.x = px + (Std.random(2)*2-1) * 4;
					p.y = py + (Std.random(2)*2-1) * 4;
					p.x -= p.cx;
					p.y -= p.cy;
					currentScreen.particles.push(p);
				}
		}
	}

	public function clickScreenHandler (e:Event)
	{
		var lvl:Level;
		if (currentScreen != null && Std.is(currentScreen, Level)) {
			lvl = cast currentScreen;
			lvl.clickScreen();
			if (contains(clickScreen))
				removeChild(clickScreen);
		}
	}

	public function clickTitleScreenHandler (e:Event)
	{
		var lvl:TitleScreen;
		if (currentScreen != null && Std.is(currentScreen, TitleScreen)) {
			lvl = cast currentScreen;
			lvl.clickScreen();
			if (contains(clickTitleScreen))
				removeChild(clickTitleScreen);
		}
	}
	
}

enum ShakeMode
{
	HORIZONTAL;
	VERTICAL;
	OMNI;
}
