package src {
  
  import As3Math.geo2d.*;
	import QuickB2.objects.tangibles.*;
	import QuickB2.stock.*;
	import QuickB2.objects.*;
	
	import flash.display.*;
	import flash.ui.*;
	import flash.events.*;
	
	import src.game.*;
  
  [SWF(width="640", height="480", frameRate="60")]
  public class Main extends Sprite {
    
    private var world: qb2World;
    private var bird: qb2Body;
    private var label: Label;
    private var center: amPoint2d = new amPoint2d(stage.stageWidth / 2, stage.stageHeight / 2);
    private var fieldForce: Sprite;
    private var inc: Number;
    
    public function Main() {
      
      addChild((new Gfx.Background()) as Bitmap);
      world = Make.newWorld(stage, 10.0);
      world.start();
      
      label = new Label("Score: 0");
      label.appendTo(this, 20, 10);
      
      createGround(10);
      createSceneTest();
      control();
      //Make.newScroll(stage, moveScene);
      
      world.addObject(bird = Make.newBody(new amPoint2d(60, 200), (new Gfx.Bird()) as Bitmap, Make.RECT, 1));
      addChild(fieldForce = Make.newCircleSprite(30, 0xFF0000, 0.25));
    }
    
    private function createGround(size: uint): void {
      
      var imgGround: Bitmap = (new Gfx.Ground()) as Bitmap;
      var imgGrass: Bitmap = (new Gfx.Grass()) as Bitmap;
      
      var ini: int = -(imgGround.width * (size / 2));
      
      var ground: qb2Body = Make.newBody(new amPoint2d(0, stage.stageHeight - imgGround.height), imgGround, Make.RECT, 0);
      var grass: qb2Body = Make.newBody(new amPoint2d(0, stage.stageHeight - (imgGround.height + imgGrass.height)), imgGrass, Make.RECT, 0);
      
      for(var i: uint = 0; i < size; i++) {
        
        var temp1: qb2Body = ground.clone() as qb2Body;
        var temp2: qb2Body = grass.clone() as qb2Body;
        temp2.isGhost = true;
        
        temp1.position.x = ini + (imgGround.width * i);
        world.addObject(temp1);
        temp2.position.x = ini + (imgGround.width * i);
        world.addObject(temp2);
        temp2 = temp2.clone() as qb2Body;
        temp2.position.x += imgGrass.width;
        world.addObject(temp2);
      }
    }
    
    private function control(): void {
      
      stage.addEventListener(Event.ENTER_FRAME, function(event: Event): void {
        
        var distance: Number = Math.abs(bird.centerOfMass.x - center.x);
        
        if(Math.abs(bird.linearVelocity.x) > 0.1 || distance > 2) {
          
          inc = (distance > 50) ? 4 : 1;
          
          incrementWorldPosition((bird.centerOfMass.x > center.x) ? inc : -inc);
        }
        
        fieldForce.x = bird.centerOfMass.x;
        fieldForce.y = bird.centerOfMass.y;
      });
      
      stage.addEventListener(MouseEvent.CLICK, function(event: MouseEvent): void {
        
        if(bird.centerOfMass.distanceTo(new amPoint2d(mouseX, mouseY)) < 30) {
          
          Make.scrolling = false;
          Mouse.cursor = flash.ui.MouseCursor.ARROW;
          bird.applyImpulse(bird.centerOfMass, new amVector2d(0.8*(mouseX - bird.centerOfMass.x), 0.8*(mouseY - bird.centerOfMass.y)));
        }
      });
    }
    
    private function createSceneTest(): void {
      
      var initPos: amPoint2d = new amPoint2d(800, stage.stageHeight - 124);
      
      var pig: qb2Body = Make.newBody(initPos, (new Gfx.Pig()) as Bitmap, Make.RECT);
      var block: qb2Body = Make.newBody(initPos, (new Gfx.Block()) as Bitmap, Make.RECT, 0.1);
      var plataform: qb2Body = Make.newBody(initPos, (new Gfx.Plataform()) as Bitmap, Make.RECT, 0.1);
      
      var scene: Array = [
        [0, 0, block.clone()], [0, -30, block.clone()], [0, -60, block.clone()], [0, -90, block.clone()], 
        [60, 0, block.clone()], [60, -30, block.clone()], [60, -60, block.clone()], [60, -90, block.clone()], 
        [0, -120, plataform.clone()], [30, -160, pig.clone()]
      ];
      
      for each(var subArray: Array in scene) {
        
        subArray[2].position.incX(subArray[0]);
        subArray[2].position.incY(subArray[1]);
        
        world.addObject(subArray[2]);
      }
    }
    
    private function incrementWorldPosition(value: Number): void {
      
      for(var i: uint = 0; i < world.numObjects; i++) {
        
        (world.getObjectAt(i) as qb2Body).position.x -= value;
      }
    }
    
    /*private function moveScene(event: MouseEvent): void {
      
      if(Make.scrolling) {
        
        incrementWorldPosition((Make.cursorState.x - stage.mouseX) * 0.1);
      }
    }*/
  }
}
