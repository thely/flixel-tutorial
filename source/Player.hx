package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{

	public var speed:Float = 200;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/player.png", true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("lr", [1, 0], 6, false);
		animation.add("u", [3, 2], 6, false);
		animation.add("d", [5, 4], 6, false);
		drag.x = drag.y = 1600;
		width = 8;
		height = 14;
		offset.x = 4;
		offset.y = 2;
		
	}
	
	override public function draw():Void 
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			switch(facing)
			{
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");
					
				case FlxObject.UP:
					animation.play("u");
					
				case FlxObject.DOWN:
					animation.play("d");
			}
		}
			
		super.draw();
	}
	
}
