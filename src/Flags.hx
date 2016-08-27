package;

/**
 * ...
 * @author 01101101
 */
class Flags
{
	
	static var allLeftFlags:Array<FlagData>;
	static var availableLeftFlags:Array<FlagData>;
	static var allRightFlags:Array<FlagData>;
	static var availableRightFlags:Array<FlagData>;
	
	static public function init ()
	{
		allLeftFlags = [];
		allRightFlags = [];
		
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_A_LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_B_LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_C_LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_D_LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_E_LEFT });
		
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_A_RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_B_RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_C_RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_D_RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_E_RIGHT });
		
		resetAvailable();
	}
	
	static function resetAvailable ()
	{
		// Refill available array with all possible combinations
		availableLeftFlags = allLeftFlags.concat([]);
		availableRightFlags = allRightFlags.concat([]);
	}
	
	static public function pickFlagPairs () :Array<FlagData>
	{
		// Refill available array if needed
		if (availableLeftFlags.length == 0 || availableRightFlags.length == 0)
			resetAvailable();
		
		return [
			availableLeftFlags.splice(Std.random(availableLeftFlags.length), 1)[0],
			availableRightFlags.splice(Std.random(availableRightFlags.length), 1)[0]
		];
	}
	
}

typedef FlagData = {
	side:FlagSide,
	variant:String
}

enum FlagSide {
	LEFT;
	RIGHT;
}
