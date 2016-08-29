package;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class Screen
{
	
	public var entities:Array<Entity>;
	public var particles:Array<Entity>;

	public function new ()
	{
		entities = [];
		particles = [];
	}
	
	public function update ()
	{
		// Update entities
		for (e in entities) {
			e.update();
		}
		// Update particles
		for (p in particles) {
			p.update();
		}
	}
	
	public function filterDead ()
	{
		// Clean up dead entities
		entities = entities.filter(Game.INST.filterDead);
		particles = particles.filter(Game.INST.filterDead);
	}
	
	public function postUpdate ()
	{
		// Post update entities
		for (e in entities) {
			e.postUpdate();
		}
		// Update particles
		for (p in particles) {
			p.postUpdate();
		}
	}
	
	public function render (canvasData:BitmapData)
	{
		// Clear canvas
		canvasData.fillRect(canvasData.rect, 0xFF1CEC96);
		// Render entities
		renderArray(entities, canvasData);
		renderArray(particles, canvasData);
	}
	
	function renderArray (a:Array<Entity>, canvasData:BitmapData)
	{
		// Render entities
		for (e in a) {
			Sprites.draw(canvasData, e.spriteID, e.x + e.rox, e.y + e.roy, e.frame);
		}
	}
	
}