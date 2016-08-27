package;

/**
 * ...
 * @author 01101101
 */
class Level
{
	
	var stage:Int;
	
	var enemyTower:Tower;
	var enemySoldiers:Array<Soldier>;
	
	var playerTower:Tower;
	var playerSoldiers:Array<Soldier>;
	
	public var entities:Array<Entity>;

	public function new (stage:Int)
	{
		this.stage = stage;
		
		entities = [];
		
		enemyTower = new Tower(false);
		entities.push(enemyTower);
		spawnEnemySoldiers();
		
		playerTower = new Tower(true);
		entities.push(playerTower);
		spawnPlayerSoldiers();
	}
	
	function spawnEnemySoldiers ()
	{
		// Set number of soldiers depending on stage
		var n =  switch (stage) {
			default:	7;
		}
		// Reset array
		if (enemySoldiers == null) {
			enemySoldiers = new Array();
		} else {
			while (enemySoldiers.length > 0) {
				enemySoldiers.pop().isDead = true;
			}
		}
		// Create soldiers
		for (i in 0...n) {
			var s = new Soldier(false);
			enemySoldiers.push(s);
			entities.push(s);
		}
	}
	
	function spawnPlayerSoldiers ()
	{
		var n = 7;
		// Reset array
		if (playerSoldiers == null) {
			playerSoldiers = new Array();
		} else {
			while (playerSoldiers.length > 0) {
				playerSoldiers.pop().isDead = true;
			}
		}
		// Create soldiers
		for (i in 0...n) {
			var s = new Soldier(true);
			playerSoldiers.push(s);
			entities.push(s);
		}
	}
	
	public function update ()
	{
		// Update level entities
		for (e in entities) {
			e.update();
		}
		// Clean up dead level entities
		entities = entities.filter(Game.INST.filterDead);
		enemySoldiers = enemySoldiers.filter(Game.INST.filterDead);
		playerSoldiers = playerSoldiers.filter(Game.INST.filterDead);
	}
	
}
