package;

/**
 * ...
 * @author 01101101
 */
class Emote extends Entity
{

	public function new (id:String)
	{
		super();
		setAnim(id);
		
		rox = Std.int(w * 0.9);
		roy = Std.int(-h * 0.6);
	}
	
}
