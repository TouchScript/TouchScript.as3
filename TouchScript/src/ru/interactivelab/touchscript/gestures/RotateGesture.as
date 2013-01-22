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
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster2;
	import ru.interactivelab.touchscript.math.Consts;
	import ru.interactivelab.touchscript.math.Vector2;
	import ru.interactivelab.touchscript.touch_internal;
	
	use namespace touch_internal;
	
	public class RotateGesture extends Transform2DGestureBase {
		
		private var _cluster2:Cluster2 = new Cluster2();
		private var _rotationBuffer:Number = 0;
		private var _isRotating:Boolean = false;
		
		private var _rotationThreshold:Number = 3;
		private var _minClusterDistance:Number = 0.5;
		private var _localDeltaRotation:Number = 0;
		
		public function get rotationThreshold():Number {
			return _rotationThreshold;
		}
		
		public function set rotationThreshold(value:Number):void {
			_rotationThreshold = value;
		}
		
		public function get minClusterDistance():Number {
			return _minClusterDistance;
		}
		
		public function set minClusterDistance(value:Number):void {
			_minClusterDistance = value;
		}
		
		public function get localDeltaRotation():Number {
			return _localDeltaRotation;
		}
		
		public function RotateGesture(target:InteractiveObject, ...params) {
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
			
			var deltaRotation:Number = 0;
			var oldPos1:Vector2 = _cluster2.getPreviousCenterPosition(Cluster2.CLUSTER1);
			var oldPos2:Vector2 = _cluster2.getPreviousCenterPosition(Cluster2.CLUSTER2);
			var newPos1:Vector2 = _cluster2.getCenterPosition(Cluster2.CLUSTER1);
			var newPos2:Vector2 = _cluster2.getCenterPosition(Cluster2.CLUSTER2);
			var oldCenterPos:Vector2 = oldPos1.add(oldPos2).$multiply(.5);
			var newCenterPos:Vector2 = newPos1.add(newPos2).$multiply(.5);
			var oldVector:Vector2 = oldPos2.subtract(oldPos1);
			var newVector:Vector2 = newPos2.subtract(newPos1);
			
			var angle:Number = Vector2.angle(oldVector, newVector);
			
			if (_isRotating) {
				deltaRotation = angle;
			} else {
				_rotationBuffer += angle;
				if (_rotationBuffer * _rotationBuffer >= _rotationThreshold * _rotationThreshold) {
					_isRotating = true;
					deltaRotation = _rotationBuffer;
				}
			}
			
			if (Math.abs(deltaRotation) > 0.00001) {
				switch (state) {
					case GestureState.POSSIBLE:
					case GestureState.BEGAN:
					case GestureState.CHANGED:
						_globalTransformCenter = newCenterPos;
						_localTransformCenter = globalToLocalPosition(_globalTransformCenter);
						_previousGlobalTransformCenter = oldCenterPos;
						_previousLocalTransformCenter = globalToLocalPosition(_previousGlobalTransformCenter);
						
						_localDeltaRotation = deltaRotation;
						
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
				resetRotation();
			}
			super.touchesEnded(touches);
		}
		
		protected override function reset():void {
			super.reset();
			_cluster2.removeAllPoints();
			resetRotation();
		}
		
		protected override function resetGestureProperties():void {
			super.resetGestureProperties();
			_localDeltaRotation = 0;
		}
		
		private function resetRotation():void {
			_rotationBuffer = 0;
			_isRotating = false;
		}
		
	}
}