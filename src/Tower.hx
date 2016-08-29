package;

import Game;
import Particle;

/**
 * ...
 * @author 01101101
 */
class Tower extends Entity
{
	
	var isPlayer:Bool;
	public var health:Int;

	public function new (isPlayer:Bool)
	{
		super();
		
		this.isPlayer = isPlayer;
		health = 3;
		
		updateAnim();
		
		if (isPlayer)	x = Game.WIDTH - w;
		y = Game.HEIGHT - 100;
		roy = -h + (Std.random(2) * 2 - 1) * 20;
		
		// Test anim hurt
		/*
		var t:Timer = new Timer(3000);
		t.run = function():Void {
			hurt();
		};
		*/
	}
	
	function updateAnim ()
	{
		var anim = switch (health) {
			case 3:		Sprites.TOWER_A;
			case 2:		Sprites.TOWER_B;
			default:	Sprites.TOWER_C;
		}
		anim += (isPlayer) ? Sprites.RIGHT : Sprites.LEFT;
		if (anim != spriteID)	setAnim(anim);
	}
	
	public function hurt ()
	{
		health--;
		updateAnim();
		Game.INST.shake(5, 45, ShakeMode.OMNI);
		Game.INST.spawnParticles(ParticleType.TOWER, x - w / 2 + 140, y - h / 2 - 30, 10);
		
	}
	
}
