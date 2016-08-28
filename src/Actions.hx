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
		return actions[Std.random(actions.length)];
		//return actions[4];
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
