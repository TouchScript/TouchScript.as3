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
	import ru.interactivelab.touchscript.math.Vector2;
	import ru.interactivelab.touchscript.touch_internal;
	
	use namespace touch_internal;
	
	public class PanGesture extends Transform2DGestureBase {
		
		private var _movementBuffer:Vector2 = new Vector2();
		private var _isMoving:Boolean = false;
		private var _movementThreshold:Number = 0.5;
		private var _globalDeltaPosition:Vector2 = Vector2.ZERO;
		private var _localDeltaPosition:Vector2 = Vector2.ZERO;
		
		public function get movementThreshold():Number {
			return _movementThreshold;
		}
		
		public function set movementThreshold(value:Number):void {
			_movementThreshold = value;
		}
		
		public function get globalDeltaPosition():Vector2 {
			return _globalDeltaPosition;
		}
		
		public function get localDeltaPosition():Vector2 {
			return _localDeltaPosition;
		}
		
		public function PanGesture(target:InteractiveObject, ...params) {
			super(target, params);
		}
		
		protected override function touchesMoved(touches:Array):void {
			super.touchesMoved(touches);
			
			_previousGlobalTransformCenter = _cluster1.getPreviousCenterPosition();
			_globalTransformCenter = _cluster1.getCenterPosition();
			
			if (_isMoving) {
				_localTransformCenter = globalToLocalPosition(_globalTransformCenter);
				_previousLocalTransformCenter = globalToLocalPosition(_previousGlobalTransformCenter);
				_globalDeltaPosition = _globalTransformCenter.subtract(_previousGlobalTransformCenter);
				_localDeltaPosition = _localTransformCenter.subtract(_previousLocalTransformCenter);
			} else {
				_movementBuffer.$add(_globalTransformCenter).$subtract(_previousGlobalTransformCenter);
				var dpiMovementThreshold:Number = _movementThreshold * TouchManager.dotsPerCentimeter;
				if (_movementBuffer.sqrMagnitude > dpiMovementThreshold * dpiMovementThreshold) {
					_isMoving = true;
					_previousGlobalTransformCenter = _globalTransformCenter.subtract(_movementBuffer);
					_localTransformCenter = globalToLocalPosition(_globalTransformCenter);
					_previousLocalTransformCenter = globalToLocalPosition(_previousGlobalTransformCenter);
					_globalDeltaPosition = _globalTransformCenter.subtract(_previousGlobalTransformCenter);
					_localDeltaPosition = _localTransformCenter.subtract(_previousLocalTransformCenter);
				} else {
					_globalTransformCenter = _globalTransformCenter.subtract(_movementBuffer);
					_localTransformCenter = globalToLocalPosition(_globalTransformCenter);
					_previousGlobalTransformCenter = _globalTransformCenter;
					_previousLocalTransformCenter = _localTransformCenter;
				}
			}
			
			if (_globalDeltaPosition.sqrMagnitude > 0) {
				switch (state) {
					case GestureState.POSSIBLE:
						setState(GestureState.BEGAN);
						break;
					case GestureState.BEGAN:
					case GestureState.CHANGED:
						setState(GestureState.CHANGED);
						break;
				}
			}
		}
		
		protected override function reset():void {
			super.reset();
			resetMovement();
		}
		
		protected override function resetGestureProperties():void {
			super.resetGestureProperties();
			_globalDeltaPosition = Vector2.ZERO;
			_localDeltaPosition = Vector2.ZERO;
		}
		
		private function resetMovement():void {
			_isMoving = false;
			_movementBuffer.$set(0, 0);
		}
		
		
	}
}