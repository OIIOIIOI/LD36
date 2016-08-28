package;

/**
 * ...
 * @author 01101101
 */
class Flag extends Entity
{
	
	public var zOffset:Int;

	public function new (id:String)
	{
		super();
		zOffset = roy = -800;
		setAnim(id);
	}
	
}
