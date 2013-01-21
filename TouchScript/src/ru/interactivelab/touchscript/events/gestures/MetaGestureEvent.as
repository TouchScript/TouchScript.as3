package ru.interactivelab.touchscript.events.gestures {
	import flash.events.Event;
	
	import ru.interactivelab.touchscript.TouchPoint;
	
	public class MetaGestureEvent extends Event {
		
		public static const TOUCH_POINT_ADDED:String			= "touchPointAdded";
		public static const TOUCH_POINT_UPDATED:String			= "touchPointUpdated";
		public static const TOUCH_POINT_REMOVED:String			= "touchPointRemoved";
		public static const TOUCH_POINT_CANCELLED:String		= "touchPointCancelled";
		
		public var touchPoint:TouchPoint;
		
		public function MetaGestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, touchPoint:TouchPoint = null) {
			super(type, bubbles, cancelable);
			this.touchPoint = touchPoint;
		}
	}
}