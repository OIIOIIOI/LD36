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
		
		updateAnim();
		
		if (isPlayer)	x = Game.WIDTH - w;
		y = Game.HEIGHT - 100;
		roy = -h + (Std.random(2) * 2 - 1) * 20;
	}
	
	function updateAnim ()
	{
		var anim = switch (health) {
			//case 2:		(!isPlayer) ? Sprites.TOWER_LEFT_A : Sprites.TOWER_RIGHT_A;
			//case 1:		(!isPlayer) ? Sprites.TOWER_LEFT_B : Sprites.TOWER_RIGHT_B;
			//case 0:		(!isPlayer) ? Sprites.TOWER_LEFT_C : Sprites.TOWER_RIGHT_C;
			default:	(!isPlayer) ? Sprites.TOWER + Sprites.LEFT : Sprites.TOWER + Sprites.RIGHT;
		}
		if (anim != spriteID)	setAnim(anim);
	}
	
	public function hurt ()
	{
		health--;
		updateAnim();
	}
	
}
