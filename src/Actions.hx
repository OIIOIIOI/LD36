package;

import Flags;

/**
 * ...
 * @author 01101101
 */
class Actions
{
	
	static var actions:Array<Action>;
	
	static public function pairActionAndFlags ()
	{
		actions = [];
		actions.push({ action:ActionType.ATTACK_FRONT,	flags:Flags.pickFlagPairs() });
		actions.push({ action:ActionType.ATTACK_UP,		flags:Flags.pickFlagPairs() });
		actions.push({ action:ActionType.DEFEND_FRONT,	flags:Flags.pickFlagPairs() });
		actions.push({ action:ActionType.DEFEND_UP,		flags:Flags.pickFlagPairs() });
		actions.push({ action:ActionType.REST,			flags:Flags.pickFlagPairs() });
	}
	
	static public function pickRandomAction () :Action
	{
		var length = actions.length;
		if (Std.is(Game.INST.currentScreen, Level))
		{
			var level:Level = cast Game.INST.currentScreen;
			if (level.enemySoldiers.length >= level.enemySoldiersMax)
				length--;
		}
		return actions[Std.random(length)];
		// return actions[1];
	}
	
}

typedef Action = {
	action:ActionType,
	flags:Array<FlagData>
}

enum ActionType {
	ATTACK_FRONT;
	ATTACK_UP;
	DEFEND_FRONT;
	DEFEND_UP;
	REST;
	IDLE;
}
