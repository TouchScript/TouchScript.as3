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
package ru.interactivelab.touchscript.inputSources {
	import flash.utils.Dictionary;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.math.Vector2;
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
			_cursorToInternalId[cursor.sessionID] = beginTouch(new Vector2(cursor.x * _stageWidth, cursor.y * _stageHeight));
		}
		
		public function updateTUIOCursor(cursor:TUIOCursor):void {
			if (_cursorToInternalId[cursor.sessionID] == undefined) return;
			moveTouch(_cursorToInternalId[cursor.sessionID], new Vector2(cursor.x * _stageWidth, cursor.y * _stageHeight));
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