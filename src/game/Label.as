package src.game {
  
  import flash.display.*;
  import flash.utils.*;
	import flash.text.*;
  
  public class Label {
    
    [Embed(source="../../font/FEASFBRG.TTF", fontFamily="gameFont")]
    private var Font: String;
    
    private var label: TextField;
    private var labelShadow: TextField;
    
    private var text: String;
    private var size: uint;
    private var color: uint;
    private var colorShadow: uint;
    
    public function Label(text: String = "", size: uint = 50, color: uint = 0xFFFFFF, colorShadow: uint = 0x000000) {
      
      this.text = text;
      this.size = size;
      this.color = color;
      this.colorShadow = colorShadow;
    }
    
    public function appendTo(target: Sprite, x: uint, y: uint, displacement: uint = 5): void {
      
      labelShadow = createLabel(text, createTextFormat("gameFont", colorShadow, size), x + displacement, y + displacement);
      target.addChild(labelShadow);
      
      label = createLabel(text, createTextFormat("gameFont", color, size), x, y);
      target.addChild(label);
    }
    
    public function setText(text: String): void {
      
      this.label.text = text;
      this.labelShadow.text = text;
    }
    
    private function createTextFormat(font: String, color: uint, size: uint): TextFormat {
      
      var format: TextFormat = new TextFormat();
      format.font = font;
      format.color = color;
      format.size = size;
      
      return format;
    }
    
    private function createLabel(text: String, format: TextFormat, x: uint, y: uint): TextField {
      
      var label: TextField = new TextField();
      label.embedFonts = true;
      label.autoSize = TextFieldAutoSize.LEFT;
      label.antiAliasType = AntiAliasType.ADVANCED;
      label.defaultTextFormat = format;
      label.text = text;
      label.x = x;
      label.y = y;
      
      return label;
    }
  }
}
