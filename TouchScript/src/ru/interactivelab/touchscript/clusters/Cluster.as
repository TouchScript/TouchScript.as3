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
package ru.interactivelab.touchscript.clusters {
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchPoint;

	public class Cluster {
		
		public static const RESULT_NOTHING:String				= "resultNothing";
		public static const RESULT_POINT_ADDED:String			= "resultPointAdded";
		public static const RESULT_FIRST_POINT_ADDED:String		= "resultFirstPointAdded";
		public static const RESULT_POINT_REMOVED:String			= "resultPointRemoved";
		public static const RESULT_LAST_POINT_REMOVED:String	= "resultLastPointRemoved";
		
		protected var _points:Array = [];
		protected var _dirty:Boolean = false;
		
		public function get pointsCount():int {
			return _points.length;
		}
		
		public function Cluster() {
			markDirty();
		}
		
		public function addPoint(point:TouchPoint):String {
			if (_points.indexOf(point) != -1) return RESULT_NOTHING;
			
			_points.push(point);
			markDirty();
			
			if (pointsCount == 1) return RESULT_FIRST_POINT_ADDED;
			return RESULT_POINT_ADDED;
		}
		
		public function removePoint(point:TouchPoint):String {
			var index:int = _points.indexOf(point);
			if (index == -1) return RESULT_NOTHING;
			
			_points.splice(index, 1);
			markDirty();
			
			if (pointsCount == 0) return RESULT_LAST_POINT_REMOVED;
			return RESULT_POINT_REMOVED;
		}
		
		public function invalidate():void {
			markDirty();
		}
		
		public function removeAllPoints():void {
			_points.length = 0;
			markDirty();
		}
		
		protected function markDirty():void {
			_dirty = true;
		}
		
		protected function markClean():void {
			_dirty = false;
		}
		
		protected function _getCenterPosition(touches:Array):Point {
			var length:int = touches.length;
			if (length == 0) throw new Error("No points in cluster.");
			if (length == 1) return (touches[0] as TouchPoint).position;
			
			var x:Number = 0;
			var y:Number = 0;
			for each (var point:TouchPoint in touches) {
				x += point.position.x;
				y += point.position.y;
			}
			return new Point(x/length, y/length);
		}
		
		protected function _getPreviousCenterPosition(touches:Array):Point {
			var length:int = touches.length;
			if (length == 0) throw new Error("No points in cluster.");
			if (length == 1) return (touches[0] as TouchPoint).previousPosition;
			
			var x:Number = 0;
			var y:Number = 0;
			for each (var point:TouchPoint in touches) {
				x += point.previousPosition.x;
				y += point.previousPosition.y;
			}
			return new Point(x/length, y/length);
		}
		
		protected function getHash(touches:Array):String {
			var result:String = "";
			for each (var point:TouchPoint in touches) {
				result += "#" + point.id;
			}
			return result;
		}
		
	}
}