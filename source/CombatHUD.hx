package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
using flixel.util.FlxSpriteUtil;

class CombatHUD extends FlxTypedGroup<FlxSprite>
{

	public var e:Enemy;
	public var playerHealth(default, null):Int;
	public var outcome(default, null):Outcome;
	private var _enemyHealth:Int;
	private var _enemyMaxHealth:Int;
	
	private var _sprBack:FlxSprite;
	private var _sprPlayer:Player;
	private var _sprEnemy:Enemy;
	
	private var _choices:Array<FlxText>;
	private var _pointer:FlxSprite;
	private var _damages:Array<FlxText>;
	private var _selected:Int = 0;
	private var _pHealth:FlxText;
	private var _results:FlxText;
	
	private var _eBar:FlxBar;
	
	private var _alpha:Float = 0;
	private var _wait:Bool = true;
	
	public function new() 
	{
		super();		
		
		_sprBack = new FlxSprite().makeGraphic(120, 120, FlxColor.WHITE);
		_sprBack.drawRect(1, 1, 118, 44, FlxColor.BLACK);
		_sprBack.drawRect(1, 46, 118, 73, FlxColor.BLACK);
		_sprBack.screenCenter(true, true);
		
		_sprPlayer = new Player(_sprBack.x + 36 , _sprBack.y + 16);
		_sprPlayer.active = false;
		_sprPlayer.facing = FlxObject.RIGHT;
		
		_sprEnemy = new Enemy(_sprBack.x + 76, _sprBack.y + 16, 0);
		_sprEnemy.active = false;
		_sprEnemy.facing = FlxObject.LEFT;

		add(_sprBack);
		add(_sprPlayer);
		add(_sprEnemy);
		
		_pHealth = new FlxText(0, _sprPlayer.y + _sprPlayer.height  + 2, 0, "3 / 3", 8);
		_pHealth.alignment = "center";
		_pHealth.x = _sprPlayer.x + 4 - (_pHealth.width / 2);
		add(_pHealth);
		
		_eBar = new FlxBar(_sprEnemy.x - 6, _pHealth.y, FlxBar.FILL_LEFT_TO_RIGHT, 20, 10);
		_eBar.createFilledBar(FlxColor.CRIMSON, FlxColor.YELLOW, true, FlxColor.YELLOW);
		add(_eBar);
		
		_choices = new Array<FlxText>();
		
		_choices.push(new FlxText(_sprBack.x + 30, _sprBack.y + 48, 85, "FIGHT", 22));
		_choices.push(new FlxText(_sprBack.x + 30, _choices[0].y + _choices[0].height +  8, 85, "FLEE", 22));
		
		add(_choices[0]);
		add(_choices[1]);
		
		_pointer = new FlxSprite(_sprBack.x + 10, _choices[0].y + (_choices[0].height / 2) - 8, AssetPaths.pointer__png);
		_pointer.visible = false;
		add(_pointer);
		
		_damages = new Array<FlxText>();
		_damages.push(new FlxText(0,0,40));
		_damages.push(new FlxText(0, 0, 40));
		for (d in _damages)
		{
			d.color = FlxColor.WHITE;
			d.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED);
			d.alignment = "center";
			d.visible = false;
			add(d);
		}
		
		
		
