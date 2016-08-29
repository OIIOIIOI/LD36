package;

/**
 * ...
 * @author Germain Chavigny
 */
class TitleScreenBg extends Entity
{

	public function new() 
	{
		super();
		
		setAnim(Sprites.TITLE_SCREEN_BG);
		
		y = -Game.HEIGHT * 2;
		roy = Game.HEIGHT * 2;
	}
	
}