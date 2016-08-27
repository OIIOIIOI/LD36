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
		actions.push({ action:ATTACK_FRONT, flags:Flags.pickFlagPairs() });
		actions.push({ action:ATTACK_UP, flags:Flags.pickFlagPairs() });
		actions.push({ action:DEFEND_FRONT, flags:Flags.pickFlagPairs() });
		actions.push({ action:DEFEND_UP, flags:Flags.pickFlagPairs() });
		actions.push({ action:SLEEP, flags:Flags.pickFlagPairs() });
		//trace(actions);
	}
	
	static public function pickRandomAction () :Action
	{
		return actions[Std.random(actions.length)];
	}
	
}

typedef Action = {
	action:ActionType,
	flags:Array<Flag>
}

enum ActionType {
	ATTACK_FRONT;
	ATTACK_UP;
	DEFEND_FRONT;
	DEFEND_UP;
	SLEEP;
	IDLE;
}
