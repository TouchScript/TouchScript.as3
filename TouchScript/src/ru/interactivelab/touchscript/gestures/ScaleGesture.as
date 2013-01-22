package ru.interactivelab.touchscript.gestures {
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster2;
	
	public class ScaleGesture extends Transform2DGestureBase {

		private var _cluster2:Cluster2 = new Cluster2();
		private var _scalingBuffer:Number = 0;
		private var _isScaling:Boolean = false;
		
		private var _scalingThreshold:Number = 0.5;
		private var _minClusterDistance:Number = 0.5;
		private var _localDeltaScale:Number = 1;
		
		public function get scalingThreshold():Number {
			return _scalingThreshold;
		}
		
		public function set scalingThreshold(value:Number):void {
			_scalingThreshold = value;
		}
		
		public function get minClusterDistance():Number {
			return _minClusterDistance;
		}
		
		public function set minClusterDistance(value:Number):void {
			_minClusterDistance = value;
		}
		
		public function get localDeltaScale():Number {
			return _localDeltaScale;
		}
		
		public function ScaleGesture(target:InteractiveObject, ...params) {
			super(target, params);
		}
		
		protected override function touchesBegan(touches:Array):void {
			super.touchesBegan(touches);
			for each (var touch:TouchPoint in touches) {
				_cluster2.addPoint(touch);
			}
		}
		
		protected override function touchesMoved(touches:Array):void {
			super.touchesMoved(touches);
			
			_cluster2.invalidate();
			_cluster2.minPointsDistance = _minClusterDistance * TouchManager.dotsPerCentimeter;
			
			if (!_cluster2.hasClusters) return;
			
			var deltaScale:Number = 1;
			var oldPos1:Point = _cluster2.getPreviousCenterPosition(Cluster2.CLUSTER1);
			var oldPos2:Point = _cluster2.getPreviousCenterPosition(Cluster2.CLUSTER2);
			var newPos1:Point = _cluster2.getCenterPosition(Cluster2.CLUSTER1);
			var newPos2:Point = _cluster2.getCenterPosition(Cluster2.CLUSTER2);
			var oldCenterPos:Point = new Point((oldPos1.x + oldPos2.x) * .5, (oldPos1.y + oldPos2.y) * .5);
			var newCenterPos:Point = new Point((newPos1.x + newPos2.x) * .5, (newPos1.y + newPos2.y) * .5);
			var oldDist:Number = Point.distance(oldPos1, oldPos2);
			var newDist:Number = Point.distance(newPos1, newPos2);
			
			if (_isScaling) {
				deltaScale = newDist / oldDist;
			} else {
				_scalingBuffer += newDist - oldDist;
				var dpiScalingThreshold:Number = _scalingThreshold * TouchManager.dotsPerCentimeter;
				if (_scalingBuffer * _scalingBuffer > dpiScalingThreshold * dpiScalingThreshold) {
					_isScaling = true;
					deltaScale = newDist / (newDist - _scalingBuffer);
				}
			}
			
			if (Math.abs(deltaScale - 1) > 0.00001) {
				switch (state) {
					case GestureState.POSSIBLE:
					case GestureState.BEGAN:
					case GestureState.CHANGED:
						_globalTransformCenter = newCenterPos;
						_localTransformCenter = globalToLocalPosition(_globalTransformCenter);
						_previousGlobalTransformCenter = oldCenterPos;
						_previousLocalTransformCenter = globalToLocalPosition(_previousGlobalTransformCenter);
						
						_localDeltaScale = deltaScale;
						
						if (state == GestureState.POSSIBLE) {
							setState(GestureState.BEGAN);
						} else {
							setState(GestureState.CHANGED);
						}
						break;
				}
			}
		}
		
		protected override function touchesEnded(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				_cluster2.removePoint(touch);
			}
			if (!_cluster2.hasClusters) {
				resetScaling();
			}
			super.touchesEnded(touches);
		}
		
		protected override function reset():void {
			super.reset();
			_cluster2.removeAllPoints();
			resetScaling();
		}
		
		protected override function resetGestureProperties():void {
			super.resetGestureProperties();
			_localDeltaScale = 1;
		}
		
		private function resetScaling():void {
			_scalingBuffer = 0;
			_isScaling = false;
		}
		
	}
}