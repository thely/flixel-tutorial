package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class OptionsState extends FlxState
{
	private var _txtTitle:FlxText;
	
	private var _barVolume:FlxBar;
	private var _txtVolume:FlxText;
	private var _txtVolumeAmt:FlxText;
	private var _btnVolumeDown:FlxButton;
	private var _btnVolumeUp:FlxButton;
	
	private var _btnClearData:FlxButton;
	private var _btnBack:FlxButton;
	
	override public function create():Void 
	{
		
		_txtTitle = new FlxText(0, 20, 0, "Options", 22);
		_txtTitle.alignment = "center";
		_txtTitle.screenCenter(true, false);
		add(_txtTitle);
		
		_txtVolume = new FlxText(0, _txtTitle.y + _txtTitle.height + 10, 0, "Volume", 8);
		_txtVolume.alignment = "center";
		_txtVolume.screenCenter(true, false);
		add(_txtVolume);
		
		_btnVolumeDown = new FlxButton(10, _txtVolume.y + _txtVolume.height + 8, "-", clickVolumeDown);
		add(_btnVolumeDown);
		_btnVolumeUp = new FlxButton(0, _btnVolumeDown.y, "+", clickVolumeUp);
		_btnVolumeUp.x = FlxG.width - _btnVolumeUp.width - 8;
		add(_btnVolumeUp);
		
		_barVolume = new FlxBar(_btnVolumeDown.x + _btnVolumeDown.width + 2, _btnVolumeDown.y, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width - _btnVolumeDown.width - _btnVolumeUp.width - 20), Std.int(_btnVolumeUp.height));
		_barVolume.createFilledBar(FlxColor.CHARCOAL, FlxColor.WHITE, true, FlxColor.WHITE);
		add(_barVolume);
		
		
		super.create();
	}
	
	private function clickVolumeDown():Void
	{
		
	}
	
	private function clickVolumeUp():Void
	{
		
	}
}