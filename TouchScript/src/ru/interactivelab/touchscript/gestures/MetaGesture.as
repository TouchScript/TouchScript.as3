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
	import ru.interactivelab.touchscript.events.gestures.MetaGestureEvent;
	
	public class MetaGesture extends Gesture {
		public function MetaGesture(target:InteractiveObject, ...params) {
			super(target, params);
		}
		
		protected override function touchesBegan(touches:Array):void {
			if (state == GestureState.POSSIBLE) setState(GestureState.BEGAN);
			
			if (!hasEventListener(MetaGestureEvent.TOUCH_POINT_ADDED)) return;
			for each (var touch:TouchPoint in touches) {
				dispatchEvent(new MetaGestureEvent(MetaGestureEvent.TOUCH_POINT_ADDED, false, false, touch));
			}
		}
		
		protected override function touchesMoved(touches:Array):void {
			if (state == GestureState.BEGAN || state == GestureState.CHANGED) setState(GestureState.CHANGED);
			
			if (!hasEventListener(MetaGestureEvent.TOUCH_POINT_UPDATED)) return;
			for each (var touch:TouchPoint in touches) {
				dispatchEvent(new MetaGestureEvent(MetaGestureEvent.TOUCH_POINT_UPDATED, false, false, touch));
			}
		}
		
		protected override function touchesEnded(touches:Array):void {
			if (hasEventListener(MetaGestureEvent.TOUCH_POINT_REMOVED)) {
				for each (var touch:TouchPoint in touches) {
					dispatchEvent(new MetaGestureEvent(MetaGestureEvent.TOUCH_POINT_REMOVED, false, false, touch));
				}
			}
			
			if (state == GestureState.BEGAN || state == GestureState.CHANGED) {
				if (_activeTouches.length == 0) setState(GestureState.ENDED);
			}
		}
		
		protected override function touchesCancelled(touches:Array):void {
			if (hasEventListener(MetaGestureEvent.TOUCH_POINT_CANCELLED)) {
				for each (var touch:TouchPoint in touches) {
					dispatchEvent(new MetaGestureEvent(MetaGestureEvent.TOUCH_POINT_CANCELLED, false, false, touch));
				}
			}
			
			if (state == GestureState.BEGAN || state == GestureState.CHANGED) {
				if (_activeTouches.length == 0) setState(GestureState.ENDED);
			}
		}
		
	}
}