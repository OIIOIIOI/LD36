package;

/**
 * ...
 * @author Germain Chavigny
 */
class TitleScreenTitle extends Entity
{

	public function new() 
	{
		super();
		
		setAnim(Sprites.TITLE_SCREEN_TITLE);
		
		y = 20;
		x = Game.WIDTH / 2 - w / 2;
	}
	
}