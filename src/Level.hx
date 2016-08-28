package;


import Actions;
import haxe.Timer;
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
	var lastEnemyAction:ActionType;
	
	var playerAction:ActionType;
	var lastPlayerAction:ActionType;

	public function new (stage:Int)
	{
		this.stage = stage;
		
		ENEMY_TOWER_LINE = 65;
		PLAYER_TOWER_LINE = Game.WIDTH - 140;
		ENEMY_FRONT_LINE = Std.int(Game.WIDTH * 0.3);
		PLAYER_FRONT_LINE = Std.int(Game.WIDTH * 0.7);
		MIDDLE_LINE = Std.int(Game.WIDTH * 0.5);
		
		// Associate existing flags pairs with each action
		Actions.pairActionAndFlags();
		
		// Set max soldiers
		playerSoldiersMax = 7;
		enemySoldiersMax =  switch (stage) {
			default:	5;
		}
		
		// Set starting state
		state = CREATING;
		stateTick = 0;
		
		entities = [];
		
		// Spawn battlefield
		entities.push(new Battlefield());
		entities.push(new UIWood());
		
		// Spawn enemy tower and king
		enemyTower = new Tower(false);
		enemyKing = new King(false);
		entities.push(enemyTower);
		entities.push(enemyKing);
		// Spawn enemy soldiers
		enemySoldiers = new Array();
		// Prepare positions
		var sx = LARGE_SPREAD / enemySoldiersMax;
		var sy = ((Game.HEIGHT - 100) * 0.6) / enemySoldiersMax;
		var txArray = new Array<Int>();
		var tyArray = new Array<Int>();
		for (i in 0...enemySoldiersMax) {
			txArray.push(i);
			tyArray.push(i);
		}
		// Spawn and move in turn
		for (i in 0...enemySoldiersMax)
		{
			var tx = ENEMY_FRONT_LINE - LARGE_SPREAD / 2;
			tx += sx * txArray.splice(Std.random(txArray.length), 1)[0] - 32;
			var ty = sy * tyArray.splice(Std.random(tyArray.length), 1)[0];
			ty += (Game.HEIGHT - 100) * 0.3;
			ty += (Std.random(2) * 2 - 1) * Std.random(16);
			Timer.delay(spawnNewSoldier.bind(false, Std.int(tx), Std.int(ty)), (i+1) * 200 + (Std.random(2) * 2 - 1) * Std.random(150));
		}
		
		// Spawn player tower and king
		playerTower = new Tower(true);
		playerKing = new King(true);
		entities.push(playerTower);
		entities.push(playerKing);
		
		// Spawn player soldiers
		playerSoldiers = new Array();
		// Prepare positions
		var sx = LARGE_SPREAD / playerSoldiersMax;
		var sy = ((Game.HEIGHT - 100) * 0.6) / playerSoldiersMax;
		var txArray = new Array<Int>();
		var tyArray = new Array<Int>();
		for (i in 0...playerSoldiersMax) {
			txArray.push(i);
			tyArray.push(i);
		}
		// Spawn and move in turn
		for (i in 0...playerSoldiersMax)
		{
			var tx = PLAYER_FRONT_LINE - LARGE_SPREAD / 2;
			tx += sx * txArray.splice(Std.random(txArray.length), 1)[0] + 32;
			var ty = sy * tyArray.splice(Std.random(tyArray.length), 1)[0];
			ty += (Game.HEIGHT - 100) * 0.3;
			ty += (Std.random(2) * 2 - 1) * Std.random(16);
			Timer.delay(spawnNewSoldier.bind(true, Std.int(tx), Std.int(ty)), (i+1) * 200 + (Std.random(2) * 2 - 1) * Std.random(150));
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
				playerAction = ActionType.REST;
			// Update UI
			if (playerAction != IDLE)
				trace("new action chosen: " + playerAction);
		}
		else if (state == LevelState.RESOLVING)
		{
			// Wait for soldiers to stop moving
			if (stateTick <= 0 && !soldiersAreMoving())
			{
				if (playerAction == ActionType.ATTACK_UP)		fireArrows(true);
				if (enemyAction.action == ActionType.ATTACK_UP)	fireArrows(false);
				stateTick = 60;
			}
		}
		else if (state == LevelState.DONE)
		{
			// Wait for soldiers to stop moving
			if (stateTick <= 0 && !soldiersAreMoving())
			{
				for (s in enemySoldiers) {
					s.isComingBack = Std.random(2) == 0;
					s.setAnim(Sprites.IDLE);
				}
				for (s in playerSoldiers) {
					s.isComingBack = Std.random(2) == 0;
					s.setAnim(Sprites.IDLE);
				}
				stateTick = 60;
			}
		}
		else if (state == LevelState.CREATING)
		{
			if (stateTick <= 0 && !soldiersAreMoving())
			{
				for (s in enemySoldiers) {
					s.isComingBack = Std.random(2) == 0;
					s.setAnim(Sprites.IDLE);
				}
				for (s in playerSoldiers) {
					s.isComingBack = Std.random(2) == 0;
					s.setAnim(Sprites.IDLE);
				}
				stateTick = 60;
			}
		}
		
		enemyKing.x = enemyTower.x + enemyTower.cx - 8;
		enemyKing.y = enemyTower.y + enemyTower.roy - enemyKing.cy - 10;
		playerKing.x = playerTower.x + playerTower.cx - playerKing.w + 8;
		playerKing.y = playerTower.y + playerTower.roy - playerKing.cy - 10;
		
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
				resolve();
				
			case RESOLVING:
				state = DONE;
				// Send soldiers back to the tower
				if (playerAction == ActionType.ATTACK_FRONT)
					moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD, Sprites.RUN, true, true);
				if (enemyAction.action == ActionType.ATTACK_FRONT)
					moveSoldiers(false, ENEMY_FRONT_LINE, LARGE_SPREAD, Sprites.RUN, true, true);
				// Store last action
				lastPlayerAction = playerAction;
				lastEnemyAction = enemyAction.action;
				
			case DONE:
				state = CHOOSING_FLAGS;
				stateTick = 60;
				chooseAction();
				
			default:
				state = DONE;
				stateTick = 60;
		}
		trace("changed state to "+state);
	}
	
	function chooseAction ()
	{
		// Choose a random action and its correspondidsng flags
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
		
		// Move enemy soldiers
		switch (enemyAction.action)
		{
			case ActionType.ATTACK_FRONT:
				if (playerAction == ActionType.ATTACK_FRONT)	moveSoldiers(false, MIDDLE_LINE, NORMAL_SPREAD, Sprites.ATK_FRONT);
				else if (playerAction == ActionType.REST)		moveSoldiers(false, PLAYER_TOWER_LINE, NORMAL_SPREAD, Sprites.ATK_FRONT);
				else											moveSoldiers(false, PLAYER_FRONT_LINE, NORMAL_SPREAD, Sprites.ATK_FRONT);
			case ActionType.ATTACK_UP:
				moveSoldiers(false, ENEMY_FRONT_LINE, NORMAL_SPREAD, Sprites.ATK_UP);
			case ActionType.DEFEND_UP:
				moveSoldiers(false, ENEMY_FRONT_LINE, NORMAL_SPREAD, Sprites.DEF_UP);
			case ActionType.DEFEND_FRONT:
				moveSoldiers(false, ENEMY_FRONT_LINE, NARROW_SPREAD, Sprites.DEF_FRONT);
			case ActionType.REST:
				moveSoldiers(false, ENEMY_FRONT_LINE, LARGE_SPREAD, Sprites.IDLE);
			case ActionType.IDLE:
				if (lastEnemyAction != ActionType.IDLE)
					moveSoldiers(false, ENEMY_FRONT_LINE, LARGE_SPREAD, Sprites.IDLE);
		}
		
		// Move player soldiers
		switch (playerAction)
		{
			case ActionType.ATTACK_FRONT:
				if (enemyAction.action == ActionType.ATTACK_FRONT)	moveSoldiers(true, MIDDLE_LINE, NORMAL_SPREAD, Sprites.ATK_FRONT);
				else if (enemyAction.action == ActionType.REST)		moveSoldiers(true, ENEMY_TOWER_LINE, NORMAL_SPREAD, Sprites.ATK_FRONT);
				else												moveSoldiers(true, ENEMY_FRONT_LINE, NORMAL_SPREAD, Sprites.ATK_FRONT);
			case ActionType.ATTACK_UP:
				moveSoldiers(true, PLAYER_FRONT_LINE, NORMAL_SPREAD, Sprites.ATK_UP);
			case ActionType.DEFEND_UP:
				moveSoldiers(true, PLAYER_FRONT_LINE, NORMAL_SPREAD, Sprites.DEF_UP);
			case ActionType.DEFEND_FRONT:
				moveSoldiers(true, PLAYER_FRONT_LINE, NARROW_SPREAD, Sprites.DEF_FRONT);
			case ActionType.REST:
				moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD, Sprites.IDLE);
			case ActionType.IDLE:
				if (lastPlayerAction != ActionType.IDLE)
					moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD, Sprites.IDLE);
		}
		
		// RESOLVE ALL CASES
		// Enemy attack from the front
		if (enemyAction.action == ActionType.ATTACK_FRONT)
		{
			switch (playerAction)
			{
				// Both lose a soldier
				case ActionType.ATTACK_FRONT:
					trace("Both lose a soldier");
					//killRandomSoldier(false);
					//killRandomSoldier(true);
					
				// Player loses a soldier
				case ActionType.ATTACK_UP:
					trace("Player loses a soldier");
					//killRandomSoldier(true);
					
				// Player loses a soldier
				case ActionType.DEFEND_UP, ActionType.IDLE:
					trace("Player loses a soldier");
					//killRandomSoldier(true);
					
				// Player defends successfully - nothing happens
				case ActionType.DEFEND_FRONT:
					trace("Player defends successfully - nothing happens");
					
				// Player tower is hurt
				case ActionType.REST:
					trace("Player tower is hurt - player regains a soldier");
					//spawnNewSoldier(true);
			}
		}
		// Enemy attack from upwards
		else if (enemyAction.action == ActionType.ATTACK_UP)
		{
			switch (playerAction)
			{
				// Enemy loses a soldier
				case ActionType.ATTACK_FRONT:
					trace("Enemy loses a soldier");
					//killRandomSoldier(false);
					
				// Both lose a soldier
				case ActionType.ATTACK_UP:
					trace("Both lose a soldier");
					//killRandomSoldier(false);
					//killRandomSoldier(true);
					
				// Player loses a soldier
				case ActionType.DEFEND_FRONT, ActionType.IDLE:
					trace("Player loses a soldier");
					//killRandomSoldier(true);
					
				// Player defends successfully - nothing happens
				case ActionType.DEFEND_UP:
					trace("Player defends successfully - nothing happens");
					
				// Player tower is hurt
				case ActionType.REST:
					trace("Player tower is hurt - player regains a soldier");
					//spawnNewSoldier(true, playerTower.x - 32, playerTower.y - 200);
			}
		}
		// Enemy defends front
		else if (enemyAction.action == ActionType.DEFEND_FRONT)
		{
			switch (playerAction)
			{
				// Enemy loses a soldier
				case ActionType.ATTACK_UP:
					trace("Enemy loses a soldier");
					//killRandomSoldier(false);
					
				// Enemy defends successfully - nothing happens
				case ActionType.ATTACK_FRONT:
					trace("Enemy defends successfully - nothing happens");
					
				// Nothing happens
				case ActionType.DEFEND_FRONT, ActionType.DEFEND_UP, ActionType.IDLE:
					trace("Nothing happens");
					
				// Player regains a soldier
				case ActionType.REST:
					trace("Player regains a soldier");
					//spawnNewSoldier(true, playerTower.x - 32, playerTower.y - 200);
			}
		}
		// Enemy defends upwards
		else if (enemyAction.action == ActionType.DEFEND_UP)
		{
			switch (playerAction)
			{
				// Enemy loses a soldier
				case ActionType.ATTACK_FRONT:
					trace("Enemy loses a soldier");
					//killRandomSoldier(false);
					
				// Nothing happens
				case ActionType.ATTACK_UP:
					trace("Nothing happens");
					
				// Nothing happens
				case ActionType.DEFEND_FRONT, ActionType.DEFEND_UP, ActionType.IDLE:
					trace("Nothing happens");
					
				// Player regains a soldier
				case ActionType.REST:
					trace("Player regains a soldier");
					//spawnNewSoldier(true, playerTower.x - 32, playerTower.y - 200);
			}
		}
		// Enemy sleeps
		else if (enemyAction.action == ActionType.REST)
		{
			switch (playerAction)
			{
				// Enemy tower is hurt, player soldiers charge
				case ActionType.ATTACK_FRONT:
					trace("Enemy tower is hurt - enemy regains a soldier");
					//spawnNewSoldier(false);
					
				// Enemy tower is hurt
				case ActionType.ATTACK_UP:
					trace("Enemy tower is hurt - enemy regains a soldier");
					//spawnNewSoldier(false);
					
				// Enemy regains a soldier
				case ActionType.DEFEND_FRONT, ActionType.DEFEND_UP, ActionType.IDLE:
					trace("Enemy regains a soldier");
					//spawnNewSoldier(false);
					
				// Both regain a soldier
				case ActionType.REST:
					trace("Both regain a soldier");
					//spawnNewSoldier(true);
					//spawnNewSoldier(false);
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
	
	function spawnNewSoldier (forPlayer:Bool, tx:Int, ty:Int)
	{
		// Abort if already at max
		if ((forPlayer && playerSoldiers.length >= playerSoldiersMax) || (!forPlayer && enemySoldiers.length >= enemySoldiersMax))
			return;
		
		var s = new Soldier(forPlayer);
		if (forPlayer)	playerSoldiers.push(s);
		else			enemySoldiers.push(s);
		entities.push(s);
		
		var tower = (forPlayer) ? playerTower : enemyTower;
		s.y = tower.y + tower.roy + 100;
		
		s.setAnim(Sprites.RUN);
		s.moveTo(tx, ty, true);
	}
	
	function moveSoldiers (forPlayer:Bool, line:Int, spread:Int, anim:String = "", comingBack:Bool = false, idleOnArrival:Bool = false)
	{
		var a = (forPlayer) ? playerSoldiers : enemySoldiers;
		var dir = (forPlayer) ? 1 : -1;
		
		var sx = spread / a.length;
		var sy = ((Game.HEIGHT - 100) * 0.6) / a.length;
		var txArray = new Array<Int>();
		var tyArray = new Array<Int>();
		for (i in 0...a.length) {
			txArray.push(i);
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
			ty += (Game.HEIGHT - 100) * 0.3;
			ty += (Std.random(2) * 2 - 1) * Std.random(16);
			
			s.moveTo(tx, ty, idleOnArrival);
			s.isComingBack = comingBack;
			if (anim != "")	s.setAnim(anim);
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
	
	function fireArrows (forPlayer:Bool)
	{
		var soldiers = (forPlayer) ? playerSoldiers : enemySoldiers;
		for (s in soldiers)
		{
			var  arrow = new Arrow(forPlayer);
			arrow.x = s.x;
			arrow.y = s.y;
			entities.push(arrow);
		}
	}
	
}

enum LevelState {
	CREATING;
	CHOOSING_FLAGS;
	PROPAGATING;
	RESOLVING;
	DONE;
}
