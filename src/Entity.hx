package;

/**
 * ...
 * @author 01101101
 */
class Entity
{
	
	// Animation stuff
	public var spriteID(default, null):String;
	public var frame:Int;
	var totalFrames:Int;
	var animDelay:Int;
	var animTick:Int;

	// Sprite position
	public var x:Float;
	public var y:Float;

	// Sprite size
	public var w:Int;
	public var h:Int;

	// Sprite center
	public var cx:Int;
	public var cy:Int;

	// Render offset
	public var rox:Int;
	public var roy:Int;

	public var isDead:Bool;

	public function new ()
	{
		setAnim("");
		x = y = 0;
		rox = roy = 0;
		isDead = false;
	}

	public function setAnim (id:String, randomStart:Bool = false, keepState:Bool = false)
	{
		spriteID = id;
		animDelay = 0;
		totalFrames = 1;
		if (!keepState) {
			animTick = 0;
			frame = 0;
		}
		cx = cy = 0;
		
		var sheet = Sprites.getSheet(spriteID);
		if (sheet == null)
			return;
		// Save animation settings
		animDelay = sheet.delay;
		if (!keepState)
			animTick = sheet.delay;
		if (randomStart)
			animTick = Std.random(sheet.delay);
		totalFrames = sheet.frames;
		// Recalculate size and center of sprite
		w = Std.int(sheet.data.width / sheet.frames);
		h = Std.int(sheet.data.height);
		cx = Std.int(w / 2);
		cy = Std.int(h / 2);
	}
	
	public function update () { }

	public function postUpdate ()
	{
		// Animation logic
		if (totalFrames > 1)
		{
			if (animTick <= 0)
			{
				animTick = animDelay;
				frame++;
				if (frame >= totalFrames)
					frame = 0;
			}
			else {
				animTick--;
			}
		}
	}
	
}
