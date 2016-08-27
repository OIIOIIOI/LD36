package;

/**
 * ...
 * @author 01101101
 */
class Flags
{
	
	static var positions:Array<FlagPosition>;
	static var colours:Array<FlagColour>;
	static var shapes:Array<FlagShape>;
	
	static var allLeftFlags:Array<Flag>;
	static var availableLeftFlags:Array<Flag>;
	static var allRightFlags:Array<Flag>;
	static var availableRightFlags:Array<Flag>;
	
	static public function init ()
	{
		positions = [DOWN, UP];
		colours = [COLOUR_A, COLOUR_B];
		shapes = [SHAPE_A, SHAPE_B];
		
		allLeftFlags = [];
		allRightFlags = [];
		
		for (p in positions)
		{
			for (c in colours)
			{
				for (s in shapes)
				{
					allLeftFlags.push({ side:LEFT, position:p, colour:c, shape:s });
					allRightFlags.push({ side:RIGHT, position:p, colour:c, shape:s });
				}
			}
		}
		resetAvailable();
	}
	
	static function resetAvailable ()
	{
		// Refill available array with all possible combinations
		availableLeftFlags = allLeftFlags.concat([]);
		availableRightFlags = allRightFlags.concat([]);
	}
	
	static public function pickFlagPairs ()
	{
		// Refill available array if needed
		if (availableLeftFlags.length == 0 || availableRightFlags.length == 0)
			resetAvailable();
		
		return [
			availableLeftFlags.splice(Std.random(availableLeftFlags.length), 1),
			availableRightFlags.splice(Std.random(availableRightFlags.length), 1)
		];
	}
	
}

typedef Flag = {
	side:FlagSide,
	position:FlagPosition,
	colour:FlagColour,
	shape:FlagShape
}

enum FlagSide {
	LEFT;
	RIGHT;
}

enum FlagPosition {
	DOWN;
	UP;
}

enum FlagColour {
	COLOUR_A;
	COLOUR_B;
}

enum FlagShape {
	SHAPE_A;
	SHAPE_B;
}
