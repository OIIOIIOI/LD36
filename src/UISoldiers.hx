package;

/**
 * ...
 * @author 01101101
 */
class UISoldiers
{
	
	public var entities:Array<UISoldierBar>;

	public function new (n:Int, xOffset:Int = 0)
	{
		entities = [];
		
		xOffset += Std.int((190 - n * 15) / 2);
		
		var e:UISoldierBar;
		for (i in 0...n)
		{
			e = new UISoldierBar();
			e.x = i * 15 + xOffset;
			entities.push(e);
		}
	}
	
	public function activate (n:Int)
	{
		for (e in entities)
		{
			e.active = n > 0;
			n--;
		}
	}
	
}
