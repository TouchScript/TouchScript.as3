package ru.interactivelab.touchscript.inputSources
{
	import flash.geom.Point;

	public interface ICoordinatesRemapper {
		function remap(input:Point):Point;
	}
}