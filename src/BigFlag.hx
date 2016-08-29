package;

/**
 * ...
 * @author 01101101
 */
class BigFlag extends Entity
{

	public function new (id:String, left:Bool = false)
	{
		super();

		id = Sprites.BIG + id;
		id += (left) ? Sprites.LEFT : Sprites.RIGHT;
		setAnim(id);
		
		x = -75;
		y = Game.HEIGHT - 220;

		if (!left) {
			x += 135;
			y += 1;
		}
		
		y += 500;
		roy = -500;
	}
	
}
