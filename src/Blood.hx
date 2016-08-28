package;

/**
 * ...
 * @author 01101101
 */
class Blood extends Entity
{

	public function new (tx:Float, ty:Float)
	{
		super();
		
		setAnim(Sprites.BLOOD);
		frame = Std.random(totalFrames);
		
		x = tx;
		y = ty + cy - Game.HEIGHT;
		
		roy = Game.HEIGHT;
	}
	
	override public function postUpdate () { }
	
}
