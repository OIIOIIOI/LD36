package;

/**
 * ...
 * @author 01101101
 */
class Button extends Entity
{
	
	public var icon:Entity;
	
	public var isBlinking:Bool;
	var blinkTick:Int;
	
	var blinkSpeed:Int = 10;
	
	public function new ()
	{
		super();
		
		setAnim(Sprites.BUTTON);
		frame = 0;
		isBlinking = false;
		blinkTick = blinkSpeed;
	}
	
	public function setBlinking (b:Bool = true)
	{
		isBlinking = b;
		blinkTick = blinkSpeed;
	}
	
	override public function postUpdate ()
	{
		if (isBlinking)
		{
			if (blinkTick > 0)
			{
				blinkTick--;
				if (blinkTick <= 0)
				{
					if (frame == 0)			frame = 2;
					else if (frame == 1)	frame = 3;
					else if (frame == 2)	frame = 0;
					else if (frame == 3)	frame = 1;
					blinkTick = blinkSpeed;
				}
			}
		}
	}
	
}
