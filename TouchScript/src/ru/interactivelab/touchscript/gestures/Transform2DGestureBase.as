package ru.interactivelab.touchscript.gestures
{
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster;
	import ru.interactivelab.touchscript.clusters.Cluster1;
	
	public class Transform2DGestureBase extends Gesture {
		
		protected var _cluster1:Cluster1 = new Cluster1();
		protected var _localTransformCenter:Point = new Point();
		protected var _previousLocalTransformCenter:Point = new Point();
		protected var _globalTransformCenter:Point = new Point();
		protected var _previousGlobalTransformCenter:Point = new Point();
		
		public function get localTransformCenter():Point {
			return _localTransformCenter;
		}
		
		public function get previousLocalTransformCenter():Point {
			return _previousLocalTransformCenter;
		}
		
		public function get globalTransformCenter():Point {
			return _localTransformCenter;
		}
		public function get previousGlobalTransformCenter():Point {
			return _previousLocalTransformCenter;
		}
		
		public function Transform2DGestureBase(target:InteractiveObject, ...params) {
			super(target, params);
			resetGestureProperties();
		}
		
		protected override function touchesBegan(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				_cluster1.addPoint(touch);
			}
		}
		
		protected override function touchesMoved(touches:Array):void {
			_cluster1.invalidate();
		}
		
		protected override function touchesEnded(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				var result:String = _cluster1.removePoint(touch);
				if (result == Cluster.RESULT_LAST_POINT_REMOVED) {
					switch (state) {
						case GestureState.BEGAN:
						case GestureState.CHANGED:
							setState(GestureState.ENDED);
							break;
					}
				}
			}
		}
		
		protected override function touchesCancelled(touches:Array):void {
			touchesEnded(touches);
		}
		
		protected override function reset():void {
			_cluster1.removeAllPoints();
			resetGestureProperties();
		}
		
		protected function globalToLocalPosition(global:Point):Point {
			if (displayTarget.parent) {
				return displayTarget.parent.globalToLocal(global);
			} else {
				return global.clone();
			}
		}
		
		protected function resetGestureProperties():void {
			_globalTransformCenter.x = 0;
			_globalTransformCenter.y = 0;
			_localTransformCenter.x = 0;
			_localTransformCenter.y = 0;
		}
		
	}
}