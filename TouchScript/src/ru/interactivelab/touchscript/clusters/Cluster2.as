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
	import flash.errors.IllegalOperationError;
	
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.math.Vector2;
	import ru.interactivelab.touchscript.touch_internal;
	
	use namespace touch_internal;
	
	public class Cluster2 extends Cluster {
		
		public static const CLUSTER1:int			= 0;
		public static const CLUSTER2:int			= 1;
		
		private var _cluster1:Array = [];
		private var _cluster2:Array = [];
		private var _minPointsDistance:Number;
		private var _minPointsDistanceSquared:Number;
		
		public function get minPointsDistance():Number {
			return _minPointsDistance;
		}
		
		public function set minPointsDistance(value:Number):void {
			_minPointsDistance = value;
			_minPointsDistanceSquared = value * value;
		}
		
		public function get hasClusters():Boolean {
			if (_points.length < 2) return false;
			for each (var p1:TouchPoint in _points) {
				for each (var p2:TouchPoint in _points) {
					if (p1 == p2) continue;
					if (Vector2.sqrDistance(p1.position, p2.position) >= _minPointsDistanceSquared) return true;
				}
			}
			return false;
		}
		
		public function Cluster2() {
			super();
			minPointsDistance = 1;
		}
		
		public function getCenterPosition(id:int):Vector2 {
			if (!hasClusters) throw new IllegalOperationError("Cluster has less than 2 points.");
			if (_dirty) distributePoints();
			
			var result:Vector2;
			switch (id) {
				case CLUSTER1:
					result = _getCenterPosition(_cluster1);
					break;
				case CLUSTER2:
					result = _getCenterPosition(_cluster2);
					break;
				default:
					throw new IllegalOperationError(id + " is not a valid cluster index.");
			}
			return result;
		}
		
		public function getPreviousCenterPosition(id:int):Vector2 {
			if (!hasClusters) throw new IllegalOperationError("Cluster has less than 2 points.");
			if (_dirty) distributePoints();
			
			var result:Vector2;
			switch (id) {
				case CLUSTER1:
					result = _getPreviousCenterPosition(_cluster1);
					break;
				case CLUSTER2:
					result = _getPreviousCenterPosition(_cluster2);
					break;
				default:
					throw new IllegalOperationError(id + " is not a valid cluster index.");
			}
			return result;
		}
		
		private function distributePoints():void {
			_cluster1.length = 0;
			_cluster2.length = 0;
			_cluster1.push(_points[0]);
			_cluster2.push(_points[1]);
			
			var total:int = _points.length;
			if (total == 2) return;
			
			var oldHash1:String = "";
			var oldHash2:String = "";
			var hash1:String = "#";
			var hash2:String = "#";
			
			while (oldHash1 != hash1 || oldHash2 != hash2) {
				var center1:Vector2 = _getCenterPosition(_cluster1);
				var center2:Vector2 = _getCenterPosition(_cluster2);
				var obj1:TouchPoint;
				var obj2:TouchPoint;
				
				// Take most distant points from cluster1 and cluster2
				var maxDist1:Number = Number.NEGATIVE_INFINITY;
				var maxDist2:Number = Number.NEGATIVE_INFINITY;
				for (var i:int = 0; i < total; i++) {
					var obj:TouchPoint = _points[i];
					var dist:Number = Vector2.sqrDistance(center1, obj.position);
					if (dist > maxDist2) {
						maxDist2 = dist;
						obj2 = obj;
					}
					
					dist = Vector2.sqrDistance(center2, obj.position);
					if (dist > maxDist1) {
						maxDist1 = dist;
						obj1 = obj;
					}
				}
				
				// If it is the same point it means that this point is too far away from both clusters and has to be in a separate cluster
				if (obj1 == obj2) {
					center1 = center1.add(center2).$multiply(.5);
					center2 = obj2.position;
				} else {
					center1 = obj1.position;
					center2 = obj2.position;
				}
				
				_cluster1.length = 0;
				_cluster2.length = 0;
				
				for (i = 0; i < total; i++) {
					obj = _points[i];
					if (Vector2.sqrDistance(center1, obj.position) < Vector2.sqrDistance(center2, obj.position)) {
						_cluster1.push(obj);
					} else {
						_cluster2.push(obj);
					}
				}
				
				oldHash1 = hash1;
				oldHash2 = hash2;
				hash1 = getHash(_cluster1);
				hash2 = getHash(_cluster2);
			}
			
			markClean();
		}
		
	}
}