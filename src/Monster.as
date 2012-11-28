package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Sarah
	 */
	public class Monster extends Entity
	{
		[Embed(source = '../assets/sprites/monster.png')] private const MONSTER:Class;
		
		protected const tweenTime:Number = 30;
		protected const rotInterval:Number = 2;
		protected const shortRotInterval:Number = 0.5;
		
		protected var monsterImage:Image;
		protected var rotTimer:Number = 0;
		
		public var canMove:Boolean = true;
		
		public var moveQueue:Array = [];
		public var direction:String;
		public var previousDir:String;
		
		// Can we move or do we just rotate
		public var isStatic:Boolean = false;
		
		public function Monster( startX:Number = 170, startY:Number = 120 ) 
		{
			monsterImage = new Image(MONSTER);
			
			direction = "stop";
			previousDir = "stop";
			type = "monster";
			
			monsterImage.centerOO();
			setHitbox(Main.TW, Main.TW, monsterImage.width / 2, monsterImage.height / 2);
			
			super(startX, startY, monsterImage);
		}
		
		protected function moveDone(): void
		{
			canMove = true;
		}
		
		override public function update():void
		{
			if ( !isStatic )
			{
				rotTimer = 0;
				moveRandomly();
			}
			else
			{
				rotateOnSpot();
			}
		}
		
		protected function moveRandomly():void
		{
			if ( !canMove ) return;
			
			var randNo:Number = Math.random();
			
			if ( direction != "stop" )
			{
				previousDir = direction;
			}
		
			if (randNo < 1.0) 	direction = "left";
			if (randNo < 0.8) 	direction = "right";
			if (randNo < 0.6) 	direction = "up";
			if (randNo < 0.4) 	direction = "down";
			if (randNo < 0.2) 	direction = "stop";
				
			var dx:int;
			var dy:int;
			
			if (direction != "stop") 
			{
				dx = int(direction == "right") 	- int(direction == "left");
				dy = int(direction == "down") 	- int(direction == "up");
			}
			
			if ( collide("wall", x + dx * Main.TW, y + dy * Main.TW ) )
			{
				return;
			}
			
			canMove = false;
			
			FP.tween(this, {x: x+dx*Main.TW, y:y+dy*Main.TW}, tweenTime, {tweener: FP.tweener, complete: moveDone});
		}
		
		public function moveWithDirection( tweeningTime:Number = tweenTime ):void
		{
			if ( !canMove ) return;
			
			var dx:int;
			var dy:int;
			
			var directionToUse:String = direction;
			
			if (direction != "stop") 
			{
				previousDir = direction;
				directionToUse = previousDir;
			}
			
			dx = int(directionToUse == "right") - int(directionToUse == "left");
			dy = int(directionToUse == "down") 	- int(directionToUse == "up");
			
			if ( collide("wall", x + dx * Main.TW, y + dy * Main.TW ) )
			{
				hitWall();
				return;
			}
			
			if ( collide("mirror", x + dx * Main.TW, y + dy * Main.TW ) )
			{
				hitMirror();
			}
			
			canMove = false;
			
			FP.tween(this, {x: x+dx*Main.TW, y:y+dy*Main.TW}, tweeningTime, {tweener: FP.tweener, complete: moveDone});
		}
		
		public function rotateOnSpot( rotationInt:Number = rotInterval ):void
		{
			rotTimer += FP.elapsed;
			
			if ( rotTimer > rotationInt )
			{
				rotTimer -= rotationInt;
				previousDir = direction;
				
				while (true) {
					switch( direction )
					{
						case "up":
							direction = "right";
							break;
						case "right":
							direction = "down";
							break;
						case "down":
							direction = "left";
							break;
						case "left":
							direction = "up";
							break;
						default:
							direction = "up";
							break;
					}
					
					var dx:int = int(direction == "right") 	- int(direction == "left");
					var dy:int = int(direction == "down") 	- int(direction == "up");
					
					if ( ! collide("wall", x + dx * Main.TW, y + dy * Main.TW ) )
					{
						break;
					}
				}
			}
		}
		
		protected function hitWall():void
		{
			
		}
		
		protected function hitMirror():void
		{
			
		}
	}

}