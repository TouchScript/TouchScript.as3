/*
* Copyright (C) 2013 Interactive Lab
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
* files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
* modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
* Software is furnished to do so, subject to the following conditions:
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
* Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package ru.interactivelab.touchscript.utils {
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