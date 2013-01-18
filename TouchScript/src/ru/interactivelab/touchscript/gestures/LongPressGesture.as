package ru.interactivelab.touchscript.gestures {
	import flash.display.InteractiveObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster;
	import ru.interactivelab.touchscript.clusters.Cluster1;
	
	public class LongPressGesture extends Gesture {
		
		private var _cluster:Cluster1 = new Cluster1();
		private var _totalMovement:Point = new Point();
		private var _timer:Timer = new Timer(0, 1);
		
		private var _maxTouches:int = int.MAX_VALUE;
		private var _timeToPress:Number = 1;
		private var _distanceLimit:Number = Number.MAX_VALUE;
		private var _screenPressCoordinates:Point;
		
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
		
		public function get screenPressCoordinates():Point {
			return _screenPressCoordinates.clone();
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
			_totalMovement.add(_cluster.getCenterPosition().subtract(_cluster.getPreviousCenterPosition()));
			if (_totalMovement.length/TouchManager.dotsPerCentimeter >= _distanceLimit) setState(GestureState.FAILED);
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
		}
		
		private function handler_timer(event:TimerEvent):void {
			_screenPressCoordinates = _cluster.getCenterPosition();
			setState(GestureState.RECOGNIZED);
		}
		
	}
}