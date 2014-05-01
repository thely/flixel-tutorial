package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{

	public var Speed:Float = 200;
	public var Friction:Float = .6;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.BLUE);
	}
	
}
