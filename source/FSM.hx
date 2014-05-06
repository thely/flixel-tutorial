package ;

class FSM
{
	public var activeState(null, default):Void->Void;
	
	public function new(?InitState:Void->Void):Void
	{
		activeState = InitState;
	}
	
	public function update():Void
	{
		if (activeState != null)
			activeState();
	}
}