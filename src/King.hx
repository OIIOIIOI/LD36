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
		
		setAnim(Sprites.IDLE);
		
		//rox = (Std.random(2) * 2 - 1) * 8;
	}
	
	override public function setAnim(id:String, randomStart:Bool = false, keepState:Bool = false) 
	{
		id += (isPlayer) ? Sprites.RIGHT : Sprites.LEFT;
		super.setAnim(id, randomStart, keepState);
	}
	
}
