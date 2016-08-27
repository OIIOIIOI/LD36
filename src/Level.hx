package;


import Actions;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class Level
{
	
	static public var ENEMY_TOWER_LINE:Int;
	static public var PLAYER_TOWER_LINE:Int;
	static public var ENEMY_FRONT_LINE:Int;
	static public var PLAYER_FRONT_LINE:Int;
	static public var MIDDLE_LINE:Int;
	
	static public var NARROW_SPREAD:Int = 16;
	static public var NORMAL_SPREAD:Int = 32;
	static public var LARGE_SPREAD:Int = 128;
	
	var enemySoldiersMax:Int;
	var playerSoldiersMax:Int;
	
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
		
		ENEMY_TOWER_LINE = Std.int(Game.WIDTH * 0.125);
		PLAYER_TOWER_LINE = Std.int(Game.WIDTH * 0.875);
		ENEMY_FRONT_LINE = Std.int(Game.WIDTH * 0.3);
		PLAYER_FRONT_LINE = Std.int(Game.WIDTH * 0.7);
		MIDDLE_LINE = Std.int(Game.WIDTH * 0.5);
		
		// Set starting state
		state = CREATING;
		nextState();
		
		entities = [];
		
		entities.push(new Battlefield());
		
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
		enemySoldiersMax =  switch (stage) {
			default:	5;
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
		for (i in 0...enemySoldiersMax) {
			var s = new Soldier(false);
			enemySoldiers.push(s);
			entities.push(s);
		}
	}
	
	function spawnPlayerSoldiers ()
	{
		playerSoldiersMax = 7;
		// Reset array
		if (playerSoldiers == null) {
			playerSoldiers = new Array();
		} else {
			while (playerSoldiers.length > 0) {
				playerSoldiers.pop().isDead = true;
			}
		}
		// Create soldiers
		for (i in 0...playerSoldiersMax) {
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
		
		if (state == LevelState.PROPAGATING && playerAction == IDLE)
		{
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
			if (playerAction != IDLE)
				trace("new action chosen: " + playerAction);
		}
		else if (state == LevelState.RESOLVING)
		{
			// Wait for soldiers to stop moving
			if (stateTick <= 0 && !soldiersAreMoving())
			{
				stateTick = 60;
			}
		}
		else if (state == LevelState.DONE)
		{
			// Wait for soldiers to stop moving
			if (stateTick <= 0 && !soldiersAreMoving())
			{
				stateTick = 60;
			}
		}
		
		enemyKing.x = enemyTower.x + enemyTower.cx;
		enemyKing.y = enemyTower.y + enemyTower.roy - enemyKing.cy;
		playerKing.x = playerTower.x + playerTower.cx - playerKing.w;
		playerKing.y = playerTower.y + playerTower.roy - playerKing.cy;
		
		// Update level entities
		for (e in entities) {
			e.update();
		}
		// Clean up dead level entities
		entities = entities.filter(Game.INST.filterDead);
		enemySoldiers = enemySoldiers.filter(Game.INST.filterDead);
		playerSoldiers = playerSoldiers.filter(Game.INST.filterDead);
		// Z-sort
		entities.sort(zSort);
		enemySoldiers.sort(zSort);
		playerSoldiers.sort(zSort);
	}
	
	function zSort (a:Entity, b:Entity)
	{
		if (a.y + a.cy > b.y + b.cy)		return 1;
		else if (a.y + a.cy < b.y + b.cy)	return -1;
		else								return 0;
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
				//stateTick = 60;
				resolve();
				
			case RESOLVING:
				state = DONE;
				//stateTick = 60;
				moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD);
				moveSoldiers(false, ENEMY_FRONT_LINE, LARGE_SPREAD);
				
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
		trace(enemyAction.action + " vs " + playerAction);
		trace("----");
		
		switch (enemyAction.action)
		{
			case ATTACK_FRONT:
				if (playerAction == ATTACK_FRONT)	moveSoldiers(false, MIDDLE_LINE, NORMAL_SPREAD);
				else if (playerAction == SLEEP)		moveSoldiers(false, PLAYER_TOWER_LINE, NORMAL_SPREAD);
				else								moveSoldiers(false, PLAYER_FRONT_LINE, NORMAL_SPREAD);
			case ATTACK_UP, DEFEND_UP:
				moveSoldiers(false, ENEMY_FRONT_LINE, NORMAL_SPREAD);
			case DEFEND_FRONT:
				moveSoldiers(false, ENEMY_FRONT_LINE, NARROW_SPREAD);
			case SLEEP, IDLE:
				moveSoldiers(false, ENEMY_FRONT_LINE, LARGE_SPREAD);
		}
		switch (playerAction)
		{
			case ATTACK_FRONT:
				if (enemyAction.action == ATTACK_FRONT)	moveSoldiers(true, MIDDLE_LINE, NORMAL_SPREAD);
				else if (enemyAction.action == SLEEP)	moveSoldiers(true, ENEMY_TOWER_LINE, NORMAL_SPREAD);
				else									moveSoldiers(true, ENEMY_FRONT_LINE, NORMAL_SPREAD);
			case ATTACK_UP, DEFEND_UP:
				moveSoldiers(true, PLAYER_FRONT_LINE, NORMAL_SPREAD);
			case DEFEND_FRONT:
				moveSoldiers(true, PLAYER_FRONT_LINE, NARROW_SPREAD);
			case SLEEP, IDLE:
				moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD);
		}
		
		// Enemy attack from the front
		if (enemyAction.action == ATTACK_FRONT)
		{
			switch (playerAction)
			{
				// Both lose a soldier
				case ATTACK_FRONT:
					trace("Both lose a soldier");
					//killRandomSoldier(false);
					//killRandomSoldier(true);
					
				// Player loses a soldier
				case ATTACK_UP, DEFEND_UP, IDLE:
					trace("Player loses a soldier");
					//killRandomSoldier(true);
					
				// Player defends successfully - nothing happens
				case DEFEND_FRONT:
					trace("Player defends successfully - nothing happens");
					
				// Player tower is hurt
				case SLEEP:
					trace("Player tower is hurt - player regains a soldier");
					//spawnNewSoldier(true);
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
					//killRandomSoldier(false);
					
				// Both lose a soldier
				case ATTACK_UP:
					trace("Both lose a soldier");
					//killRandomSoldier(false);
					//killRandomSoldier(true);
					
				// Player loses a soldier
				case DEFEND_FRONT, IDLE:
					trace("Player loses a soldier");
					//killRandomSoldier(true);
					
				// Player defends successfully - nothing happens
				case DEFEND_UP:
					trace("Player defends successfully - nothing happens");
					
				// Player tower is hurt
				case SLEEP:
					trace("Player tower is hurt - player regains a soldier");
					spawnNewSoldier(true);
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
					//killRandomSoldier(false);
					
				// Enemy defends successfully - nothing happens
				case ATTACK_FRONT:
					trace("Enemy defends successfully - nothing happens");
					
				// Nothing happens
				case DEFEND_FRONT, DEFEND_UP, IDLE:
					trace("Nothing happens");
					
				// Player regains a soldier
				case SLEEP:
					trace("Player regains a soldier");
					spawnNewSoldier(true);
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
					//killRandomSoldier(false);
					
				// Nothing happens
				case ATTACK_UP, DEFEND_FRONT, DEFEND_UP, IDLE:
					trace("Nothing happens");
					
				// Player regains a soldier
				case SLEEP:
					trace("Player regains a soldier");
					spawnNewSoldier(true);
			}
		}
		// Enemy sleeps
		else if (enemyAction.action == SLEEP)
		{
			switch (playerAction)
			{
				// Enemy tower is hurt, player soldiers charge
				case ATTACK_FRONT:
					trace("Enemy tower is hurt - enemy regains a soldier");
					//spawnNewSoldier(false);
					
				// Enemy tower is hurt
				case ATTACK_UP:
					trace("Enemy tower is hurt - enemy regains a soldier");
					spawnNewSoldier(false);
					
				// Enemy regains a soldier
				case DEFEND_FRONT, DEFEND_UP, IDLE:
					trace("Enemy regains a soldier");
					spawnNewSoldier(false);
					
				// Both regain a soldier
				case SLEEP:
					trace("Both regain a soldier");
					spawnNewSoldier(true);
					spawnNewSoldier(false);
			}
		}
	}
	
	function killRandomSoldier (forPlayer:Bool)
	{
		var s = null;
		if (forPlayer)	s = playerSoldiers[Std.random(playerSoldiers.length)];
		else			s = enemySoldiers[Std.random(enemySoldiers.length)];
		s.hurt();
	}
	
	function spawnNewSoldier (forPlayer:Bool)
	{
		// Abort if already at max
		if ((forPlayer && playerSoldiers.length >= playerSoldiersMax) || (!forPlayer && enemySoldiers.length >= enemySoldiersMax))
			return;
		
		var s = new Soldier(forPlayer);
		if (forPlayer)	playerSoldiers.push(s);
		else			enemySoldiers.push(s);
		entities.push(s);
	}
	
	function moveSoldiers (forPlayer:Bool, line:Int, spread:Int)
	{
		var a = (forPlayer) ? playerSoldiers : enemySoldiers;
		var dir = (forPlayer) ? 1 : -1;
		
		var sx = spread / a.length;
		var txArray = new Array<Int>();
		for (i in 0...a.length) {
			txArray.push(i);
		}
		
		var sy = ((Game.HEIGHT - 100) * 0.6) / a.length;
		var tyArray = new Array<Int>();
		for (i in 0...a.length) {
			tyArray.push(i);
		}
		
		for (s in a) {
			var tx = line - spread / 2;
			tx += sx * txArray.splice(Std.random(txArray.length), 1)[0];
			if (!forPlayer)	tx -= 32;
			else			tx += 32;
			
			var i = 0;
			if (tyArray.length > 2 && Std.random(4) == 0)	i = 1;
			var ty = sy * tyArray.splice(i, 1)[0];
			//var ty = sy * tyArray.shift();
			ty += (Game.HEIGHT - 100) * 0.3;
			ty += (Std.random(2) * 2 - 1) * Std.random(16);
			
			s.moveTo(tx, ty);
		}
	}
	
	function soldiersAreMoving () :Bool
	{
		for (s in enemySoldiers)
		{
			if (s.isMoving())
				return true;
		}
		for (s in playerSoldiers)
		{
			if (s.isMoving())
				return true;
		}
		return false;
	}
	
}

enum LevelState {
	CREATING;
	CHOOSING_FLAGS;
	PROPAGATING;
	RESOLVING;
	DONE;
}
