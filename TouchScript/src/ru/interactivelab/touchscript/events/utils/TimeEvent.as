package ru.interactivelab.touchscript.events.utils {
	import flash.events.Event;
	
	public class TimeEvent extends Event {
		
		public static const TICK:String					= "tick";
		
		public var time:Number;
		public var deltaTime:Number;
		
		public function TimeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, time:Number = 0, deltaTime:Number = 0) {
			super(type, bubbles, cancelable);
			this.time = time;
			this.deltaTime = deltaTime;
		}
	}
}