package test {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Box extends Sprite {
		
		public static const ALIGN_CENTER:String = "center";
		public static const ALIGN_TOP:String = "top";
		
		[Embed(systemFont="Arial", fontName="Arial", mimeType="application/x-font", embedAsCFF=false)]
		private static var font:Class;
		
		private var _width:int;
		private var _height:int;
		private var _defaultColor:uint;
		private var _color:uint;
		private var _align:String;
		
		private var _tf:TextField;
		
		public function Box(width:int, height:int, color:uint, text:String = "", textAlign:String = "center") {
			super();
			
			_width = width;
			_height = height;
			_color = _defaultColor = color;
			_align = textAlign;
			
			_tf = new TextField();
			_tf.embedFonts = true;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			var fmt:TextFormat = _tf.getTextFormat();
			fmt.font = "Arial";
			fmt.align = TextFormatAlign.CENTER;
			_tf.defaultTextFormat = fmt;
			addChild(_tf);
			setText(text);
			
			redraw();
		}
		
		public function setColor(value:uint):void {
			_color = value;
			redraw();
		}
		
		public function resetColor():void {
			_color = _defaultColor;
			redraw();
		}
		
		public function setText(value:String):void {
			_tf.text = value;
			_tf.height = _tf.textHeight + 4;
			redraw();
		}
		
		protected function redraw():void {
			graphics.beginFill(_color);
			graphics.drawRoundRect(0, 0, _width, _height, 20, 20);
			_tf.width = _width;
			_tf.x = 0;
			switch (_align) {
				case ALIGN_TOP:
					_tf.y = 10;
					break;
				default:
					_tf.y = Math.round((_height - _tf.height) * .5);
			}
			
		}
	}
}