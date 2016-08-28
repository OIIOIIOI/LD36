package;

/**
 * ...
 * @author 01101101
 */
class Battlefield extends Entity
{

	public function new() 
	{
		super();
		setAnim(Sprites.BATTLEFIELD);
		
		y = -Game.HEIGHT * 2;
		roy = Game.HEIGHT * 2;
	}
	
}