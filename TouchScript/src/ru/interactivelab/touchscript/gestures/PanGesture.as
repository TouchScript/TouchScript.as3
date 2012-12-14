package ru.interactivelab.touchscript.gestures
{
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchManager;
	
	public class PanGesture extends Transform2DGestureBase {
		
		private var _movementBuffer:Point = new Point();
		private var _isMoving:Boolean = false;
		private var _movementThreshold:Number = 0.5;
		private var _globalDeltaPosition:Point = new Point();
		private var _localDeltaPosition:Point = new Point();
		
		public function get movementThreshold():Number {
			return _movementThreshold;
		}
		
		public function set movementThreshold(value:Number):void {
			_movementThreshold = value;
		}
		
		public function get globalDeltaPosition():Point {
			return _globalDeltaPosition.clone();
		}
		
		public function get localDeltaPosition():Point {
			return _localDeltaPosition.clone();
		}
		
		public function PanGesture(target:InteractiveObject, ...params) {
			super(target, params);
		}
		
		protected override function touchesMoved(touches:Array):void {
			super.touchesMoved(touches);
			
			_previousGlobalTransformCenter = _cluster1.getPreviousCenterPosition();
			_globalTransformCenter = _cluster1.getCenterPosition();
			
			if (_isMoving) {
				_localTransformCenter = displayTarget.globalToLocal(_globalTransformCenter);
				_previousLocalTransformCenter = displayTarget.globalToLocal(_previousGlobalTransformCenter);
				_globalDeltaPosition = _globalTransformCenter.subtract(_previousGlobalTransformCenter);
				_localDeltaPosition = _localTransformCenter.subtract(_previousLocalTransformCenter);
			} else {
				_movementBuffer.x += _globalTransformCenter.x - _previousGlobalTransformCenter.x;
				_movementBuffer.y += _globalTransformCenter.y - _previousGlobalTransformCenter.y;
				var dpiMovementThreshold:Number = _movementThreshold * TouchManager.dotsPerCentimeter;
				if (_movementBuffer.length > dpiMovementThreshold) {
					_isMoving = true;
					_previousGlobalTransformCenter = _globalTransformCenter.subtract(_movementBuffer);
					_localTransformCenter = displayTarget.globalToLocal(_globalTransformCenter);
					_previousLocalTransformCenter = displayTarget.globalToLocal(_previousGlobalTransformCenter);
					_globalDeltaPosition = _globalTransformCenter.subtract(_previousGlobalTransformCenter);
					_localDeltaPosition = _localTransformCenter.subtract(_previousLocalTransformCenter);
				} else {
					_globalTransformCenter = _globalTransformCenter.subtract(_movementBuffer);
					_localTransformCenter = displayTarget.globalToLocal(_globalTransformCenter);
					_previousGlobalTransformCenter = _globalTransformCenter;
					_previousLocalTransformCenter = _localTransformCenter;
				}
			}
			
			if (_globalDeltaPosition.length > 0) {
				switch (state) {
					case Gesture.STATE_POSSIBLE:
						setState(Gesture.STATE_BEGAN);
						break;
					case Gesture.STATE_BEGAN:
					case Gesture.STATE_CHANGED:
						setState(Gesture.STATE_CHANGED);
						break;
				}
			}
		}
		
		protected override function reset():void {
			super.reset();
			resetMovement();
		}
		
		protected override function resetGestureProperties():void {
			_globalDeltaPosition.x = 0;
			_globalDeltaPosition.y = 0;
			_localDeltaPosition.x = 0;
			_localDeltaPosition.y = 0;
		}
		
		private function resetMovement():void {
			_movementBuffer.x = 0;
			_movementBuffer.y = 0;
		}
		
		
	}
}