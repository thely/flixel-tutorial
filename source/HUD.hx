package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxGroup
{
	
	private var _sprBack:FlxSprite;
	private var _txtHealth:FlxText;
	private var _txtMoney:FlxText;
	private var _sprHealth:FlxSprite;
	private var _sprMoney:FlxSprite;
	
	public function new() 
	{
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprHealth = new FlxSprite(2, 2, "assets/images/health.png");
		_sprMoney = new FlxSprite(FlxG.width - 18, 2, "assets/images/coin.png");
		
	}
	
}