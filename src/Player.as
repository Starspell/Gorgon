package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
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
		
		[Embed(source = '../assets/audio/death.mp3')] private const DEATH:Class;
		[Embed(source = '../assets/audio/stairs.mp3')] private const STAIRS:Class;
		
		private const maxSpeed:Number = 2.5;
		private const tweenTime:Number = 15;
		
		private var playerImage:Image;
		private var canMove:Boolean = true;
		
		private var deathSound:Sfx = new Sfx(DEATH);
		private var stairsSound:Sfx = new Sfx(STAIRS);
		
		public var moveQueue:Array = [];
		public var direction:String;
		public var previousDir:String;
		
		public var hasMoved:Boolean = false;
		
		public function Player( startX:Number = 170, startY:Number = 120 ) 
		{
			// Defining input groups
			Input.define("up", Key.W, Key.UP);
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("down", Key.S, Key.DOWN);
			
			playerImage = new Image(PLAYER);
			playerImage.centerOO();
			setHitbox(Main.TW, Main.TW, playerImage.width / 2, playerImage.height / 2);
			
			type = "player";
			
			super(startX, startY, playerImage);
		}
		
		private function moveDone (): void
		{
			canMove = true;
			direction = null;
		}
		
		override public function update():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			if ( Input.pressed(Key.SPACE) )
			{
				playerDies();
				if ( currentWorld )
				{
					FP.world = new GameWorld( currentWorld.id );
				}
				return;
			}
			
			updateSight();
			
			if ( direction ) previousDir = direction;
			
			if (Input.pressed("right")) moveQueue.push(Key.RIGHT);
			if (Input.pressed("left")) 	moveQueue.push(Key.LEFT);
			if (Input.pressed("up")) 	moveQueue.push(Key.UP);
			if (Input.pressed("down")) 	moveQueue.push(Key.DOWN);
			
			var m:Monster = collide("monster", x, y) as Monster;
			var crashing:Boolean;
			
			if ( (m && m.canMove) )
			{
				playerDies();
				if ( currentWorld )
				{
					FP.world = new GameWorld( currentWorld.id );
				}
				return;
			}
			
			if ( !canMove ) return;
			
			if ( collide( "spike", x, y ) || collide( "gorgon", x, y ) )
			{
				playerDies();
				if ( currentWorld )
				{
					FP.world = new GameWorld( currentWorld.id );
				}
				return;
			}
			
			if ( collide("goal", x, y) )
			{
				stairsSound.play();
				if ( currentWorld )
				{
					FP.world = new GameWorld( currentWorld.id + 1 );
				}
				return;
			}
			
			var dx:int;
			var dy:int;
			
			if (moveQueue.length) 
			{
				if ( !hasMoved ) hasMoved = true;
				
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
			
			if ( collide("wall", x + dx * Main.TW, y + dy * Main.TW ) )
			{
				return;
			}
			
			if (dx < 0) direction = "left";
			else if (dx > 0) direction = "right";
			else if (dy < 0) direction = "up";
			else if (dy > 0) direction = "down";
			
			canMove = false;
			
			FP.tween(this, {x: x+dx*Main.TW, y:y+dy*Main.TW}, tweenTime, {tweener: FP.tweener, complete: moveDone});
		}
		
		private function updateSight():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			if ( currentWorld )
			{
				var directionToUse:String = !direction ? previousDir : direction;
				
				var blockingPoints:Array = SightManager.getPointsOfSight( x, y, directionToUse );
				
				for ( var i:int = 0; i < blockingPoints.length; i += 2 )
				{
					if ( currentWorld.getTypeAt( blockingPoints[i], blockingPoints[i + 1] ) == "gorgon" )
					{
						currentWorld.showDeath = true;
						return;
					}
				}
			}
			
			currentWorld.showDeath = false;
		}
		
		private function playerDies():void
		{
			deathSound.play();
		}
	}

}