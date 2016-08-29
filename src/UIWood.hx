package;

/**
 * ...
 * @author 01101101
 */
class UIWood extends Entity
{

	public function new ()
	{
		super();
		setAnim(Sprites.UI_WOOD);
		y = Game.HEIGHT + 500;
		roy = -h - 500 + 2;
	}
	
}
