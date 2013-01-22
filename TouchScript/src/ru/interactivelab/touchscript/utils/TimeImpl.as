package ru.interactivelab.touchscript.utils
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import ru.interactivelab.touchscript.events.utils.TimeEvent;
	
	[Event(name="tick", type="ru.interactivelab.touchscript.events.utils.TimeEvent")]
	public class TimeImpl extends Shape {
		
		private var _previousTime:Number;
		private var _deltaTime:Number = 0;
		private var _time:Number = 0;
		
		public function get time():Number {
			return _time;
		}
		
		public function get deltaTime():Number {
			return _deltaTime;
		}
		
		public function TimeImpl() {
			super();
			_previousTime = getTimer();
			
			addEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		private function handler_enterFrame(event:Event):void {
			_time = getTimer() * 0.001;
			_deltaTime = _time - _previousTime;
			_previousTime = _time;
			
			if (hasEventListener(TimeEvent.TICK)) {
				dispatchEvent(new TimeEvent(TimeEvent.TICK, false, false, _time, _deltaTime));
			}
		}
	}
}