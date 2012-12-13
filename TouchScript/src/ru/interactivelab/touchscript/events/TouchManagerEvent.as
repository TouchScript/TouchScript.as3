package ru.interactivelab.touchscript.events {
	import flash.events.Event;
	
	public class TouchManagerEvent extends Event {
		
		public static const TOUCH_POINTS_ADDED:String			= "touchPointsAdded";
		public static const TOUCH_POINTS_UPDATED:String			= "touchPointsUpdated";
		public static const TOUCH_POINTS_REMOVED:String			= "touchPointsRemoved";
		public static const TOUCH_POINTS_CANCELLED:String		= "touchPointsCancelled";
		
		public var touchPoints:Array;
		
		public function TouchManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, touchPoints:Array = null) {
			super(type, bubbles, cancelable);
			this.touchPoints = touchPoints.concat();
		}
	}
}