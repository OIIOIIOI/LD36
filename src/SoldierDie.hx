package;

/**
 * ...
 * @author 01101101
 */
class SoldierDie extends Entity
{

	var isPlayer:Bool;
	
	public function new (isPlayer:Bool, tx:Float, ty:Float)
	{
		super();
		
		this.isPlayer = isPlayer;
		
		x = tx;
		y = ty;
		
		roy = -5;
		
		var id = Sprites.DIE;
		id += (isPlayer) ? Sprites.RIGHT : Sprites.LEFT;
		setAnim(id);
	}
	
	override public function postUpdate ()
	{
		// Animation logic
		if (totalFrames > 1)
		{
			if (animTick <= 0)
			{
				animTick = animDelay;
				frame++;
				if (frame >= totalFrames) {
					animTick = 9999;
					isDead = true;
				}
			}
			else {
				animTick--;
			}
		}
	}
	
}
