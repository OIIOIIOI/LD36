package;

/**
 * ...
 * @author 01101101
 */
class Buttons
{
	
	public var entities:Array<Entity>;
	var buttons:Array<Button>;
	
	public function new ()
	{
		entities = [];
		buttons = [];
		
		var sx = 250;
		var sy = Game.HEIGHT - 118;
		
		for (i in 0...5)
		{
			var b = new Button();
			b.x = sx + 90 * i;
			b.y = sy;
			
			b.icon = new ButtonIcon(i);
			b.icon.x = b.x + 15;
			b.icon.y = b.y + 5;
			
			buttons.push(b);
			entities.push(b);
			entities.push(b.icon);
		}
	}
	
	public function allowChoice ()
	{
		for (b in buttons) {
			b.frame = 2;
			b.icon.roy = 0;
		}
	}
	
	public function select (bi:Int)
	{
		for (i in 0...buttons.length) {
			if (i == bi) {
				buttons[i].frame = 3;
				buttons[i].icon.roy = 5;
			}
			else {
				buttons[i].frame = 1;
				buttons[i].icon.roy = 5;
			}
		}
	}
	
	public function reset ()
	{
		for (b in buttons) {
			b.frame = 0;
			b.icon.roy = 0;
		}
	}
	
}
