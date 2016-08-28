package;

/**
 * ...
 * @author 01101101
 */
class Button extends Entity
{
	
	public var icon:Entity;

	public function new ()
	{
		super();
		
		setAnim(Sprites.BUTTON);
		frame = 0;
	}
	
	override public function postUpdate ()
	{
		
	}
	
}