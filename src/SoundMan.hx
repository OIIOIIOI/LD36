package;

import openfl.Assets;
import openfl.events.Event;
import openfl.media.SoundTransform;
import openfl.media.SoundChannel;

/**
 * ...
 * @author 01101101
 */
class SoundMan
{
	
	static public var VOL_MOD:Float = 0.75;

	static public var FAIL:String = "snd/fail";
	
	static var channels:Map<String, SoundChannel>;

	static var ext:String = ".wav";

	static public function init ()
	{
		channels = new Map();
	}

	static public function playOnce (s:String, vol:Float = 1)
	{
		vol *= VOL_MOD;
		// Choose variant if needed
		// if (s == ENEMY_DEATH)	s = s + "" + Std.random(3);
		// if (s == PICKUP)	s = s + "" + Std.random(3);
		// Get sound
		var snd = Assets.getSound(s + ext);
		if (snd == null)
			return;
		// Play sound
		var st = new SoundTransform(vol);
		snd.play(0, 0, st);
	}
	
	static public function playLoop (s:String, vol:Float = 1)
	{
		if (channels.exists(s)) {
			channels.get(s).stop();
			channels.get(s).removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			channels.remove(s);
		}

		vol *= VOL_MOD;
		// Get sound
		var snd = Assets.getSound(s + ext);
		if (snd == null)
			return;
		// Play sound
		var st = new SoundTransform(vol);
		var ch = snd.play(0, 1, st);
		ch.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		channels.set(s, ch);
	}

	static public function stopLoop (s:String)
	{
		if (channels.exists(s)) {
			channels.get(s).stop();
			channels.get(s).removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			channels.remove(s);
		}
	}

	static function soundCompleteHandler (e:Event)
	{
		for (k in channels.keys())
		{
			if (channels.get(k) == e.currentTarget)
			{
				playLoop(k);
			}
		}
	}
	
}