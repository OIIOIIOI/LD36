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
		
		// Render
		render();
	}
	
	public function filterDead (e:Entity) :Bool
	{
		return !e.isDead;
	}
	
	function render ()
	{
		// Render all graphics
		canvasData.fillRect(canvasData.rect, 0xFF000000);
		//canvasData.fillRect(canvasData.rect, 0xFF1CEC96);
		// Render level entities
		for (e in level.entities) {
			Sprites.draw(canvasData, e.spriteID, e.x + e.rox, e.y + e.roy, e.frame);
		}
		// Render entities
		for (e in entities) {
			Sprites.draw(canvasData, e.spriteID, e.x + e.rox, e.y + e.roy, e.frame);
		}
	}
	
}
