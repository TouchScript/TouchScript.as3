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
package ru.interactivelab.touchscript.utils {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public class DisplayObjectUtils {
		
		/**
		 * Searches display list for top most instance of InteractiveObject.
		 * Checks if mouseEnabled is true and (optionally) parent's mouseChildren.
		 * @param stage				Stage object.
		 * @param point				Global point to test.
		 * @param mouseChildren		If true also checks parents chain for mouseChildren == true.
		 * @param startFrom			An index to start looking from in objects under point array.
		 * @return					Top most InteractiveObject or Stage.
		 */
		public static function getTopTarget(stage:Stage, point:Point, mouseChildren:Boolean = true, startFrom:uint = 0):InteractiveObject {
			var targets:Array = stage.getObjectsUnderPoint(point);
			if (!targets.length) return stage;
			
			var startIndex:int = targets.length - 1 - startFrom;
			if (startIndex < 0) return stage;
			
			outer:
			for (var i:int = startIndex; i >= 0; i--) {
				var target:DisplayObject = targets[i];
				while (target != stage) {
					if (target is InteractiveObject) {
						if ((target as InteractiveObject).mouseEnabled) {
							if (mouseChildren) {
								var lastMouseActive:InteractiveObject = target as InteractiveObject;
								var parent:DisplayObjectContainer = target.parent;
								while (parent) {
									if (!lastMouseActive && parent.mouseEnabled) {
										lastMouseActive = parent;
									} else if (!parent.mouseChildren) {
										if (parent.mouseEnabled) {
											lastMouseActive = parent;
										} else {
											lastMouseActive = null;
										}
									}
									parent = parent.parent;
								}
								if (lastMouseActive) {
									return lastMouseActive;
								} else {
									return stage;
								}
							} else {
								return target as InteractiveObject;
							}
						} else {
							continue outer;
						}
					} else {
						target = target.parent;
					}
				}
			}
			
			return stage;
		}
		
	}
}