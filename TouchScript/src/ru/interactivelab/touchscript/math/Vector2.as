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
package ru.interactivelab.touchscript.math {
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.touch_internal;
	
	use namespace touch_internal;
	
	/**
	 * Immutable 2d vector.
	 */
	public class Vector2 {
		
		public static const ZERO:Vector2 = new Vector2(0, 0);
		
		public static function fromPoint(value:Point):Vector2 {
			if (value.x == 0 && value.y == 0) return ZERO;
			return new Vector2(value.x, value.y);
		}
		
		public static function distance(one:Vector2, two:Vector2):Number {
			var dx:Number = one.$x - two.$x;
			var dy:Number = one.$y - two.$y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function sqrDistance(one:Vector2, two:Vector2):Number {
			var dx:Number = one.$x - two.$x;
			var dy:Number = one.$y - two.$y;
			return dx * dx + dy * dy;
		}
		
		public static function dot(one:Vector2, two:Vector2):Number {
			return one.$x * two.$x + one.$y * two.$y;
		}
		
		public static function cross(one:Vector2, two:Vector2):Number {
			return one.$x * two.$y - one.$y * two.$x;
		}
		
		public static function angle(one:Vector2, two:Vector2):Number {
			var alpha:Number = Math.acos((one.$x * two.$x + one.$y * two.$y) / (one.magnitude * two.magnitude)) * Consts.RADIANS_TO_DEGREES;
			if (one.$x * two.$y - one.$y * two.$x < 0) alpha = -alpha; // crossproduct
			return alpha;
		}
		
		touch_internal var $x:Number;
		touch_internal var $y:Number;
		
		public function get x():Number { return $x; }
		
		public function get y():Number { return $y; }
		
		public function get magnitude():Number {
			return Math.sqrt($x * $x + $y *$y);
		}
		
		public function get sqrMagnitude():Number {
			return $x * $x + $y *$y;
		}
		
		public function Vector2(x:Number = 0, y:Number = 0) {
			$x = x;
			$y = y;
		}
		
		public function equals(value:Vector2):Boolean {
			return $x == value.$x && $y == value.$y;
		}
		
		public function toPoint():Point {
			return new Point($x, $y);
		}
		
		public function add(value:Vector2):Vector2 {
			return new Vector2($x + value.$x, $y + value.$y);
		}
		
		public function addElements(x:Number, y:Number):Vector2 {
			return new Vector2($x + x, $y + y);
		}
		
		public function subtract(value:Vector2):Vector2 {
			return new Vector2($x - value.$x, $y - value.$y);
		}
		
		public function multiply(value:Number):Vector2 {
			return new Vector2($x * value, $y * value);
		}
		
		public function divide(value:Number):Vector2 {
			return new Vector2($x / value, $y / value);
		}
		
		touch_internal function $setX(value:Number):Vector2 {
			$x = value;
			return this;
		}
		
		touch_internal function $setY(value:Number):Vector2 {
			$y = value;
			return this;
		}
		
		touch_internal function $set(x:Number, y:Number):Vector2 {
			$x = x;
			$y = y;
			return this;
		}
		
		touch_internal function $add(value:Vector2):Vector2 {
			$x += value.$x;
			$y += value.$y;
			return this;
		}
		
		touch_internal function $addElements(x:Number, y:Number):Vector2 {
			$x += x;
			$y += y;
			return this;
		}
		
		touch_internal function $subtract(value:Vector2):Vector2 {
			$x -= value.$x;
			$y -= value.$y;
			return this;
		}
		
		touch_internal function $multiply(value:Number):Vector2 {
			$x *= value;
			$y *= value;
			return this;
		}
		
		touch_internal function $divide(value:Number):Vector2 {
			$x /= value;
			$y /= value;
			return this;
		}
		
	}
}