package;

/**
 * ...
 * @author Germain Chavigny
 */
class TitleScreenTower extends Entity
{

	public function new() 
	{
		super();
		
		setAnim(Sprites.TITLE_SCREEN_TOWER);
		
		y = Game.HEIGHT - h;
		x = Game.WIDTH / 2 - w / 2;
		
	}
	
}