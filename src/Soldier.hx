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
	}
	
	override public function update() 
	{
		super.update();
		
		if (thinkTick > 0) {
			thinkTick--;
			if (thinkTick <= 0) {
				isThinking = false;
				setAnim(Sprites.DEF_FRONT);
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
	
}
