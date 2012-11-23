package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class Player extends Entity
	{
		[Embed(source = '../assets/sprites/player.png')] private const PLAYER:Class;
		
		private const maxSpeed:Number = 2.5;
		private const tweenTime:Number = 15;
		
		private var playerImage:Image;
		private var canMove:Boolean = true;
		
		public var moveQueue:Array = [];
		public var direction:String;
		
		public function Player( startX:Number = 170, startY:Number = 120 ) 
		{
			// Defining input groups
			Input.define("up", Key.W, Key.UP);
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("down", Key.S, Key.DOWN);
			
			playerImage = new Image(PLAYER);
			playerImage.centerOO();
			
			super(startX, startY, playerImage);
		}
		
		private function moveDone (): void
		{
			canMove = true;
			direction = null;
		}
		
		override public function update():void
		{
			if (Input.pressed("right")) moveQueue.push(Key.RIGHT);
			if (Input.pressed("left")) 	moveQueue.push(Key.LEFT);
			if (Input.pressed("up")) 	moveQueue.push(Key.UP);
			if (Input.pressed("down")) 	moveQueue.push(Key.DOWN);
			
			if ( !canMove ) return;
			
			var dx:int;
			var dy:int;
			
			if (moveQueue.length) 
			{
				var key:uint = moveQueue.shift();

				dx = int(key == Key.RIGHT) - int(key == Key.LEFT);
				dy = int(key == Key.DOWN) - int(key == Key.UP);
			} 
			else 
			{
				dx = int(Input.check("right")) - int(Input.check("left"));
				dy = int(Input.check("down")) - int(Input.check("up"));

				if ((! dx && ! dy) || (dx && dy)) 
				{
					if (direction) 
					{
						//sprite.play(direction);
						direction = null;
					}
					return;
				}
			}
			
			if (dx < 0) direction = "left";
			else if (dx > 0) direction = "right";
			else if (dy < 0) direction = "up";
			else if (dy > 0) direction = "down";
			
			canMove = false;
			
			FP.tween(this, {x: x+dx*Main.TW, y:y+dy*Main.TW}, tweenTime*FP.elapsed, {tweener: FP.tweener, complete: moveDone});
		}
		
		override public function render():void
		{
			super.render();
		}
	}

}