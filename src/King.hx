package;

/**
 * ...
 * @author 01101101
 */
class King extends Entity
{
	
	var isPlayer:Bool;

	public function new (isPlayer:Bool)
	{
		super();
		
		this.isPlayer = isPlayer;
		
		updateAnim();
	}
	
	function updateAnim ()
	{
		// TODO Set anim depending on health and isPlayer
		if (spriteID != Sprites.SLEEP)
			setAnim(Sprites.SLEEP);
	}
	
}
