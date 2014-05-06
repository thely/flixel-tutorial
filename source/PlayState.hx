package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
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
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _grpCoins:FlxTypedGroup<Coin>;
	private var _grpEnemies:FlxTypedGroup<Enemy>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_map = new FlxOgmoLoader("assets/data/room-001.oel");
		_mWalls = _map.loadTilemap("assets/images/tiles.png", 16, 16, "walls");
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		_grpCoins = new FlxTypedGroup<Coin>();
		add(_grpCoins);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);
		
		_player = new Player();
		
		_map.loadEntities(placeEntities, "entities");
		
		add(_player);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, null, 1);
		
		super.create();	
		
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		if (entityName == "player")
		{
			_player.x = Std.parseInt(entityData.get("x"));
			_player.y = Std.parseInt(entityData.get("y"));
		}
		else if (entityName == "coin")
		{
			_grpCoins.add(new Coin(Std.parseInt(entityData.get("x")) + 4, Std.parseInt(entityData.get("y")) + 4));
			
		}
		else if (entityName == "enemy")
		{
			_grpEnemies.add(new Enemy(Std.parseInt(entityData.get("x"))+4, Std.parseInt(entityData.get("y")), Std.parseInt(entityData.get("etype"))));
		}
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	private function userInput():Void
	{
		
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
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
					
				_player.facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				
				_player.facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				_player.facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				_player.facing = FlxObject.RIGHT;
			}
			FlxAngle.rotatePoint(_player.speed, 0, 0, 0, mA, _player.velocity);
		}
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		userInput();

		super.update();
		
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpCoins, playerTouchCoin);
		FlxG.collide(_grpEnemies, _mWalls);
		checkEnemyVision();
		
		
	}	
	
	private function checkEnemyVision():Void
	{
		for (e in _grpEnemies.members)
		{
			if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
			{
				e.seesPlayer = true;
				e.playerPos.copyFrom(_player.getMidpoint());
			}
			else
				e.seesPlayer = false;
		}
	}
	
	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			C.kill();
		}
	}
}