		_results = new FlxText(_sprBack.x + 2, _sprBack.y + 9, 116, "", 18);
		_results.alignment = "center";
		_results.color = FlxColor.YELLOW;
		_results.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY);
		_results.visible = false;
		add(_results);
		
		forEach(function(spr:FlxSprite) {
			spr.scrollFactor.set();
			spr.alpha = 0;
		});
		
		active = false;
		visible = false;
	}
	
	public function initCombat(PHealth:Int, E:Enemy):Void
	{
		playerHealth = PHealth;
		updatePHealth();
		e = E;
		_enemyMaxHealth = _enemyHealth = (e.etype + 1) * 2;
		_eBar.currentValue = 100;
		_sprEnemy.changeEnemy(e.etype);
		visible = true;
		_pointer.visible = false;
		_wait = true;
		_results.text = "";
		_results.visible = false;
		outcome = NONE;
		_selected = 0;
		FlxTween.num(0, 1, .66, { ease:FlxEase.circOut, complete:finishFadeIn }, updateAlpha);
	}
	
	private function updateAlpha(Value:Float):Void
	{
		_alpha = Value;
		forEach(function(spr:FlxSprite) {
			spr.alpha = _alpha;
		});
	}
	
	private function finishFadeIn(_):Void
	{
		active = true;
		_wait = false;
		_pointer.visible = true;
	}
	
	
	private function finishFadeOut(_):Void
	{
		active = false;
		visible = false;
	}
	
	private function updatePHealth():Void
	{
		_pHealth.text = Std.string(playerHealth) + " / 3";
		_pHealth.x = _sprPlayer.x + 4 - (_pHealth.width / 2);
	}
	
	override public function update():Void 
	{
		if (!_wait)
		{
			var _up:Bool = false;
			var _down:Bool = false;
			var _fire:Bool = false;
			
			if (FlxG.keys.anyJustReleased(["SPACE", "X"]))
			{
				_fire = true;
			}
			else if (FlxG.keys.anyJustReleased(["W", "UP"]))
			{
				_up = true;
			}
			else if (FlxG.keys.anyJustReleased(["S", "DOWN"]))
			{
				_down = true;
			}
			
			if (_fire)
			{
				makeChoice();
			}
			else if (_up)
			{
				if (_selected == 0)
					_selected = 1;
				else
					_selected--;
				movePointer();
			}
			else if (_down)
			{
				if (_selected == 1)
					_selected = 0;
				else
					_selected++;
				movePointer();
			}
		}
		super.update();
	}
	
	private function movePointer():Void
	{
		_pointer.y = _choices[_selected].y + (_choices[_selected].height / 2) - 8;
	}
	
	private function makeChoice():Void
	{
		_pointer.visible = false;
		switch (_selected)
		{
			case 0:
				
				if (FlxRandom.chanceRoll(85))
				{
					_damages[1].text = "1";
					_enemyHealth--;
					_eBar.currentValue = (_enemyHealth / _enemyMaxHealth) * 100;
				}
				else
				{
					_damages[1].text = "MISS!";
				}
				_damages[1].x = _sprEnemy.x + 2 - (_damages[1].width / 2);
				_damages[1].y = _sprEnemy.y + 4 - (_damages[1].height / 2);
				_damages[1].alpha = 0;
				_damages[1].visible = true;
				
				enemyAttack();
				
				FlxTween.num(_damages[0].y, _damages[0].y - 12, 1, { ease:FlxEase.circOut}, updateDmgY);
				FlxTween.num(0, 1, .2, { ease:FlxEase.circInOut, complete:doneDmgIn }, updateDmgAlpha);
			case 1:
				if (FlxRandom.chanceRoll(50))
				{
					outcome = ESCAPE;
					_results.text = "ESCAPED!";
					_results.visible = true;
					_results.alpha = 0;
					FlxTween.tween(_results, { alpha:1 }, .66, { ease:FlxEase.circInOut, complete:doneResultsIn } );
					
				}
				else
				{
					enemyAttack();
					FlxTween.num(_damages[0].y, _damages[0].y - 12, 1, { ease:FlxEase.circOut}, updateDmgY);
					FlxTween.num(0, 1, .2, { ease:FlxEase.circInOut, complete:doneDmgIn }, updateDmgAlpha);
				}
		}
		_wait = true;
	}
	
	private function enemyAttack():Void
	{
		FlxG.camera.flash(FlxColor.WHITE, .2);
		if (FlxRandom.chanceRoll(30))
		{
			_damages[0].text = "1";
			playerHealth--;
			updatePHealth();
		}
		else
		{
			_damages[0].text = "MISS!";
		}
		
		_damages[0].x = _sprPlayer.x + 2 - (_damages[0].width / 2);
		_damages[0].y = _sprPlayer.y + 4 - (_damages[0].height / 2);
		_damages[0].alpha = 0;
		_damages[0].visible = true;
	}
	
	private function updateDmgY(Value:Float):Void
	{
		_damages[0].y = _damages[1].y = Value;
	}
	
	private function updateDmgAlpha(Value:Float):Void
	{
		_damages[0].alpha = _damages[1].alpha = Value;
	}
	
	private function doneDmgIn(_):Void
	{
		FlxTween.num(1, 0, .66, { ease:FlxEase.circInOut, startDelay:1, complete:doneDmgOut}, updateDmgAlpha);
	}
	
	private function doneResultsIn(_):Void
	{
		if (outcome != DEFEAT)
		{
			FlxTween.num(1, 0, .66, { ease:FlxEase.circOut, complete:finishFadeOut, startDelay:1 }, updateAlpha);
		}
	}
	
	private function doneDmgOut(_):Void
	{
		_damages[0].visible = false;
		_damages[1].visible = false;
		_damages[0].text = "";
		_damages[1].text = "";
		
		if (playerHealth <= 0)
		{
			outcome = DEFEAT;
			_results.text = "DEFEAT!";
			_results.visible = true;
			_results.alpha = 0;
			FlxTween.tween(_results, { alpha:1 }, .66, { ease:FlxEase.circInOut, complete:doneResultsIn } );
		}
		else if (_enemyHealth <= 0)
		{
			outcome = VICTORY;
			_results.text = "VICTORY!";
			_results.visible = true;
			_results.alpha = 0;
			FlxTween.tween(_results, { alpha:1 }, .66, { ease:FlxEase.circInOut, complete:doneResultsIn } );
		}
		else
		{
			_wait = false;
			_pointer.visible = true;
		}
	}
}

enum Outcome {
	NONE;
	ESCAPE;
	VICTORY;
	DEFEAT;
}