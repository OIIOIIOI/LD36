package;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class Controls
{
	
	static var keys:Map<Int, Bool>;
	
	static public function init ()
	{
		// Setup all useful keys
		keys = new Map();
		keys.set(Keyboard.D, false);
		keys.set(Keyboard.F, false);
		keys.set(Keyboard.G, false);
		keys.set(Keyboard.H, false);
		keys.set(Keyboard.J, false);
		keys.set(Keyboard.SPACE, false);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	static public function isDown (k:Int) :Bool
	{
		if (!keys.exists(k))
			return false;
		else
			return keys.get(k);
	}
	
	static function keyDownHandler (e:KeyboardEvent)
	{
		if (!keys.exists(e.keyCode))
			return;
		else
			keys.set(e.keyCode, true);
	}
	
	static function keyUpHandler (e:KeyboardEvent)
	{
		if (!keys.exists(e.keyCode))
			return;
		else
			keys.set(e.keyCode, false);
	}
	
}
