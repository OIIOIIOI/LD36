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
		
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_A + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_B + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_C + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_D + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_E + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_F + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_G + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_H + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_I + Sprites.LEFT });
		allLeftFlags.push({ side:LEFT, variant:Sprites.FLAG_J + Sprites.LEFT });
		
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_A + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_B + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_C + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_D + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_E + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_F + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_G + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_H + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_I + Sprites.RIGHT });
		allRightFlags.push({ side:RIGHT, variant:Sprites.FLAG_J + Sprites.RIGHT });
		
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
