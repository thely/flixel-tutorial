package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _player:Player;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		_player = new Player(20, 20);
		add(_player);
		
		super.create();
		
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	private function playerMovement():Void
	{
		
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		#if !FLX_NO_KEYBOARD
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		#end
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		if ( _up || _down || _left || _right)
		{

			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
			}
			else if (_left)
				mA = 180;
			else if (_right)
				mA = 0;
				
			var v:FlxPoint = FlxAngle.rotatePoint(_player.Speed, 0, 0, 0, mA);
			_player.velocity.x = v.x;
			_player.velocity.y = v.y;
			v = FlxDestroyUtil.put(v);
		}
		
		if (!(_up || _down))
			if (Math.abs(_player.velocity.y) >= _player.Friction)
				_player.velocity.y *= _player.Friction;
			else
				_player.velocity.y = 0;
		if (!(_left || _right))
			if (Math.abs(_player.velocity.x) >= _player.Friction)
				_player.velocity.x *= _player.Friction;
			else
				_player.velocity.x = 0;
		
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		playerMovement();
		
		super.update();
	}	
}