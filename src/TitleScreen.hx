package;
import haxe.Timer;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class TitleScreen extends Screen
{

	var isReady:Bool;
	
	public function new ()
	{
		super();
		
		isReady = false;
		Timer.delay(setReady, 1000);
		
		var e = new Battlefield();
		entities.push(e);
	}
	
	function setReady ()
	{
		isReady = true;
	}
	
	override public function update() 
	{
		super.update();
		
		if (isReady && Controls.isDown(Keyboard.SPACE))
		{
			isReady = false;
			Game.INST.changeScreen(new Level(Game.INST.stageDifficulty));
		}
	}
	
}
