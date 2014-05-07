package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxGroup
{
	
	private var _sprBack:FlxSprite;
	private var _txtHealth:FlxText;
	private var _txtMoney:FlxText;
	private var _sprHealth:FlxSprite;
	private var _sprMoney:FlxSprite;
	
	public function new() 
	{
		super(5);
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
		_txtHealth = new FlxText(16, 2, 0, "3 / 3", 8);
		_txtHealth.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		_txtMoney = new FlxText(0, 2, 0, "0", 8);
		_txtMoney.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		_sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 4, "assets/images/health.png");
		_sprMoney = new FlxSprite(FlxG.width - 12, _txtMoney.y + (_txtMoney.height/2)  - 4, "assets/images/coin.png");
		_txtMoney.alignment = "right";
		_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
		add(_sprBack);
		add(_sprHealth);
		add(_sprMoney);
		add(_txtHealth);
		add(_txtMoney);
		forEach(setScrollFactor);
	}
	
	
	private function setScrollFactor(O:FlxBasic):Void
	{
		var spr:FlxSprite = cast(O, FlxSprite);
		spr.scrollFactor.x = spr.scrollFactor.y = 0;
	}
	
	public function updateHUD(Health:Int = 0, Money:Int = 0):Void
	{
		_txtHealth.text = Std.string(Health) + " / 3";
		_txtMoney.text = Std.string(Money);
		_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
	}
	
	
	
}