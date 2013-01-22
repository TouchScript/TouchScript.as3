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
	
	import ru.interactivelab.touchscript.IGestureDelegate;
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.events.gestures.GestureEvent;
	import ru.interactivelab.touchscript.touch_internal;
	import ru.valyard.behaviors.core.InteractiveBehavior;
	
	use namespace touch_internal;
	
	public class Gesture extends InteractiveBehavior {
		
		private var _state:String = GestureState.POSSIBLE;
		private var _previousState:String = GestureState.POSSIBLE;
		private var _shouldRecognizeWith:Array = [];
		private var _delegate:IGestureDelegate;
		
		protected var _activeTouches:Array = [];
		
		public function get state():String {
			return _state;
		}
		
		private function set $state(value:String):void {
			_previousState = _state;
			_state = value;
			switch (value) {
				case GestureState.POSSIBLE:
					onPossible();
					break;
				case GestureState.BEGAN:
					onBegan();
					break;
				case GestureState.CHANGED:
					onChanged();
					break;
				case GestureState.RECOGNIZED:
					onRecognized();
					break;
				case GestureState.FAILED:
					onFailed();
					break;
				case GestureState.CANCELLED:
					onCancelled();
					break;
			}
			if (hasEventListener(GestureEvent.STATE_CHANGED)) 
				dispatchEvent(new GestureEvent(GestureEvent.STATE_CHANGED, false, true, value, _previousState));
		}
		
		public function get previousState():String {
			return _previousState;
		}
		
		public function get activeTouches():Array {
			return _activeTouches.concat();
		}
		
		public function get delegate():IGestureDelegate {
			return _delegate;
		}
		
		public function set delegate(value:IGestureDelegate):void {
			_delegate = value;
		}
		
		public function Gesture(target:InteractiveObject, ...params) {
			super(target, params);
			$reset();
		}
		
		public function hasTouchPoint(point:TouchPoint):Boolean {
			return _activeTouches.indexOf(point) > -1;
		}
		
		public function shouldRecognizeSimultaneouslyWith(gesture:Gesture, value:Boolean = true):void {
			if (gesture == this) return;
			
			var index:int = _shouldRecognizeWith.indexOf(gesture);
			if (index == -1) {
				if (value) _shouldRecognizeWith.push(gesture);
			} else {
				if (!value) _shouldRecognizeWith.splice(index, 1);
			}
		}
		
		public function canPreventGesture(gesture:Gesture):Boolean {
			if (_delegate == null) {
				if (gesture.canBePreventedByGesture(this)) {
					if (_shouldRecognizeWith.indexOf(gesture) > -1) {
						return false;
					} else {
						return true;
					}
				} else {
					return false;
				}
			} else {
				return !_delegate.shouldRecognizeSimultaneously(this, gesture);
			}
		}
		
		public function canBePreventedByGesture(gesture:Gesture):Boolean {
			if (_delegate == null) {
				if (_shouldRecognizeWith.indexOf(gesture) > -1) {
					return false;
				} else {
					return true;
				}
			} else {
				return !_delegate.shouldRecognizeSimultaneously(this, gesture);
			}
		}
		
		public function shouldReceiveTouch(touch:TouchPoint):Boolean {
			if (_delegate == null) return true;
			return _delegate.shouldReceiveTouch(this, touch);
		}
		
		public function shouldBegin():Boolean {
			if (_delegate == null) return true;
			return _delegate.shouldBegin(this);
		}
		
		protected function setState(value:String):Boolean {
			if (value == _state && _state != GestureState.CHANGED) return false;
			var newState:String = TouchManager.$gestureChangeState(this, value);
			$state = newState;
			
			return value == newState;
		}
		
		protected function ignoreTouch(point:TouchPoint):void {
			var index:int = _activeTouches.indexOf(point);
			if (index > -1) _activeTouches.splice(index, 1);
			TouchManager.$ignoreTouch(point);
		}
		
		//--------------------------------------------------------------------------
		//
		// Internal functions
		//
		//--------------------------------------------------------------------------
		
		touch_internal function $setState(value:String):void {
			setState(value);
		}
		
		touch_internal function $reset():void {
			_activeTouches.length = 0;
			reset();
		}
		
		touch_internal function $touchesBegan(touches:Array):void {
			_activeTouches = _activeTouches.concat(touches);
			touchesBegan(touches);
		}
		
		touch_internal function $touchesMoved(touches:Array):void {
			touchesMoved(touches);
		}
		
		touch_internal function $touchesEnded(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				var index:int = _activeTouches.indexOf(touch);
				if (index > -1) _activeTouches.splice(index, 1);
			}
			touchesEnded(touches);
		}
		
		touch_internal function $touchesCancelled(touches:Array):void {
			for each (var touch:TouchPoint in touches) {
				var index:int = _activeTouches.indexOf(touch);
				if (index > -1) _activeTouches.splice(index, 1);
			}
			touchesCancelled(touches);
		}
		
		//--------------------------------------------------------------------------
		//
		// Callbacks
		//
		//--------------------------------------------------------------------------
		
		protected function touchesBegan(touches:Array):void {}
		
		protected function touchesMoved(touches:Array):void {}
		
		protected function touchesEnded(touches:Array):void {}
		
		protected function touchesCancelled(touches:Array):void {}
		
		protected function reset():void {}
		
		protected function onPossible():void {}
		
		protected function onBegan():void {}
		
		protected function onChanged():void {}
		
		protected function onRecognized():void {}
		
		protected function onFailed():void {}
		
		protected function onCancelled():void {}
		
	}
}