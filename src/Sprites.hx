package;
import openfl.Assets;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class Sprites
{

	static public var IDLE:String = "idle";
	static public var SLEEP:String = "sleep";
	static public var ATK_FRONT:String = "atk_front";
	static public var ATK_UP:String = "atk_up";
	static public var DEF_FRONT:String = "def_front";
	static public var DEF_UP:String = "def_up";
	
	static var sprites:Map<String, SpriteSheet>;

	static public function init ()
	{
		sprites = new Map();
		// Store all assets and animation infos
		sprites.set(IDLE, { data:Assets.getBitmapData("img/idle.png"), frames:1, delay:8 });
		sprites.set(SLEEP, { data:Assets.getBitmapData("img/sleep.png"), frames:1, delay:8 });
		sprites.set(ATK_FRONT, { data:Assets.getBitmapData("img/atk_front.png"), frames:1, delay:8 });
		sprites.set(ATK_UP, { data:Assets.getBitmapData("img/atk_up.png"), frames:1, delay:8 });
		sprites.set(DEF_FRONT, { data:Assets.getBitmapData("img/def_front.png"), frames:1, delay:8 });
		sprites.set(DEF_UP, { data:Assets.getBitmapData("img/def_up.png"), frames:1, delay:8 });
	}
	
	static public function getSheet (id:String) :SpriteSheet
	{
		if (sprites == null || !sprites.exists(id))
			return null;
		return sprites.get(id);
	}
	
	static public function draw (c:BitmapData, id:String, x:Float = 0, y:Float = 0, frame:Int = 0)
	{
		if (sprites == null || !sprites.exists(id))
			return;
		
		var sheet:SpriteSheet = sprites.get(id);
		var data = sheet.data;
		
		Game.TAR.width = data.width / sheet.frames;
		Game.TAR.height = data.height;
		Game.TAR.x = frame * Game.TAR.width;
		Game.TAR.y = 0;
		
		Game.TAP.x = Math.round(x);
		Game.TAP.y = Math.round(y);
		
		c.copyPixels(data, Game.TAR, Game.TAP);
	}
	
}

typedef SpriteSheet = {
	data:BitmapData,
	frames:Int,
	delay:Int
}
