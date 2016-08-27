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
		
		y = Std.int(-h / 2);
		roy = Std.int(h / 2);
	}
	
}