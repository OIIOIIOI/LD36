package;

class ActionText extends Entity
{

	var isPlayer:Bool;

	public function new (isPlayer:Bool)
	{
		super();
		
		this.isPlayer = isPlayer;
		
		setAnim(Sprites.BLANK);
		
		x = 10;
		if (isPlayer)	x = Game.WIDTH - 195;
		y = Game.HEIGHT - 115;
		y += 1100;
		roy = -1100;
	}

}