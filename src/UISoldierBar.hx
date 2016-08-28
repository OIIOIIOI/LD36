package;

/**
 * ...
 * @author 01101101
 */
class UISoldierBar extends Entity
{
	
	public var active:Bool;

	public function new ()
	{
		super();
		active = true;
		setAnim(Sprites.UI_SOLDIER_BAR);
		
		y = Game.HEIGHT + 600;
		roy = -h - 630;
	}
	
	override public function postUpdate ()
	{
		super.postUpdate();
		frame = (active) ? 0 : 1;
	}
	
}
