package;


import Actions;
import openfl.ui.Keyboard;

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
	
	var enemyAction:Action;
	var playerAction:ActionType;

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
		
		if (state == LevelState.PROPAGATING)
		{
			var prevAction = playerAction;
			// Check controls
			if (Controls.isDown(Keyboard.LEFT))
				playerAction = ActionType.ATTACK_FRONT;
			else if (Controls.isDown(Keyboard.UP))
				playerAction = ActionType.ATTACK_UP;
			else if (Controls.isDown(Keyboard.RIGHT))
				playerAction = ActionType.DEFEND_FRONT;
			else if (Controls.isDown(Keyboard.DOWN))
				playerAction = ActionType.DEFEND_UP;
			else if (Controls.isDown(Keyboard.SPACE))
				playerAction = ActionType.SLEEP;
			// Update UI
			if (prevAction != playerAction)
				trace("new action chosen: " + playerAction);
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
				
			case PROPAGATING:
				state = RESOLVING;
				stateTick = 60;
				resolve();
				
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
		enemyAction = Actions.pickRandomAction();
		playerAction = ActionType.IDLE;
		trace(enemySoldiers.length + " / " + playerSoldiers.length);
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
	
	function resolve ()
	{
		trace("Enemy action: " + enemyAction.action);
		trace("Player action: " + playerAction);
		trace("----");
		
		// Enemy attack from the front
		if (enemyAction.action == ATTACK_FRONT)
		{
			switch (playerAction)
			{
				// Both lose a soldier
				case ATTACK_FRONT:
					trace("Both lose a soldier");
					killRandomSoldier(true);
					killRandomSoldier(false);
					
				// Player loses a soldier
				case ATTACK_UP, DEFEND_UP, IDLE:
					trace("Player loses a soldier");
					killRandomSoldier(false);
					
				// Player tower is hurt
				case SLEEP:
					trace("Player tower is hurt");
					
				// Player defends successfully - nothing happens
				case DEFEND_FRONT:
					trace("Player defends successfully - nothing happens");
			}
		}
		// Enemy attack from upwards
		else if (enemyAction.action == ATTACK_UP)
		{
			switch (playerAction)
			{
				// Enemy loses a soldier
				case ATTACK_FRONT:
					trace("Enemy loses a soldier");
					killRandomSoldier(true);
					
				// Both lose a soldier
				case ATTACK_UP:
					trace("Both lose a soldier");
					killRandomSoldier(true);
					killRandomSoldier(false);
					
				// Player loses a soldier
				case DEFEND_FRONT, IDLE:
					trace("Player loses a soldier");
					killRandomSoldier(false);
					
				// Player defends successfully - nothing happens
				case DEFEND_UP:
					trace("Player defends successfully - nothing happens");
					
				// Player tower is hurt
				case SLEEP:
					trace("Player tower is hurt");
			}
		}
		// Enemy defends front
		else if (enemyAction.action == DEFEND_FRONT)
		{
			switch (playerAction)
			{
				// Enemy loses a soldier
				case ATTACK_UP:
					trace("Enemy loses a soldier");
					killRandomSoldier(true);
					
				// Nothing happens
				case ATTACK_FRONT, DEFEND_FRONT, DEFEND_UP, IDLE:
					trace("Nothing happens");
					
				// Player regains a soldier
				case SLEEP:
					trace("Player regains a soldier");
			}
		}
		// Enemy defends upwards
		else if (enemyAction.action == DEFEND_UP)
		{
			switch (playerAction)
			{
				// Enemy loses a soldier
				case ATTACK_FRONT:
					trace("Enemy loses a soldier");
					killRandomSoldier(true);
					
				// Nothing happens
				case ATTACK_UP, DEFEND_FRONT, DEFEND_UP, IDLE:
					trace("Nothing happens");
					
				// Player regains a soldier
				case SLEEP:
					trace("Player regains a soldier");
			}
		}
		// Enemy sleeps
		else if (enemyAction.action == SLEEP)
		{
			switch (playerAction)
			{
				// Enemy tower is hurt
				case ATTACK_FRONT, ATTACK_UP:
					trace("Enemy tower is hurt");
					
				// Enemy regains a soldier
				case DEFEND_FRONT, DEFEND_UP, IDLE:
					trace("Enemy regains a soldier");
					
				// Both regain a soldier
				case SLEEP:
					trace("Both regain a soldier");
			}
		}
	}
	
	function killRandomSoldier (enemy:Bool)
	{
		var s = null;
		if (enemy)	s = enemySoldiers[Std.random(enemySoldiers.length)];
		else		s = playerSoldiers[Std.random(playerSoldiers.length)];
		
		s.hurt();
		trace("isDead: " + s.isDead);
	}
	
}

enum LevelState {
	CREATING;
	CHOOSING_FLAGS;
	PROPAGATING;
	RESOLVING;
	DONE;
}
