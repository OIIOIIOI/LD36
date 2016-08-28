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
	var speed:Float = 5;

	public var isComingBack:Bool;
	
	public function new (isPlayer:Bool) 
	{
		super();
		
		this.isPlayer = isPlayer;
		health = 1;
		
		setAnim(Sprites.IDLE);
		
		thinkTick = -1;
		isThinking = false;
		
		isComingBack = false;
		
		x = 0;
		y = Game.HEIGHT / 2 - cy;
		if (isPlayer)	x = Game.WIDTH - w;
		moveTo(x, y);
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
			
			if (Math.abs(x - targetX) < speed)
				x = targetX;
			if (Math.abs(y - targetY) < speed)
				y = targetY;
		}
		
		// Thinking
		if (thinkTick > 0) {
			thinkTick--;
			if (thinkTick <= 0) {
				isThinking = false;
			}
		}
	}
	
	override public function setAnim(id:String, randomStart:Bool = false, keepState:Bool = false) 
	{
		var dir = (isPlayer) ? -1 : 1;
		if (isComingBack)	dir = -dir;
		
		id += (dir == 1) ? Sprites.LEFT : Sprites.RIGHT;
		
		super.setAnim(id, randomStart, keepState);
	}
	
	public function hurt ()
	{
		health--;
		isDead = health <= 0;
	}
	
	public function think (t:Int)
	{
		thinkTick = t;
		isThinking = true;
	}
	
	public function moveTo (tx:Float, ty:Float)
	{
		targetX = tx;
		targetY = ty;
	}
	
	public function isMoving () :Bool
	{
		return (x != targetX || y != targetY);
	}
	
}
