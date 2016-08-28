package;

/**
 * ...
 * @author 01101101
 */
class ButtonIcon extends Entity
{

	public function new (f)
	{
		super();
		
		setAnim(Sprites.BUTTON_ICON);
		frame = f;
	}
	
	override public function postUpdate ()
	{
		
	}
	
}