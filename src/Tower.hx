package;

/**
 * ...
 * @author 01101101
 */
class Tower extends Entity
{
	
	var isPlayer:Bool;
	var health:Int;

	public function new (isPlayer:Bool)
	{
		super();
		
		this.isPlayer = isPlayer;
		health = 3;
		
		y  = Game.HEIGHT - 200;
		if (isPlayer)	x = Game.WIDTH - 100;
		
		updateAnim();
	}
	
	function updateAnim ()
	{
		// TODO Set anim depending on health and isPlayer
		if (spriteID != Sprites.IDLE)	setAnim(Sprites.IDLE);
	}
	
	public function hurt ()
	{
		health--;
		updateAnim();
	}
	
}
