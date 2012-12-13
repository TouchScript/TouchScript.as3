package ru.interactivelab.touchscript.inputSources
{
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchManager;

	public class InputSource {
		public function InputSource() {}
		
		public var coordinatesRemapper:ICoordinatesRemapper;
		
		protected function beginTouch(position:Point):int {
			if (coordinatesRemapper != null) position = coordinatesRemapper.remap(position);
			return TouchManager.beginTouch(position);
		}
		
		protected function endTouch(id:int):void {
			TouchManager.endTouch(id);
		}
		
		protected function moveTouch(id:int, position:Point):void {
			if (coordinatesRemapper != null) position = coordinatesRemapper.remap(position);
			TouchManager.moveTouch(id, position);
		}
		
		protected function cancelTouch(id:int):void {
			TouchManager.cancelTouch(id);
		}
	}
}