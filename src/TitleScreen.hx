package;
import haxe.Timer;
import motion.Actuate;
import motion.easing.Back;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class TitleScreen extends Screen
{

	var isReady:Bool;
	
	public function new ()
	{
		super();
		
		isReady = false;
		Timer.delay(setReady, 1000);
		
		var bg = new TitleScreenBg();
		entities.push(bg);
		
		var king = new King(false);
		king.x = Game.WIDTH / 2 - king.w / 2 + 5;
		king.y = 270;
		entities.push(king);
		
		var tower = new TitleScreenTower();
		entities.push(tower);
		
		var title = new TitleScreenTitle();
		title.y = -title.h;
		entities.push(title);
		
		Actuate.tween(title, 1, { y:20 } ).delay(1).ease(Back.easeOut);
		
		var soldierPosList = [
			{x:293, y:728},
			{x:232, y:591},
			{x:164, y:557},
			{x:306, y:578},
			{x:779, y:589},
			{x:689, y:583},
			{x:821, y:517},
			{x:814, y:642},
			{x:676, y:664},
			{x:80, y:631},
			{x:366, y:602},
			{x:609, y:616},
			{x:898, y:605},
			{x:267, y:641},
			{x:747, y:515},
			{x:628, y:491},
			{x:257, y:483},
			{x:346, y:518},
			{x:689, y:501},
			{x:845, y:575},
			{x:932, y:555},
			{x:733, y:612},
			{x:920, y:652},
			{x:846, y:666},
			{x:659, y:542},
			{x:172, y:645},
			{x:113, y:591},
			{x:321, y:612},
			{x:113, y:508},
			{x:420, y:649},
			{x:535, y:629},
			{x:484, y:645},
			{x:39, y:575 }
		];
		
		for (pos in soldierPosList) {
			
			pos.x -= 50;
			pos.y -= 60;
			
			var soldier = new Soldier(cast Std.random(2));
			soldier.x = pos.x;
			soldier.y = pos.y;
			soldier.moveTo(pos.x, pos.y, true);
			
			entities.push(soldier);
		}
		
		Game.INST.addEventListener(MouseEvent.CLICK, onClick);
		Game.INST.buttonMode = true;
		
	}
	
	private function onClick(e:MouseEvent):Void 
	{
		Game.INST.removeEventListener(MouseEvent.CLICK, onClick);
		Game.INST.buttonMode = false;
		openLevelScreen();
	}
	
	function setReady ()
	{
		isReady = true;
	}
	
	override public function update() 
	{
		super.update();
		
		if (isReady && Controls.isDown(Keyboard.SPACE))
		{
			openLevelScreen();
		}
	}
	
	private function openLevelScreen() {	
		isReady = false;
		Game.INST.changeScreen(new Level(Game.INST.stageDifficulty));
	}
	
}
