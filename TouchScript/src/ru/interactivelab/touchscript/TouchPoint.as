package ru.interactivelab.touchscript {
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	use namespace touch_internal;
	
	public class TouchPoint {
		
		private var _id:int;
		private var _position:Point;
		private var _previousPosition:Point;
		private var _target:InteractiveObject;
		
		public function get id():int {
			return _id;
		}
		
		public function get position():Point {
			return _position;
		}
		
		public function set position(value:Point):void {
			_previousPosition = _position;
			_position = value;
		}
		
		public function get previousPosition():Point {
			return _previousPosition;
		}
		
		public function get target():InteractiveObject {
			return _target;
		}
		
		touch_internal function set target(value:InteractiveObject):void {
			_target = value;
		}
		
		public function TouchPoint(id:int, position:Point) {
			_id = id;
			_position = position.clone();
			_previousPosition = position.clone();
		}
	}
}