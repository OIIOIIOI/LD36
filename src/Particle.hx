package;

class Particle extends Entity
{
	
	var friction:Float;
	public var xVel:Float;
	public var yVel:Float;
	var xVelMax:Float;
	var yVelMax:Float;
	public var velMax:Float;
	var lifetime:Int;

	public function new (t:ParticleType)
	{
		super();

		friction = 1;
		xVelMax = 100;
		yVelMax = 100;
		velMax = -1;
		xVel = yVel = 0;

		switch (t)
		{
			case ParticleType.EXAMPLE:
				lifetime = 30 + Std.random(30);
				setAnim(Sprites.DEFAULT_PART);
				xVel = (Std.random(2)*2-1) * (Math.random() * 1);
				yVel = (Std.random(2)*2-1) * (Math.random() * 3);

			default:
				lifetime = 80 + Std.random(120);
				setAnim(Sprites.DEFAULT_PART);
				xVel = (Std.random(2)*2-1) * (Math.random() * 0.5);
				yVel = (Math.random() * 1) + 1;
		}
	}
	
	override public function update ()
	{
		super.update();

		// Limit velocity and actually update the x position
		xVel = Math.max(Math.min(xVel * friction, xVelMax), -xVelMax);
		if (Math.abs(xVel) < 0.01)
			xVel = 0;
		x += xVel;
		// Same for y
		yVel = Math.max(Math.min(yVel * friction, yVelMax), -yVelMax);
		if (Math.abs(yVel) < 0.01)
			yVel = 0;
		y += yVel;
		
		lifetime--;
		if (lifetime <= 0)
		{
			isDead = true;
		}
	}
}

enum ParticleType
{
	DEFAULT;
	EXAMPLE;
}