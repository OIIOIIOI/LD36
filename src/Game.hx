package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;

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

	var entities:Array<Entity>;
	//var particles:Array<Particle>;
	
	var shakeAmount:Int = 3;
	var shakeTick:Int;
	var shakeMode:ShakeMode;
	
	public var level:Level;

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
		
		reset();
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function reset ()
	{
		entities = [];
		
		level = new Level(0);
	}
	
	function update (e:Event)
	{
		// Update level
		level.update();
		
		// Update other entities
		for (e in entities) {
			e.update();
		}
		// Clean up dead entities
		entities = entities.filter(filterDead);
		
		// Post update entities
		for (e in entities) {
			e.postUpdate();
		}
		// Post update level entities
		for (e in level.entities) {
			e.postUpdate();
		}
		// Post update level entities
		for (e in level.emotes) {
			e.postUpdate();
		}
		
		// Render
		render();
		
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
	
	function render ()
	{
		// Render all graphics
		canvasData.fillRect(canvasData.rect, 0xFF808080);
		// Render level entities
		for (e in level.entities) {
			Sprites.draw(canvasData, e.spriteID, e.x + e.rox, e.y + e.roy, e.frame);
		}
		// Render level emotes
		for (e in level.emotes) {
			Sprites.draw(canvasData, e.spriteID, e.x + e.rox, e.y + e.roy, e.frame);
		}
		// Render entities
		for (e in entities) {
			Sprites.draw(canvasData, e.spriteID, e.x + e.rox, e.y + e.roy, e.frame);
		}
	}
	
	public function shake (amount:Int, duration:Int, mode:ShakeMode = null)
	{
		if (mode == null)
			mode = ShakeMode.OMNI;
		// Apply screen shake if none is taking place currently
		// or if new one is at least as strong
		// or if new one is fixed
		if (shakeTick == -1 || amount >= shakeAmount || mode == ShakeMode.OMNI)
		{
			shakeAmount = amount;
			shakeTick = duration;
			shakeMode = mode;
		}
	}
	
}

enum ShakeMode
{
	HORIZONTAL;
	VERTICAL;
	OMNI;
}
