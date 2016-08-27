package;
import flash.geom.Matrix;
import openfl.Assets;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class Sprites
{
	
	static public var BATTLEFIELD:String = "battlefield";
	static public var TOWER_LEFT:String = "tower_left";
	static public var TOWER_RIGHT:String = "tower_right";
	
	static public var IDLE:String = "idle";
	static public var SLEEP:String = "sleep";
	static public var ATK_FRONT:String = "atk_front";
	static public var ATK_UP:String = "atk_up";
	static public var DEF_FRONT:String = "def_front";
	static public var DEF_UP:String = "def_up";
	
	static public var FLAG_A_RIGHT:String = "flag_a_right";
	static public var FLAG_B_RIGHT:String = "flag_b_right";
	static public var FLAG_C_RIGHT:String = "flag_c_right";
	static public var FLAG_D_RIGHT:String = "flag_d_right";
	static public var FLAG_E_RIGHT:String = "flag_e_right";
	
	static public var FLAG_A_LEFT:String = "flag_a_left";
	static public var FLAG_B_LEFT:String = "flag_b_left";
	static public var FLAG_C_LEFT:String = "flag_c_left";
	static public var FLAG_D_LEFT:String = "flag_d_left";
	static public var FLAG_E_LEFT:String = "flag_e_left";
	
	static var sprites:Map<String, SpriteSheet>;

	static public function init ()
	{
		sprites = new Map();
		
		// Store all assets and animation infos
		// Background
		sprites.set(BATTLEFIELD, { data:Assets.getBitmapData("img/battle_field.png"), frames:1, delay:8 });
		// Tower
		sprites.set(TOWER_LEFT, { data:Assets.getBitmapData("img/tower.png"), frames:1, delay:8 });
		sprites.set(TOWER_RIGHT, { data:Sprites.flipBitmapData(Assets.getBitmapData("img/tower.png")), frames:1, delay:8 });
		// Soldiers
		sprites.set(IDLE, { data:Assets.getBitmapData("img/idle.png"), frames:1, delay:8 });
		sprites.set(SLEEP, { data:Assets.getBitmapData("img/sleep.png"), frames:1, delay:8 });
		sprites.set(ATK_FRONT, { data:Assets.getBitmapData("img/atk_front.png"), frames:1, delay:8 });
		sprites.set(ATK_UP, { data:Assets.getBitmapData("img/atk_up.png"), frames:1, delay:8 });
		sprites.set(DEF_FRONT, { data:Assets.getBitmapData("img/def_front.png"), frames:1, delay:8 });
		sprites.set(DEF_UP, { data:Assets.getBitmapData("img/def_up.png"), frames:1, delay:8 });
		// Flags
		sprites.set(FLAG_A_RIGHT, { data:Assets.getBitmapData("img/flag_a.png"), frames:2, delay:8 });
		sprites.set(FLAG_B_RIGHT, { data:Assets.getBitmapData("img/flag_b.png"), frames:2, delay:8 });
		sprites.set(FLAG_C_RIGHT, { data:Assets.getBitmapData("img/flag_c.png"), frames:2, delay:8 });
		sprites.set(FLAG_D_RIGHT, { data:Assets.getBitmapData("img/flag_d.png"), frames:2, delay:8 });
		sprites.set(FLAG_E_RIGHT, { data:Assets.getBitmapData("img/flag_e.png"), frames:2, delay:8 });
		// Flags flipped
		sprites.set(FLAG_A_LEFT, { data:Sprites.flipBitmapData(Assets.getBitmapData("img/flag_a.png")), frames:2, delay:8 });
		sprites.set(FLAG_B_LEFT, { data:Sprites.flipBitmapData(Assets.getBitmapData("img/flag_b.png")), frames:2, delay:8 });
		sprites.set(FLAG_C_LEFT, { data:Sprites.flipBitmapData(Assets.getBitmapData("img/flag_c.png")), frames:2, delay:8 });
		sprites.set(FLAG_D_LEFT, { data:Sprites.flipBitmapData(Assets.getBitmapData("img/flag_d.png")), frames:2, delay:8 });
		sprites.set(FLAG_E_LEFT, { data:Sprites.flipBitmapData(Assets.getBitmapData("img/flag_e.png")), frames:2, delay:8 });
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
	
	static public function flipBitmapData (bd:BitmapData) :BitmapData
	{
		var flipped = new BitmapData(bd.width, bd.height, true, 0x00FF00FF);
		var mat = new Matrix();
		mat.scale( -1, 1);
		mat.translate(bd.width, 0);
		flipped.draw(bd, mat);
		return flipped;
	}
	
}

typedef SpriteSheet = {
	data:BitmapData,
	frames:Int,
	delay:Int
}
