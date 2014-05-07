package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
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
		
		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		add(_player);
		
		super.create();	
		
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		if (entityName == "player")
		{
			_player.x = Std.parseInt(entityData.get("x"));
			_player.y = Std.parseInt(entityData.get("y"));
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

	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		FlxG.collide(_player, _mWalls);
	}	
}
