package;

/**
 * ...
 * @author 01101101
 */
class BannerText extends Entity
{

	public function new (victory:Bool)
	{
		super();
		
		var id = (victory) ? Sprites.BANNER_VICTORY : Sprites.BANNER_DEFEAT;
		setAnim(id);
		
		x = Game.WIDTH / 2 - cx;
		y = Game.HEIGHT / 2 - cy - 80;
		y += 1000;
		roy = -1000;
		
	}
	
}