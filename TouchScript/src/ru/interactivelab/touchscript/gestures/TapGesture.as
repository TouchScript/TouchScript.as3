package ru.interactivelab.touchscript.gestures
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster;
	import ru.interactivelab.touchscript.clusters.Cluster1;
	import ru.interactivelab.touchscript.utils.Time;
	
	public class TapGesture extends Gesture {
		
		private var _timeLimit:Number = Number.POSITIVE_INFINITY;
		private var _distanceLimit:Number = Number.POSITIVE_INFINITY;
		private var _cluster:Cluster1 = new Cluster1();
		private var _totalMovement:Number = 0;
		private var _startTime:Number;
		
		public function get timeLimit():Number {
			return _timeLimit;
		}
		
		public function set timeLimit(value:Number):void {
			_timeLimit = value;
		}
		
		public function get distanceLimit():Number {
			return _distanceLimit;
		}
		
		public function set distanceLimit(value:Number):void {
			_distanceLimit = value;
		}
		
		public function TapGesture(target:InteractiveObject, ...params) {
			super(target, params);
		}
		
		protected override function touchesBegan(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				if (_cluster.addPoint(touch) == Cluster.RESULT_FIRST_POINT_ADDED) {
					_startTime = Time.time;
				}
			}
		}
		
		protected override function touchesMoved(touches:Array):void {
			_cluster.invalidate();
			_totalMovement += _cluster.getCenterPosition().subtract(_cluster.getPreviousCenterPosition()).length;
		}
		
		protected override function touchesEnded(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				if (_cluster.removePoint(touch) == Cluster.RESULT_LAST_POINT_REMOVED) {
					if (_totalMovement / TouchManager.dotsPerCentimeter >= _distanceLimit || Time.time - _startTime > _timeLimit) {
						setState(GestureState.FAILED);
						return;
					}
					var newTarget:InteractiveObject = TouchManager.getHitTarget(touch);
					if (newTarget == null || !(this.target == newTarget || 
					   (super.displayTarget is DisplayObjectContainer && (super.displayTarget as DisplayObjectContainer).contains(newTarget))))
					{
						setState(GestureState.FAILED);
					} else {
						setState(GestureState.RECOGNIZED);
					}
				}
			}
		}
		
		protected override function touchesCancelled(touches:Array):void {
			setState(GestureState.FAILED);
		}
		
		protected override function reset():void {
			_cluster.removeAllPoints();
			_totalMovement = 0;
		}
		
	}
}