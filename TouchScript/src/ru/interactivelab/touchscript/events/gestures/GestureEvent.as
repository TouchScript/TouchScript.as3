package ru.interactivelab.touchscript.events.gestures
{
	import flash.events.Event;
	
	public class GestureEvent extends Event {
		
		public static const STATE_CHANGED:String			= "stateChanged";
		
		public var previousState:String;
		public var state:String;
		
		public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, state:String = "", previousState:String = "") {
			super(type, bubbles, cancelable);
			this.previousState = previousState;
			this.state = state;
		}
	}
}