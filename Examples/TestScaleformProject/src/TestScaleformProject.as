package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	
	import interfaces.Example1;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.debugging.TouchDebugger;
	import ru.interactivelab.touchscript.inputSources.MouseInput;
	import ru.interactivelab.touchscript.inputSources.ScaleformInput;
	
	[SWF(frameRate="60", width="1280", height="800")]
	public class TestScaleformProject extends Sprite {
		
		private var _scaleformInput:ScaleformInput;
		private var _mouseInput:MouseInput;
		
		public function TestScaleformProject() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			TouchManager.init(stage);
			_scaleformInput = new ScaleformInput(stage);
			_mouseInput = new MouseInput(stage);
			
//			var s:Sprite = new Sprite();
//			addChild(s);
//			s.graphics.beginFill(0xFF0000);
//			s.graphics.drawRect(100, 100, stage.stageWidth-200, stage.stageHeight-200);
			
			var example:Sprite = new Example1();
			addChild(example);
			
			
			addChild(new TouchDebugger());			
			
			if (ExternalInterface.available) ExternalInterface.call("RegisterScaleformInput", this);
		}
		
		//--------------------------------------------------------------------------
		//
		// Scaleform callbacks
		//
		//--------------------------------------------------------------------------
		
		public function Scaleform_beginTouch(id:int, x:Number, y:Number):int {
			return _scaleformInput.Scaleform_beginTouch(id, x, y);
		}
		
		public function Scaleform_endTouch(id:int):void {
			_scaleformInput.Scaleform_endTouch(id);
		}
		
		public function Scaleform_moveTouch(id:int, x:Number, y:Number):void {
			_scaleformInput.Scaleform_moveTouch(id, x, y);
		}
		
		public function Scaleform_cancelTouch(id:int):void {
			_scaleformInput.Scaleform_cancelTouch(id);
		}
	}
}