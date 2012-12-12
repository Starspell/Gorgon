package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.*;
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
		public static const playerTweenTime:Number = 15;
		
		private var playerImage:Spritemap;
		private var canMove:Boolean = true;
		
		private var deathSound:Sfx = new Sfx(DEATH);
		private var stairsSound:Sfx = new Sfx(STAIRS);
		
		public var moveQueue:Array = [];
		public var direction:String;
		public var previousDir:String;
		
		public var hasMoved:Boolean = false;
		
		public var blind:Boolean = false;
		
		public function Player( startX:Number = 170, startY:Number = 120 ) 
		{
			// Defining input groups
			Input.define("up", Key.W, Key.UP);
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("down", Key.S, Key.DOWN);
			
			playerImage = new Spritemap(PLAYER, 16, 16);
			
			var dirs:Array = ["down", "up", "left", "right"];
			
			for (var i:int = 0; i < dirs.length; i++) {
				playerImage.add(dirs[i],  [i*1 + 0], 0.1);
				playerImage.add("move" + dirs[i],  [i*1 + 0], 0.1);
			}
			
			playerImage.centerOO();
			setHitbox(Main.TW, Main.TW, playerImage.width / 2, playerImage.height / 2);
			
			type = "player";
			
			super(startX, startY, playerImage);
		}
		
		private function moveDone (): void
		{
			playerImage.play(direction);
			canMove = true;
			direction = null;
		}
		
		override public function update():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			if ( Input.pressed(Key.M) )
			{
				Main.toggleSounds();
			}
			
			// Changing restart to R
			if ( Input.pressed(Key.R) )
			{
				playerDies();
				if ( currentWorld )
				{
					FP.world = new GameWorld( currentWorld.id, null, currentWorld.startAtEnd, currentWorld.spawnBabyOnStairs );
				}
				return;
			}
			
			if ( !Main.honourMode && currentWorld && currentWorld.showDeath )
			{
				return;
			}
			
			if ( Main.honourMode )
			{
				blind = false;
			}
			
			if ( !Main.honourMode && Input.pressed(Key.SPACE) )
			{
				blind = !blind;
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
					FP.world = new GameWorld( currentWorld.id, null, currentWorld.startAtEnd, currentWorld.spawnBabyOnStairs );
				}
				return;
			}
			
			if ( !canMove ) return;
			
			if ( collide( "spike", x, y ) || collide( "gorgon", x, y ) )
			{
				playerDies();
				if ( currentWorld )
				{
					FP.world = new GameWorld( currentWorld.id, null, currentWorld.startAtEnd, currentWorld.spawnBabyOnStairs );
				}
				return;
			}
			
			if ( collide("stairsDown", x, y) )
			{
				if ( !Main.mute )
				{
					stairsSound.play();
				}
				
				if ( currentWorld )
				{
					if ( currentWorld.id + 1 == LevelList.levels.length )
					{
						FP.world = new WinScreen();
					}
					else
					{
						FP.world = new GameWorld( currentWorld.id + 1, null, 
							false, currentWorld.gorgonBabyRef != null && !currentWorld.gorgonBabyRef.isStatic );
					}
				}
				return;
			}
			
			if ( collide("stairsUp", x, y) )
			{
				if ( !Main.mute )
				{
					stairsSound.play();
				}
				
				if ( currentWorld.id - 1 < 0 )
				{
					FP.world = new WinScreen();
				}
				else
				{
					FP.world = new GameWorld( currentWorld.id - 1, null, 
						true, currentWorld.gorgonBabyRef != null && !currentWorld.gorgonBabyRef.isStatic );
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
						//playerImage.play(direction);
						direction = null;
					}
					return;
				}
			}
			
			if (dx < 0) direction = "left";
			else if (dx > 0) direction = "right";
			else if (dy < 0) direction = "up";
			else if (dy > 0) direction = "down";
			
			playerImage.play("move" + direction);
			
			var gBlock:GlassBlock = collide("glassblock", x + dx * Main.TW, y + dy * Main.TW ) as GlassBlock;
			
			if ( collide("wall", x + dx * Main.TW, y + dy * Main.TW ) || ( gBlock && !gBlock.broken ))
			{
				return;
			}
			
			canMove = false;
			
			if ( currentWorld && currentWorld.gorgonBabyRef )
			{
				currentWorld.gorgonBabyRef.targetTileX = x / Main.TW;
				currentWorld.gorgonBabyRef.targetTileY = y / Main.TW;
			}
			
			FP.tween(this, {x: x+dx*Main.TW, y:y+dy*Main.TW}, playerTweenTime, {tweener: FP.tweener, complete: moveDone});
		}
		
		private function updateSight():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			if ( currentWorld )
			{
				var directionToUse:String = !direction ? previousDir : direction;
				
				var entities:Array = SightManager.getPointsOfSight( x, y, directionToUse );
				
				var last:Entity = entities[entities.length - 1];
				
				if ((Main.honourMode || !blind) && last && last.type == "gorgon") {
					currentWorld.showDeath = true;
					return;
				}
			}
			
			currentWorld.showDeath = false;
		}
		
		private function playerDies():void
		{
			if ( !Main.mute )
			{
				deathSound.play();
			}
		}
	}

}