package src.game {
  
  import As3Math.geo2d.*;
	import QuickB2.objects.tangibles.*;
	import QuickB2.stock.*;
	import QuickB2.objects.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	
  
  public class Make {
    
    public static const RECT: uint = 0;
    public static const CIRCLE: uint = 1;
    
    public static var cursorState: amPoint2d;
    public static var scrolling: Boolean = false;
    
    public static function newWorld(target: Stage, gravity: Number, wall: Boolean = false): qb2World {
		  
		  var world: qb2World = new qb2World();
		  
		  world.gravity = new amVector2d(0, gravity);
		  world.realtimeUpdate = true;
		  world.actor = target;
		  
		  if(wall){
		    
		    world.addObject(new qb2StageWalls(target));
		  }
		  
		  return world;
		}
    
    public static function newBody(position: amPoint2d, img: DisplayObject, type: uint, mass: Number = 1.0, restitution: Number = 0.5, friction: Number = 0.5): qb2Body {
		  
		  var body: qb2Body = new qb2Body();
		  
			body.actor = img;
			body.position = position;
			
			var point: amPoint2d = new amPoint2d(img.width / 2, img.height / 2);
			
			var shape: qb2Shape = (type == RECT) ? 
			  qb2Stock.newRectShape(point, img.width, img.height) : 
			  qb2Stock.newCircleShape(point, img.width / 2)
			
			body.addObject(shape);
			body.mass = mass;
			body.restitution = restitution;
			body.friction = friction;
			
			return body;
		}
		
		public static function newSprite(width: uint, height: uint, color: uint): Sprite {
		  
		  var sprite: Sprite = new Sprite();
		  
		  sprite.graphics.beginFill(color);
		  sprite.graphics.drawRect(0, 0, width, height);
		  sprite.graphics.endFill();
		  
		  return sprite;
		}
		
		public static function newCircleSprite(radius: uint, color: uint, alpha: Number = 0.5): Sprite {
		  
		  var sprite: Sprite = new Sprite();
		  
		  sprite.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, color], [0.1, 1], [0, 127]);
		  sprite.graphics.drawCircle(0, 0, radius);
		  sprite.graphics.endFill();
		  
		  return sprite;
		}
		
		public static function newScroll(target: Stage, callback: Function): void {
		  
		  target.addEventListener(MouseEvent.MOUSE_DOWN, function getMouseState(event: MouseEvent): void {
        
        cursorState = new amPoint2d(target.mouseX, target.mouseY);
        Mouse.cursor = flash.ui.MouseCursor.HAND;
        scrolling = true;
      });
      
      target.addEventListener(MouseEvent.MOUSE_UP, function stopMove(event: MouseEvent): void {
        
        Mouse.cursor = flash.ui.MouseCursor.ARROW;
        scrolling = false;
      });
      
      target.addEventListener(MouseEvent.MOUSE_MOVE, callback);
		}
  }
}
