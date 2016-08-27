package;

/**
 * ...
 * @author 01101101
 */
class Soldier extends Entity
{
	
	var isPlayer:Bool;
	var health:Int;

	public function new (isPlayer:Bool) 
	{
		super();
		
		this.isPlayer = isPlayer;
		health = 1;
		
		x = Std.random(Std.int(Game.WIDTH / 3));
		y = Std.random(Game.HEIGHT - 100);
		if (isPlayer)	x += Std.int(Game.WIDTH / 3 * 2);
		
		updateAnim();
	}
	
	function updateAnim ()
	{
		// TODO Set anim depending on health and isPlayer
		if (isPlayer) {
			if (spriteID != Sprites.ATK_UP)
				setAnim(Sprites.ATK_UP);
		} else {
			if (spriteID != Sprites.ATK_FRONT)
				setAnim(Sprites.ATK_FRONT);
		}
	}
	
	public function hurt ()
	{
		health--;
		updateAnim();
	}
	
}
