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