package;

/**
 * ...
 * @author 01101101
 */
class King extends Entity
{
	
	var isPlayer:Bool;

	public function new (isPlayer:Bool)
	{
		super();
		
		this.isPlayer = isPlayer;
		setAnim(Sprites.ATK_UP);
		
		rox = (Std.random(2) * 2 - 1) * 8;
	}
	
}
