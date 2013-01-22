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
package ru.interactivelab.touchscript.gestures {
	import flash.display.InteractiveObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster;
	import ru.interactivelab.touchscript.clusters.Cluster1;
	import ru.interactivelab.touchscript.math.Vector2;
	import ru.interactivelab.touchscript.touch_internal;
	
	use namespace touch_internal;
	
	public class LongPressGesture extends Gesture {
		
		private var _cluster:Cluster1 = new Cluster1();
		private var _totalMovement:Vector2 = new Vector2();
		private var _timer:Timer = new Timer(0, 1);
		
		private var _maxTouches:int = int.MAX_VALUE;
		private var _timeToPress:Number = 1;
		private var _distanceLimit:Number = Number.MAX_VALUE;
		private var _screenPressCoordinates:Vector2 = Vector2.ZERO;
		
		public function get maxTouches():int {
			return _maxTouches;
		}
		
		public function set maxTouches(value:int):void {
			_maxTouches = value;
		}
		
		public function get timeToPress():Number {
			return _timeToPress;
		}
		
		public function set timeToPress(value:Number):void {
			if (value < 0) value = 0;
			_timeToPress = value;
		}
		
		public function get distanceLimit():Number {
			return _distanceLimit;
		}
		
		public function set distanceLimit(value:Number):void {
			if (value < 0) value = 0;
			_distanceLimit = value;
		}
		
		public function get screenPressCoordinates():Vector2 {
			return _screenPressCoordinates;
		}
		
		public function LongPressGesture(target:InteractiveObject, ...params) {
			super(target, params);
			
			_timer.addEventListener(TimerEvent.TIMER, handler_timer);
		}
		
		protected override function touchesBegan(touches:Array):void {
			if (_activeTouches.length > _maxTouches) {
				setState(GestureState.FAILED);
				return;
			}
			for each (var touch:TouchPoint in touches) {
				if (_cluster.addPoint(touch) == Cluster.RESULT_FIRST_POINT_ADDED) {
					_timer.delay = _timeToPress * 1000;
					_timer.start();
				}
			}
		}
		
		protected override function touchesMoved(touches:Array):void {
			_cluster.invalidate();
			_totalMovement.$add(_cluster.getCenterPosition()).$subtract(_cluster.getPreviousCenterPosition());
			var dpiDistanceLimit:Number = _distanceLimit * TouchManager.dotsPerCentimeter;
			if (_totalMovement.sqrMagnitude >= dpiDistanceLimit * dpiDistanceLimit) setState(GestureState.FAILED);
		}
		
		protected override function touchesEnded(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				var result:String = _cluster.removePoint(touch);
				if (result == Cluster.RESULT_LAST_POINT_REMOVED) setState(GestureState.FAILED);
			}
		}
		
		protected override function onFailed():void {
			reset();
		}
		
		protected override function reset():void {
			_cluster.removeAllPoints();
			_timer.stop();
			_totalMovement.$set(0, 0);
		}
		
		private function handler_timer(event:TimerEvent):void {
			_screenPressCoordinates = _cluster.getCenterPosition();
			setState(GestureState.RECOGNIZED);
		}
		
	}
}