package ru.interactivelab.touchscript.inputSources
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.valyard.osc.connection.UDPOSCServerConnection;
	import ru.valyard.osc.tuio.connection.ITUIOConnection;
	import ru.valyard.osc.tuio.connection.ITUIOCursorListener;
	import ru.valyard.osc.tuio.connection.TUIOConnection;
	import ru.valyard.osc.tuio.data.TUIOCursor;

	public class TuioInput extends InputSource implements ITUIOCursorListener {
		
		private var _connection:TUIOConnection;
		private var _cursorToInternalId:Dictionary = new Dictionary();
		
		private var _port:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		private var _movementThreshold:Number = 0.1; // 1mm
		
		public function get movementThreshold():Number {
			return _movementThreshold;
		}
		
		public function set movementThreshold(value:Number):void {
			_movementThreshold = value;
			setMovementThreshold();
		}
		
		public function TuioInput(stageWidth:int, stageHeight:int, port:int = 3333) {
			super();
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			_port = port;
			
			_connection = new TUIOConnection(new UDPOSCServerConnection("0.0.0.0", _port));
			_connection.addListener(this);
			setMovementThreshold();
		}
		
		public function addTUIOCursor(cursor:TUIOCursor):void {
			if (_cursorToInternalId[cursor.sessionID] != undefined) return;
			_cursorToInternalId[cursor.sessionID] = beginTouch(new Point(cursor.x * _stageWidth, cursor.y * _stageHeight));
		}
		
		public function updateTUIOCursor(cursor:TUIOCursor):void {
			if (_cursorToInternalId[cursor.sessionID] == undefined) return;
			moveTouch(_cursorToInternalId[cursor.sessionID], new Point(cursor.x * _stageWidth, cursor.y * _stageHeight));
		}
		
		public function removeTUIOCursor(cursor:TUIOCursor):void {
			if (_cursorToInternalId[cursor.sessionID] == undefined) return;
			endTouch(_cursorToInternalId[cursor.sessionID]);
			delete _cursorToInternalId[cursor.sessionID];
		}
		
		private function setMovementThreshold():void {
			_connection.movementThreshold = _movementThreshold * TouchManager.dotsPerCentimeter / Math.max(_stageWidth, _stageHeight);
		}
		
	}
}