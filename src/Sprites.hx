package;
import flash.geom.Matrix;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * ...
 * @author 01101101
 */
class Sprites
{
	
	static public var RIGHT:String = "_right";
	static public var LEFT:String = "_left";
	
	static public var BATTLEFIELD:String = "battlefield";
	static public var TOWER:String = "tower";
	
	static public var IDLE:String = "idle";
	static public var ATK_FRONT:String = "atk_front";
	static public var ATK_UP:String = "atk_up";
	static public var DEF_FRONT:String = "def_front";
	static public var DEF_UP:String = "def_up";
	
	static public var FLAG_A:String = "flag_a";
	static public var FLAG_B:String = "flag_b";
	static public var FLAG_C:String = "flag_c";
	static public var FLAG_D:String = "flag_d";
	static public var FLAG_E:String = "flag_e";
	static public var FLAG_F:String = "flag_f";
	static public var FLAG_G:String = "flag_g";
	static public var FLAG_H:String = "flag_h";
	static public var FLAG_I:String = "flag_i";
	static public var FLAG_J:String = "flag_j";
	
	static public var ARROW:String = "arrow";
	
	static var sprites:Map<String, SpriteSheet>;
	
	static public function init ()
	{
		sprites = new Map();
		
		// Store all assets and animation infos
		// Background
		sprites.set(BATTLEFIELD, { data:Assets.getBitmapData("img/battle_field.png"), frames:1, delay:8 });
		// Tower
		sprites.set(TOWER + LEFT,	{ data:Assets.getBitmapData("img/tower.png"), frames:1, delay:8 });
		sprites.set(TOWER + RIGHT,	flipAnim(TOWER + LEFT));
		// Soldiers
		sprites.set(IDLE + LEFT,		{ data:Assets.getBitmapData("img/idle.png"), frames:4, delay:8 });
		sprites.set(ATK_FRONT + LEFT,	{ data:Assets.getBitmapData("img/atk_front.png"), frames:7, delay:8 });
		sprites.set(ATK_UP + LEFT,		{ data:Assets.getBitmapData("img/atk_up.png"), frames:4, delay:8 });
		sprites.set(DEF_FRONT + LEFT,	{ data:Assets.getBitmapData("img/def_front.png"), frames:4, delay:8 });
		sprites.set(DEF_UP + LEFT,		{ data:Assets.getBitmapData("img/def_up.png"), frames:4, delay:8 });
		// Soldiers flipped
		sprites.set(IDLE + RIGHT,		flipAnim(IDLE + LEFT));
		sprites.set(ATK_FRONT + RIGHT,	flipAnim(ATK_FRONT + LEFT));
		sprites.set(ATK_UP + RIGHT,		flipAnim(ATK_UP + LEFT));
		sprites.set(DEF_FRONT + RIGHT,	flipAnim(DEF_FRONT + LEFT));
		sprites.set(DEF_UP + RIGHT,		flipAnim(DEF_UP + LEFT));
		// Flags
		sprites.set(FLAG_A + RIGHT,	{ data:Assets.getBitmapData("img/flag_a.png"), frames:2, delay:8 });
		sprites.set(FLAG_B + RIGHT,	{ data:Assets.getBitmapData("img/flag_b.png"), frames:2, delay:8 });
		sprites.set(FLAG_C + RIGHT,	{ data:Assets.getBitmapData("img/flag_c.png"), frames:2, delay:8 });
		sprites.set(FLAG_D + RIGHT,	{ data:Assets.getBitmapData("img/flag_d.png"), frames:2, delay:8 });
		sprites.set(FLAG_E + RIGHT,	{ data:Assets.getBitmapData("img/flag_e.png"), frames:2, delay:8 });
		sprites.set(FLAG_F + RIGHT,	{ data:Assets.getBitmapData("img/flag_f.png"), frames:2, delay:8 });
		sprites.set(FLAG_G + RIGHT,	{ data:Assets.getBitmapData("img/flag_g.png"), frames:2, delay:8 });
		sprites.set(FLAG_H + RIGHT,	{ data:Assets.getBitmapData("img/flag_h.png"), frames:2, delay:8 });
		sprites.set(FLAG_I + RIGHT,	{ data:Assets.getBitmapData("img/flag_i.png"), frames:2, delay:8 });
		sprites.set(FLAG_J + RIGHT,	{ data:Assets.getBitmapData("img/flag_j.png"), frames:2, delay:8 });
		// Flags flipped
		sprites.set(FLAG_A + LEFT,	flipAnim(FLAG_A + RIGHT));
		sprites.set(FLAG_B + LEFT,	flipAnim(FLAG_B + RIGHT));
		sprites.set(FLAG_C + LEFT,	flipAnim(FLAG_C + RIGHT));
		sprites.set(FLAG_D + LEFT,	flipAnim(FLAG_D + RIGHT));
		sprites.set(FLAG_E + LEFT,	flipAnim(FLAG_E + RIGHT));
		sprites.set(FLAG_F + LEFT,	flipAnim(FLAG_F + RIGHT));
		sprites.set(FLAG_G + LEFT,	flipAnim(FLAG_G + RIGHT));
		sprites.set(FLAG_H + LEFT,	flipAnim(FLAG_H + RIGHT));
		sprites.set(FLAG_I + LEFT,	flipAnim(FLAG_I + RIGHT));
		sprites.set(FLAG_J + LEFT,	flipAnim(FLAG_J + RIGHT));
		// Arrows
		sprites.set(ARROW + LEFT,	{ data:Assets.getBitmapData("img/arrow.png"), frames:10, delay:8 });
		sprites.set(ARROW + RIGHT,	flipAnim(ARROW + LEFT));
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
	
	static public function flipAnim (id:String) :SpriteSheet
	{
		var sheet = getSheet(id);
		// If sheet does not exist
		if (sheet == null)
			return null;
		// If single frame, no need to reverse animation
		if (sheet.frames == 1)
			return { data:flipBitmapData(sheet.data), frames:sheet.frames, delay:sheet.delay };
		// Reverse animation
		var flipped = new BitmapData(sheet.data.width, sheet.data.height, true, 0x00FF00FF);
		var w = Std.int(sheet.data.width / sheet.frames);
		Game.TAR.x = 0;
		Game.TAR.y = 0;
		Game.TAR.width = w;
		Game.TAR.height = sheet.data.height;
		Game.TAP.x = 0;
		Game.TAP.y = 0;
		for (i in 0...sheet.frames)
		{
			Game.TAR.x = i * w;
			Game.TAP.x = sheet.data.width - (i + 1) * w;
			flipped.copyPixels(sheet.data, Game.TAR, Game.TAP);
		}
		// Flip sheet
		return { data:flipBitmapData(flipped), frames:sheet.frames, delay:sheet.delay };
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
