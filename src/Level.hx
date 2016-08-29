package;

import Actions;
import Game;
import Particle;
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class Level extends Screen
{
	
	static public var ENEMY_TOWER_LINE:Int;
	static public var PLAYER_TOWER_LINE:Int;
	static public var ENEMY_FRONT_LINE:Int;
	static public var PLAYER_FRONT_LINE:Int;
	static public var MIDDLE_LINE:Int;
	
	static public var NARROW_SPREAD:Int = 16;
	static public var NORMAL_SPREAD:Int = 32;
	static public var LARGE_SPREAD:Int = 128;
	
	public var emotes:Array<Entity>;
	
	public var enemySoldiersMax:Int;
	var playerSoldiersMax:Int;
	
	var stage:Int;
	
	var enemyTower:Tower;
	var enemyKing:King;
	public var enemySoldiers:Array<Soldier>;
	
	var playerTower:Tower;
	var playerKing:King;
	var playerSoldiers:Array<Soldier>;
	
	var flagLeft:Flag;
	var flagRight:Flag;
	var bigFlagLeft:BigFlag;
	var bigFlagRight:BigFlag;
	
	var state:LevelState;
	var stateTick:Int;
	
	var enemyAction:Action;
	var lastEnemyAction:ActionType;
	
	var playerAction:ActionType;
	var lastPlayerAction:ActionType;
	
	var enemySoldiersUI:UISoldiers;
	var playerSoldiersUI:UISoldiers;
	
	var gameIsOver:Bool;
	
	var buttons:Buttons;
	var enemyActionText:ActionText;
	var playerActionText:ActionText;
	
	var propagTime:Int;

	public function new (stage:Int)
	{
		super();
		
		this.stage = stage;
		
		gameIsOver = false;
		
		ENEMY_TOWER_LINE = 65;
		PLAYER_TOWER_LINE = Game.WIDTH - 140;
		ENEMY_FRONT_LINE = Std.int(Game.WIDTH * 0.3);
		PLAYER_FRONT_LINE = Std.int(Game.WIDTH * 0.7);
		MIDDLE_LINE = Std.int(Game.WIDTH * 0.5);
		
		// Associate existing flags pairs with each action
		Actions.pairActionAndFlags();
		
		// Set max soldiers
		playerSoldiersMax = switch (stage)
		{
			case 0:		7;//7
			case 1:		6;
			case 2:		5;
			case 3:		4;
			default:	3;
		}
		enemySoldiersMax = switch (stage)
		{
			default:	5;
		}
		propagTime = switch (stage)
		{
			case 0:		60;
			case 1:		50;
			case 2:		40;
			default:	30;
		}
		
		// Set starting state
		state = LevelState.CREATING;
		stateTick = 0;
		
		// Init lists
		emotes = [];
		
		// Spawn battlefield
		entities.push(new Battlefield());
		// Spawn UI
		entities.push(new UIWood());
		entities.push(new Parchment(false));
		entities.push(new Parchment(true));
		// Player soldiers UI
		enemySoldiersUI = new UISoldiers(enemySoldiersMax, 0);
		for (e in enemySoldiersUI.entities)	entities.push(e);
		// Player soldiers UI
		playerSoldiersUI = new UISoldiers(playerSoldiersMax, Game.WIDTH - 190);
		for (e in playerSoldiersUI.entities)	entities.push(e);
		// Enemy actions UI
		enemyActionText = new ActionText(false);
		entities.push(enemyActionText);
		// Player actions UI
		playerActionText = new ActionText(true);
		entities.push(playerActionText);
		// Big flags
		bigFlagLeft = new BigFlag(Sprites.BLANK, true);
		entities.push(bigFlagLeft);
		bigFlagRight = new BigFlag(Sprites.BLANK, false);
		entities.push(bigFlagRight);
		
		// Spawn enemy tower and king
		enemyTower = new Tower(false);
		enemyKing = new King(false);
		entities.push(enemyTower);
		entities.push(enemyKing);
		// Spawn enemy soldiers
		enemySoldiers = new Array();
		// Prepare positions
		var posArrays = getIndexesArrays(false);
		var txArray = posArrays[0];
		var tyArray = posArrays[1];
		var sx = LARGE_SPREAD / enemySoldiersMax;
		var sy = ((Game.HEIGHT - 100) * 0.6) / enemySoldiersMax;
		// Spawn and move in turn
		for (i in 0...enemySoldiersMax)
		{
			var tx = ENEMY_FRONT_LINE - LARGE_SPREAD / 2;
			tx += sx * txArray.splice(Std.random(txArray.length), 1)[0] - 32;
			var ty = sy * tyArray.splice(Std.random(tyArray.length), 1)[0];
			ty += (Game.HEIGHT - 100) * 0.2;
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
		var posArrays = getIndexesArrays(true);
		var txArray = posArrays[0];
		var tyArray = posArrays[1];
		var sx = LARGE_SPREAD / playerSoldiersMax;
		var sy = ((Game.HEIGHT - 100) * 0.6) / playerSoldiersMax;
		// Spawn and move in turn
		for (i in 0...playerSoldiersMax)
		{
			var tx = PLAYER_FRONT_LINE - LARGE_SPREAD / 2;
			tx += sx * txArray.splice(Std.random(txArray.length), 1)[0] + 32;
			var ty = sy * tyArray.splice(Std.random(tyArray.length), 1)[0];
			ty += (Game.HEIGHT - 100) * 0.2;
			ty += (Std.random(2) * 2 - 1) * Std.random(16);
			Timer.delay(spawnNewSoldier.bind(true, Std.int(tx), Std.int(ty)), (i+1) * 200 + (Std.random(2) * 2 - 1) * Std.random(150));
		}
		
		buttons = new Buttons();
	}
	
	override public function update ()
	{
		if (stateTick > 0) {
			stateTick--;
			if (stateTick <= 0)
				nextState();
		}
		
		if (state == LevelState.PROPAGATING && playerAction == ActionType.IDLE)
		{
			// Check controls
			if (Controls.isDown(Keyboard.G)) {
				playerAction = ActionType.ATTACK_FRONT;
				buttons.select(2);
				playerActionText.setAnim(Sprites.TEXT_LOADING);
				Game.INST.removeChild(Game.INST.clickButtons);
			}
			else if (Controls.isDown(Keyboard.H)) {
				playerAction = ActionType.ATTACK_UP;
				buttons.select(3);
				playerActionText.setAnim(Sprites.TEXT_LOADING);
				Game.INST.removeChild(Game.INST.clickButtons);
			}
			else if (Controls.isDown(Keyboard.D)) {
				playerAction = ActionType.DEFEND_FRONT;
				buttons.select(0);
				playerActionText.setAnim(Sprites.TEXT_LOADING);
				Game.INST.removeChild(Game.INST.clickButtons);
			}
			else if (Controls.isDown(Keyboard.F)) {
				playerAction = ActionType.DEFEND_UP;
				buttons.select(1);
				playerActionText.setAnim(Sprites.TEXT_LOADING);
				Game.INST.removeChild(Game.INST.clickButtons);
			}
			else if (Controls.isDown(Keyboard.J)) {
				playerAction = ActionType.REST;
				buttons.select(4);
				playerActionText.setAnim(Sprites.TEXT_LOADING);
				Game.INST.removeChild(Game.INST.clickButtons);
			}
		}
		else if (state == LevelState.MOVING)
		{
			// Wait for soldiers to stop moving
			if (stateTick <= 0 && !soldiersAreMoving())
			{
				// Fire arrows
				if (playerAction == ActionType.ATTACK_UP)		fireArrows(true);
				if (enemyAction.action == ActionType.ATTACK_UP)	fireArrows(false);
				// Resolve lance kills
				Timer.delay(resolveLanceKills, 100);
				// Hide flags
				if (flagLeft != null)	flagLeft.isDead = true;
				if (flagRight != null)	flagRight.isDead = true;
				// Wait
				stateTick = 60;
			}
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
				for (s in enemySoldiers) {
					s.isComingBack = Std.random(2) == 0;
					s.setAnim(Sprites.IDLE);
				}
				for (s in playerSoldiers) {
					s.isComingBack = Std.random(2) == 0;
					s.setAnim(Sprites.IDLE);
				}
				// Time before flag showing
				stateTick = 120;
				//
				playerActionText.setAnim(Sprites.BLANK);
				enemyActionText.setAnim(Sprites.BLANK);
				bigFlagLeft.setAnim(Sprites.BLANK);
				bigFlagRight.setAnim(Sprites.BLANK);
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
		else if (state == LevelState.DEFEAT || state == LevelState.VICTORY)
		{
			if (Controls.isDown(Keyboard.SPACE))
				Game.INST.changeScreen(new TitleScreen());
		}
		
		enemyKing.x = enemyTower.x + enemyTower.cx - 27;
		enemyKing.y = enemyTower.y + enemyTower.roy - enemyKing.cy - 15;
		if (enemyTower.health == 2)			enemyKing.y += 45;
		else if (enemyTower.health <= 1)	enemyKing.y += 130;
		
		playerKing.x = playerTower.x + playerTower.cx - playerKing.w + 27;
		playerKing.y = playerTower.y + playerTower.roy - playerKing.cy - 15;
		if (playerTower.health == 2)		playerKing.y += 45;
		else if (playerTower.health <= 1)	playerKing.y += 130;
		
		// Update
		super.update();
		for (e in emotes) {
			e.update();
		}
		for (e in buttons.entities) {
			e.update();
		}
		
		// Update UI
		enemySoldiersUI.activate(enemySoldiers.length);
		playerSoldiersUI.activate(playerSoldiers.length);
	}
	
	override public function filterDead ()
	{
		super.filterDead();
		enemySoldiers = enemySoldiers.filter(Game.INST.filterDead);
		playerSoldiers = playerSoldiers.filter(Game.INST.filterDead);
		emotes = emotes.filter(Game.INST.filterDead);
	}
	
	override public function postUpdate ()
	{
		super.postUpdate();
		for (e in emotes) {
			e.postUpdate();
		}
		for (e in buttons.entities) {
			e.postUpdate();
		}
		// Z-sort
		enemySoldiers.sort(zSort);
		playerSoldiers.sort(zSort);
		entities.sort(zSort);
	}
	
	override public function render (canvasData:BitmapData)
	{
		super.render(canvasData);
		renderArray(emotes, canvasData);
		renderArray(buttons.entities, canvasData);
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
			case LevelState.CHOOSING_FLAGS:
				state = LevelState.PROPAGATING;
				Game.INST.addChild(Game.INST.clickButtons);
				buttons.allowChoice();
				stateTick = propagate();
				
			case LevelState.PROPAGATING:
				state = LevelState.MOVING;
				// Move soldiers
				move();
				updateActionText(playerActionText, playerAction);
				updateActionText(enemyActionText, enemyAction.action);
				buttons.reset();
				Game.INST.removeChild(Game.INST.clickButtons);
				
			case LevelState.MOVING:
				state = LevelState.RESOLVING;
				// Resolve
				resolve();
				
			case LevelState.RESOLVING:
				state = LevelState.DONE;
				buttons.reset();
				// Send soldiers back to the tower
				if (playerAction == ActionType.ATTACK_FRONT)
					moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD, Sprites.RUN, true, true);
				if (enemyAction.action == ActionType.ATTACK_FRONT)
					moveSoldiers(false, ENEMY_FRONT_LINE, LARGE_SPREAD, Sprites.RUN, true, true);
				// Store last action
				lastPlayerAction = playerAction;
				lastEnemyAction = enemyAction.action;
				
			case LevelState.DONE:
				state = LevelState.CHOOSING_FLAGS;
				stateTick = 1;
				if (!checkIfGameOver()) {
					chooseAction();
				}
				
			case LevelState.CREATING:
				state = LevelState.DONE;
				stateTick = 120;
				
			default:
		}
		// trace(Date.now().getTime() + ": changed state to " + state);
	}
	
	function chooseAction ()
	{
		// Choose a random action and its corresponding flags
		enemyAction = Actions.pickRandomAction();
		
		if (flagLeft != null)	entities.remove(flagLeft);
		flagLeft = new Flag(enemyAction.flags[0].variant);
		flagLeft.x = enemyKing.x - flagLeft.w * 0.9 + 30;
		flagLeft.y = enemyKing.y - flagLeft.zOffset;
		entities.push(flagLeft);

		bigFlagLeft.setAnim(Sprites.BIG + enemyAction.flags[0].variant);
		
		if (flagRight != null)	entities.remove(flagRight);
		flagRight = new Flag(enemyAction.flags[1].variant);
		flagRight.x = enemyKing.x + 30;
		flagRight.y = enemyKing.y - flagRight.zOffset;
		entities.push(flagRight);

		bigFlagRight.setAnim(Sprites.BIG + enemyAction.flags[1].variant);
		
		playerAction = ActionType.IDLE;

		playerActionText.setAnim(Sprites.TEXT_YOUR_TURN);
		enemyActionText.setAnim(Sprites.TEXT_LOADING);
	}
	
	function propagate () :Int
	{
		var tick = 20;
		var i = 0;
		for (s in enemySoldiers)
		{
			tick += propagTime;
			s.think(tick);
			var emote = new Emote(Sprites.EMOTE_THINK);
			emote.x = s.x;
			emote.y = s.y;
			emotes.push(emote);
			s.emote = emote;
		}
		return tick;
	}
	
	function move ()
	{
		// Hide emotes
		for (e in emotes) {
			e.isDead = true;
		}
		
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
				//moveSoldiers(false, ENEMY_FRONT_LINE, LARGE_SPREAD, Sprites.IDLE);
				for (s in enemySoldiers)	s.sleep();
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
				//moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD, Sprites.IDLE);
				for (s in playerSoldiers)	s.sleep();
			case ActionType.IDLE:
				if (lastPlayerAction != ActionType.IDLE)
					moveSoldiers(true, PLAYER_FRONT_LINE, LARGE_SPREAD, Sprites.IDLE);
		}
	}
	
	function resolveLanceKills ()
	{
		// Return if no lance attacks
		if (playerAction != ActionType.ATTACK_FRONT && enemyAction.action != ActionType.ATTACK_FRONT)
			return;
		
		// If both lance attacks
		if (playerAction == ActionType.ATTACK_FRONT &&
			enemyAction.action == ActionType.ATTACK_FRONT)
		{
			killRandomSoldier(false, false);
			killRandomSoldier(true, false);
			SoundMan.playOnce(SoundMan.FAIL);
		}
		// If player lance attack
		else if (playerAction == ActionType.ATTACK_FRONT &&
				(enemyAction.action == ActionType.IDLE ||
				enemyAction.action == ActionType.DEFEND_UP ||
				enemyAction.action == ActionType.ATTACK_UP))
		{
			killRandomSoldier(false, false);
		}
		// If player lance attack against tower
		else if (playerAction == ActionType.ATTACK_FRONT &&
				enemyAction.action == ActionType.REST)
		{
			hurtTower(false);
		}
		// If enemy lance attack
		else if (enemyAction.action == ActionType.ATTACK_FRONT &&
				(playerAction == ActionType.IDLE ||
				playerAction == ActionType.DEFEND_UP ||
				playerAction == ActionType.ATTACK_UP))
		{
			killRandomSoldier(true, false);
			SoundMan.playOnce(SoundMan.FAIL);
		}
		// If enemy lance attack against tower
		else if (enemyAction.action == ActionType.ATTACK_FRONT &&
				playerAction == ActionType.REST)
		{
			hurtTower(true);
			SoundMan.playOnce(SoundMan.FAIL);
		}
	}
	
	function resolve ()
	{
		// Hide emotes
		for (e in emotes) {
			e.isDead = true;
		}
		
		// ATTACK_FRONT vs ATTACK_FRONT or ATTACK_UP or DEFEND_UP or IDLE -> resolved by resolveLanceKills
		// ATTACK_FRONT vs DEFEND_FRONT -> nothing happens
		// ATTACK_FRONT vs REST
		if (enemyAction.action == ActionType.ATTACK_FRONT &&
			playerAction == ActionType.REST)
		{
			// Player regains a soldier
			var p = getSpawnSpot(true);
			spawnNewSoldier(true, p[0], p[1]);
		}
		
		// ATTACK_UP vs ATTACK_FRONT -> resolved by resolveLanceKills
		// ATTACK_UP vs DEFEND_UP -> nothing happens
		// ATTACK_UP vs ATTACK_UP
		if (enemyAction.action == ActionType.ATTACK_UP &&
			playerAction == ActionType.ATTACK_UP)
		{
			// Both lose a soldier
			killRandomSoldier(false, true);
			killRandomSoldier(true, true);
			SoundMan.playOnce(SoundMan.FAIL);
		}
		// ATTACK_UP vs DEFEND_FRONT or IDLE
		else if (enemyAction.action == ActionType.ATTACK_UP &&
				(playerAction == ActionType.DEFEND_FRONT ||
				playerAction == ActionType.IDLE))
		{
			// Player loses a soldier
			killRandomSoldier(true, true);
			SoundMan.playOnce(SoundMan.FAIL);
		}
		// ATTACK_UP vs REST
		else if (enemyAction.action == ActionType.ATTACK_UP &&
				playerAction == ActionType.REST)
		{
			// Player loses a soldier - player regains a soldier
			killRandomSoldier(true, true);
			var p = getSpawnSpot(true);
			spawnNewSoldier(true, p[0], p[1]);
		}
		
		// DEFEND_FRONT vs ATTACK_FRONT or DEFEND_FRONT or DEFEND_UP or IDLE -> nothing happens
		// DEFEND_FRONT vs ATTACK_UP
		if (enemyAction.action == ActionType.DEFEND_FRONT &&
			playerAction == ActionType.ATTACK_UP)
		{
			// Enemy loses a soldier
			killRandomSoldier(false, true);
		}
		// DEFEND_FRONT vs REST
		else if (enemyAction.action == ActionType.DEFEND_FRONT &&
				playerAction == ActionType.REST)
		{
			// Player regains a soldier
			var p = getSpawnSpot(true);
			spawnNewSoldier(true, p[0], p[1]);
		}
		
		// DEFEND_UP vs ATTACK_FRONT -> resolved by resolveLanceKills
		// DEFEND_UP vs ATTACK_UP or DEFEND_FRONT or DEFEND_UP or IDLE -> nothing happens
		// DEFEND_UP vs REST
		if (enemyAction.action == ActionType.DEFEND_UP &&
			playerAction == ActionType.REST)
		{
			// Player regains a soldier
			var p = getSpawnSpot(true);
			spawnNewSoldier(true, p[0], p[1]);
		}
		
		// REST vs ATTACK_FRONT
		if (enemyAction.action == ActionType.REST &&
			playerAction == ActionType.ATTACK_FRONT)
		{
			// Enemy regains a soldier
			var p = getSpawnSpot(false);
			spawnNewSoldier(false, p[0], p[1]);
		}
		// REST vs ATTACK_UP
		else if (enemyAction.action == ActionType.REST &&
				playerAction == ActionType.ATTACK_UP)
		{
			// Enemy loses a soldier - enemy regains a soldier
			killRandomSoldier(false, true);
			var p = getSpawnSpot(false);
			spawnNewSoldier(false, p[0], p[1]);
		}
		// REST vs DEFEND_FRONT or DEFEND_UP or IDLE
		else if (enemyAction.action == ActionType.REST &&
				(playerAction == ActionType.DEFEND_FRONT ||
				playerAction == ActionType.DEFEND_UP ||
				playerAction == ActionType.IDLE))
		{
			// Enemy regains a soldier
			var p = getSpawnSpot(false);
			spawnNewSoldier(false, p[0], p[1]);
			SoundMan.playOnce(SoundMan.FAIL);
		}
		// REST vs REST
		else if (enemyAction.action == ActionType.REST &&
				playerAction == ActionType.REST)
		{
			// Both regain a soldier
			var p = getSpawnSpot(true);
			spawnNewSoldier(true, p[0], p[1]);
			p = getSpawnSpot(false);
			spawnNewSoldier(false, p[0], p[1]);
		}
	}
	
	function killRandomSoldier (forPlayer:Bool, fromAbove:Bool = true)
	{
		var s = null;
		if (forPlayer)	s = playerSoldiers[Std.random(playerSoldiers.length)];
		else			s = enemySoldiers[Std.random(enemySoldiers.length)];
		s.hurt();
		entities.push(new Blood(s.x, s.y));
		entities.push(new SoldierDie(forPlayer, s.x, s.y));
		// Shake
		if (fromAbove)	Game.INST.shake(8, 15, ShakeMode.VERTICAL);
		else			Game.INST.shake(8, 15, ShakeMode.HORIZONTAL);
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
	
	function getIndexesArrays (forPlayer:Bool) :Array<Array<Int>>
	{
		var max = (forPlayer) ? playerSoldiersMax : enemySoldiersMax;
		var txArray = new Array<Int>();
		var tyArray = new Array<Int>();
		for (i in 0...max) {
			txArray.push(i);
			tyArray.push(i);
		}
		return [txArray, tyArray];
	}
	
	function getSpawnSpot (forPlayer:Bool) :Array<Int>
	{
		var tx = enemyTower.w - 16;
		if (forPlayer)
			tx = Game.WIDTH - playerTower.w - 32;
		var ty = Game.HEIGHT / 2;
		return [Std.int(tx), Std.int(ty)];
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
			ty += (Game.HEIGHT - 100) * 0.2;
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
	
	function hurtTower (forPlayer:Bool)
	{
		var tower = (forPlayer) ? playerTower : enemyTower;
		var king = (forPlayer) ? playerKing : enemyKing;
		
		tower.hurt();
		if (tower.health == 0)
		{
			gameIsOver = true;
			state = (forPlayer) ? LevelState.DEFEAT : LevelState.VICTORY;
			
			if (forPlayer)	Game.INST.stageDifficulty = 0;
			else			Game.INST.stageDifficulty++;
			
			var bannerText = new BannerText(!forPlayer);
			entities.push(bannerText);
		}
	}

	function checkIfGameOver () :Bool
	{
		var over = false;
		if (enemySoldiers.length == 0)
		{
			gameIsOver = true;
			state = LevelState.VICTORY;
			Game.INST.stageDifficulty++;
			entities.push(new BannerText(true));
			over = true;
		}
		else if (playerSoldiers.length == 0)
		{
			gameIsOver = true;
			state = LevelState.DEFEAT;
			Game.INST.stageDifficulty = 0;
			entities.push(new BannerText(false));
			over = true;
		}
		return over;
	}

	function updateActionText (text:ActionText, action:ActionType)
	{
		var id = switch (action)
		{
			case ActionType.ATTACK_FRONT:	Sprites.TEXT_CHARGE;
			case ActionType.ATTACK_UP:		Sprites.TEXT_ARCHERS;
			case ActionType.DEFEND_FRONT:	Sprites.TEXT_DEFEND;
			case ActionType.DEFEND_UP:		Sprites.TEXT_SHIELD_UP;
			case ActionType.REST:			Sprites.TEXT_REST;
			default:						Sprites.BLANK;
		}
		text.setAnim(id);
	}

	public function click (a:ActionType)
	{
		if (state == LevelState.PROPAGATING && playerAction == ActionType.IDLE)
		{
			playerAction = a;
			switch (a)
			{
				case ActionType.ATTACK_FRONT:
					buttons.select(2);
				case ActionType.ATTACK_UP:
					buttons.select(3);
				case ActionType.DEFEND_FRONT:
					buttons.select(0);
				case ActionType.DEFEND_UP:
					buttons.select(1);
				case ActionType.REST:
					buttons.select(4);
				default:
			}
			playerActionText.setAnim(Sprites.TEXT_LOADING);
			Game.INST.removeChild(Game.INST.clickButtons);
		}
	}
	
}

enum LevelState {
	CREATING;
	CHOOSING_FLAGS;
	PROPAGATING;
	MOVING;
	RESOLVING;
	DONE;
	DEFEAT;
	VICTORY;
}
