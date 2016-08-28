package;

/**
 * ...
 * @author 01101101
 */
class Arrow extends Entity
{

	public function new (isPlayer:Bool)
	{
		super();
		var a = Sprites.ARROW;
		if (isPlayer)	a += Sprites.RIGHT;
		else			a += Sprites.LEFT;
		setAnim(a);
	}
	
}
