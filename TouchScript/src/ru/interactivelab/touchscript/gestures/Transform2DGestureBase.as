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
	
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.clusters.Cluster;
	import ru.interactivelab.touchscript.clusters.Cluster1;
	import ru.interactivelab.touchscript.math.Vector2;
	
	public class Transform2DGestureBase extends Gesture {
		
		protected var _cluster1:Cluster1 = new Cluster1();
		protected var _localTransformCenter:Vector2 = Vector2.ZERO;
		protected var _previousLocalTransformCenter:Vector2 = Vector2.ZERO;
		protected var _globalTransformCenter:Vector2 = Vector2.ZERO;
		protected var _previousGlobalTransformCenter:Vector2 = Vector2.ZERO;
		
		public function get localTransformCenter():Vector2 {
			return _localTransformCenter;
		}
		
		public function get previousLocalTransformCenter():Vector2 {
			return _previousLocalTransformCenter;
		}
		
		public function get globalTransformCenter():Vector2 {
			return _localTransformCenter;
		}
		public function get previousGlobalTransformCenter():Vector2 {
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
		
		protected function globalToLocalPosition(global:Vector2):Vector2 {
			if (displayTarget.parent) {
				return Vector2.fromPoint(displayTarget.parent.globalToLocal(global.toPoint()));
			} else {
				return global;
			}
		}
		
		protected function resetGestureProperties():void {
			_globalTransformCenter = Vector2.ZERO;
			_localTransformCenter = Vector2.ZERO;
		}
		
	}
}