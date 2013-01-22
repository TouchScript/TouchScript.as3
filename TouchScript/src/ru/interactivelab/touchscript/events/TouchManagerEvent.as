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