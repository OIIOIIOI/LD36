package;

/**
 * ...
 * @author 01101101
 */
class Level
{
	
	var stage:Int;
	
	var enemyTower:Tower;
	var enemyKing:King;
	var enemySoldiers:Array<Soldier>;
	
	var playerTower:Tower;
	var playerKing:King;
	var playerSoldiers:Array<Soldier>;
	
	public var entities:Array<Entity>;
	
	var state:LevelState;
	var stateTick:Int;

	public function new (stage:Int)
	{
		this.stage = stage;
		
		// Set starting state
		state = CREATING;
		nextState();
		
		entities = [];
		
		enemyTower = new Tower(false);
		entities.push(enemyTower);
		enemyKing = new King(false);
		entities.push(enemyKing);
		spawnEnemySoldiers();
		
		playerTower = new Tower(true);
		entities.push(playerTower);
		playerKing = new King(true);
		entities.push(playerKing);
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
		if (stateTick > 0) {
			stateTick--;
			if (stateTick <= 0)
				nextState();
		}
		
		enemyKing.x = enemyTower.x;
		enemyKing.y = enemyTower.y - 48;
		playerKing.x = playerTower.x;
		playerKing.y = playerTower.y - 48;
		
		// Update level entities
		for (e in entities) {
			e.update();
		}
		// Clean up dead level entities
		entities = entities.filter(Game.INST.filterDead);
		enemySoldiers = enemySoldiers.filter(Game.INST.filterDead);
		playerSoldiers = playerSoldiers.filter(Game.INST.filterDead);
	}
	
	public function nextState ()
	{
		switch (state)
		{
			case CHOOSING_FLAGS:
				state = PROPAGATING;
				stateTick = propagate();
				trace(stateTick);
				
			case PROPAGATING:
				state = RESOLVING;
				stateTick = 60;
				
			case RESOLVING:
				state = DONE;
				stateTick = 60;
				
			case DONE:
				state = CHOOSING_FLAGS;
				stateTick = 60;
				chooseAction();
				
			default:
				state = DONE;
				stateTick = 60;
				setup();
		}
		trace("changed state to "+state);
	}
	
	function setup ()
	{
		// Associate existing flags pairs with each action
		Actions.pairActionAndFlags();
	}
	
	function chooseAction ()
	{
		// Choose a random action and its corresponding flags
		var currentAction = Actions.pickRandomAction();
		trace("picked " + currentAction.action);
	}
	
	function propagate () :Int
	{
		var tick = 20;
		var i = 0;
		for (s in enemySoldiers)
		{
			var t = 25 + (Std.random(2) * 2 - 1) * Std.random(15);
			tick += t;
			s.think(tick);
		}
		return tick;
	}
	
}

enum LevelState {
	CREATING;
	CHOOSING_FLAGS;
	PROPAGATING;
	RESOLVING;
	DONE;
}
