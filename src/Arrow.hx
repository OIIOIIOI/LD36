package;

import haxe.Timer;

/**
 * ...
 * @author 01101101
 */
class Arrow extends Entity
{
	
	var speedX:Float = 7.5;
	var speedY:Float;
	var speedYmax:Float = 15;
	var gravity:Float = 0.5;

	public function new (isPlayer:Bool)
	{
		super();
		
		var a = Sprites.ARROW;
		if (isPlayer)	a += Sprites.RIGHT;
		else			a += Sprites.LEFT;
		setAnim(a);
		
		if (isPlayer)	speedX = -speedX;
		speedY = -speedYmax;
		
		speedX += (Std.random(2) * 2 - 1) * (Std.random(15) / 10);
		
		SoundMan.playOnce(SoundMan.BOW, 0.2);
		
	}
	
	override public function update ()
	{
		super.update();
		
		x += speedX;
		speedY += gravity;
		y += speedY;
		
		if (gravity != 0 && speedY > speedYmax) {
			speedX = speedY = gravity = 0;
			Timer.delay(kill, 1500);
		}
	}
	
	override public function postUpdate ()
	{
		if (gravity == 0)	return;
		
		frame = Std.int(speedY / Std.int(speedYmax / 5)) + 4;
	}
	
	function kill ()
	{
		isDead = true;
	}
	
}
