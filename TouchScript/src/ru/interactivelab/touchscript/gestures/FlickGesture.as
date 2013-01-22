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
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster;
	import ru.interactivelab.touchscript.clusters.Cluster1;
	import ru.interactivelab.touchscript.utils.Time;
	
	public class FlickGesture extends Gesture {
		
		private var _cluster:Cluster1 = new Cluster1();
		private var _moving:Boolean = false;
		private var _movementBuffer:Point = new Point();
		private var _positionDeltas:Array = [];
		private var _timeDeltas:Array = [];
		private var _previousTime:Number = 0;
		
		private var _flickTime:Number = .5;
		private var _minDistance:Number = 1;
		private var _movementThreshold:Number = .5;
		private var _horizontal:Boolean = false;
		private var _vertical:Boolean = false;
		private var _screenFlickVector:Point = new Point();
		
		public function get flickTime():Number {
			return _flickTime;
		}
		
		public function set flickTime(value:Number):void {
			_flickTime = value;
		}
		
		public function get minDistance():Number {
			return _minDistance;
		}
		
		public function set minDistance(value:Number):void {
			_minDistance = value;
		}
		
		public function get movementThreshold():Number {
			return _movementThreshold;
		}
		
		public function set movementThreshold(value:Number):void {
			_movementThreshold = value;
		}
		
		public function get horizontal():Boolean {
			return _horizontal;
		}
		
		public function set horizontal(value:Boolean):void {
			_horizontal = value;
		}
		
		public function get vertical():Boolean {
			return _vertical;
		}
		
		public function set vertical(value:Boolean):void {
			_vertical = value;
		}
		
		public function get screenFlickVector():Point {
			return _screenFlickVector;
		}
		
		public function FlickGesture(target:InteractiveObject, ...params) {
			super(target, params);
		}
		
		protected override function touchesBegan(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				if (_cluster.addPoint(touch) == Cluster.RESULT_FIRST_POINT_ADDED) _previousTime = Time.time;
			}
		}
		
		protected override function touchesMoved(touches:Array):void {
			_cluster.invalidate();
			var delta:Point = _cluster.getCenterPosition().subtract(_cluster.getPreviousCenterPosition());
			if (!_moving) {
				_movementBuffer = _movementBuffer.add(delta);
				var dpiMovementThreshold:Number = _movementThreshold * TouchManager.dotsPerCentimeter;
				if (_movementBuffer.length >= dpiMovementThreshold) {
					_moving = true;
				}
			}
			
			_positionDeltas.push(delta);
			_timeDeltas.push(Time.time - _previousTime);
			_previousTime = Time.time;
		}
		
		protected override function touchesEnded(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				if (_cluster.removePoint(touch) == Cluster.RESULT_LAST_POINT_REMOVED) {
					if (!_moving) {
						setState(GestureState.FAILED);
						return;
					}
					
					var totalTime:Number = 0;
					var totalMovement:Point = new Point();
					var i:int = _timeDeltas.length - 1;
					while (i >= 0 && totalTime < _flickTime) {
						if (totalTime + _timeDeltas[i] < _flickTime) {
							totalTime += _timeDeltas[i];
							totalMovement.x += _positionDeltas[i].x;
							totalMovement.y += _positionDeltas[i].y;
							i++;
						} else {
							break;
						}
					}
					
					if (_horizontal) totalMovement.y = 0;
					if (_vertical) totalMovement.x = 0;
					
					if (totalMovement.length < _minDistance * TouchManager.dotsPerCentimeter) {
						setState(GestureState.FAILED);
					} else {
						_screenFlickVector = totalMovement;
						setState(GestureState.RECOGNIZED);
					}
				}
			}
			
		}
		
		protected override function touchesCancelled(touches:Array):void {
			touchesEnded(touches);
		}
		
		protected override function reset():void {
			_cluster.removeAllPoints();
			_moving = false;
			_movementBuffer = new Point();
			_timeDeltas.length = 0;
			_positionDeltas.length = 0;
		}
		
	}
}