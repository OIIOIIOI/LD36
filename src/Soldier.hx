package;

/**
 * ...
 * @author 01101101
 */
class Soldier extends Entity
{
	
	var isPlayer:Bool;
	var health:Int;
	
	var thinkTick:Int;
	
	public var isThinking:Bool;
	
	var targetX:Float;
	var targetY:Float;
	var speed:Float = 3;

	public function new (isPlayer:Bool) 
	{
		super();
		
		setAnim(Sprites.DEF_FRONT);
		
		this.isPlayer = isPlayer;
		health = 1;
		
		thinkTick = -1;
		isThinking = false;
		
		x = Std.random(Std.int(Game.WIDTH / 3));
		y = Std.random(Game.HEIGHT - 100);
		if (isPlayer)	x += Std.int(Game.WIDTH / 3 * 2);
		moveTo(x, y);
		x = y = 0;
		if (isPlayer)	x = Game.WIDTH - 32;
	}
	
	override public function update() 
	{
		super.update();
		
		// Move towards target
		if (x != targetX || y != targetY)
		{
			Game.TAP.x = targetX - x;
			Game.TAP.y = targetY - y;
			Game.TAP.normalize(speed);
			x += Game.TAP.x;
			y += Game.TAP.y;
			
			if (Math.abs(x - targetX) < 2)
				x = targetX;
			if (Math.abs(y - targetY) < 2)
				y = targetY;
		}
		
		// Thinking
		if (thinkTick > 0) {
			thinkTick--;
			if (thinkTick <= 0) {
				isThinking = false;
				setAnim(Sprites.DEF_FRONT);
				moveTo(x + (Std.random(2) * 2 - 1) * Std.random(10), y + (Std.random(2) * 2 - 1) * Std.random(20));
			}
		}
	}
	
	public function hurt ()
	{
		health--;
	}
	
	public function think (t:Int)
	{
		thinkTick = t;
		isThinking = true;
		setAnim(Sprites.ATK_FRONT);
	}
	
	public function moveTo (tx:Float, ty:Float)
	{
		targetX = tx;
		targetY = ty;
	}
	
}
