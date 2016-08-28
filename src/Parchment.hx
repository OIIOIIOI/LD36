package;

/**
 * ...
 * @author 01101101
 */
class Parchment extends Entity
{
	
	var isPlayer:Bool;

	public function new (isPlayer:Bool)
	{
		super();
		
		this.isPlayer = isPlayer;
		
		var anim = Sprites.PARCHMENT;
		anim += (isPlayer) ? Sprites.RIGHT : Sprites.LEFT;
		setAnim(anim);
		
		y = Game.HEIGHT + 510;
		roy = -h - 520;
		if (isPlayer)	x = Game.WIDTH - w;
	}
	
}
