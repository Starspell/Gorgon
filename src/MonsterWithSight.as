package  
{
	import flash.display.BitmapData;
	import net.flashpunk.graphics.*;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class MonsterWithSight extends Monster 
	{
		[Embed(source = '../assets/sprites/monsterwithsight.png')] private const MONSTERSIGHT:Class;
		
		protected var canSeePlayer:Boolean = false;
		protected var sawPlayer:Boolean = false;
		protected var killsWithSight:Boolean = false;
		
		protected var monsterSight:BitmapData;
		protected var monsterSightImage:Image;
		
		protected var playerLastSeenAtX:Number;
		protected var playerLastSeenAtY:Number;
		
		public function MonsterWithSight( startX:Number = 170, startY:Number = 120 ) 
		{
			super( startX, startY );
			
			monsterImage = new Image(MONSTERSIGHT);
			monsterImage.centerOO();
			graphic = monsterImage;

			monsterSight = new BitmapData(FP.width, FP.height, true, 0x0);
			monsterSightImage = new Image(monsterSight);
			monsterSightImage.relative = false;
			monsterSightImage.alpha = 0.5;
			addGraphic(monsterSightImage);
		}
		
		override public function update():void
		{
			super.update();
			
			updateSight();
		}
		
		protected function updateSight():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			var blockedByWallX:Number;
			var blockedByWallY:Number;
			
			canSeePlayer = false;
			
			monsterSight.fillRect( monsterSight.rect, 0 );
			
			if ( currentWorld )
			{
				var playerX:Number = currentWorld.player.x;
				var playerY:Number = currentWorld.player.y;
				
				var directionToUse:String = direction == "stop" ? previousDir : direction;
				
				switch( directionToUse )
				{
					case "left":
						for ( var i:int = x; i >= 0; i -= Main.TW )
						{
							if ( currentWorld.collidePoint("wall", i, y) )
							{
								blockedByWallX = i;
								blockedByWallY = y;
								
								i = -1;
							}
						}	
						canSeePlayer = playerX < x && playerY == y && blockedByWallX < playerX;
						break;
					case "right":
						for ( var j:int = x; j < FP.width; j += Main.TW )
						{
							if ( currentWorld.collidePoint("wall", j, y) )
							{
								blockedByWallX = j;
								blockedByWallY = y;
								
								j = FP.width;
							}
						}
						canSeePlayer = playerX > x && playerY == y && blockedByWallX > playerX;
						break;
					case "up":
						for ( var k:int = y; k >=0; k -= Main.TW )
						{
							if ( currentWorld.collidePoint("wall", x, k) )
							{
								blockedByWallX = x;
								blockedByWallY = k;
								
								k = -1;
							}
						}
						canSeePlayer = playerX == x && playerY < y && blockedByWallY < playerY;
						break;
					case "down":
						for ( var l:int = y; l < FP.height; l += Main.TW )
						{
							if ( currentWorld.collidePoint("wall", x, l) )
							{
								blockedByWallX = x;
								blockedByWallY = l;
								
								l = FP.height;
							}
						}
						canSeePlayer = playerX == x && playerY > y && blockedByWallY > playerY;
						break;
					default:
						canSeePlayer = false;
						blockedByWallX = x;
						blockedByWallY = y;
						break;
				}
				
				if ( canSeePlayer )
				{
					playerLastSeenAtX = playerX;
					playerLastSeenAtY = playerY;
				}
						
				sawPlayer = sawPlayer || canSeePlayer;
				currentWorld.showDeath = canSeePlayer && killsWithSight;
			}
			
			Draw.setTarget( monsterSight );
			Draw.line( x, y, int( blockedByWallX ), int( blockedByWallY ) );
			monsterSightImage.updateBuffer();
		}
		
		// Sets the direction of the monster so it can see the player
		// if possible
		public function getSeeableDirection():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			var blockedByWallX:Number;
			var blockedByWallY:Number;
			
			if ( currentWorld )
			{
				var playerX:Number = currentWorld.player.x;
				var playerY:Number = currentWorld.player.y;
					
				for ( var d:int = 0; d < 4; d++ )
				{
					switch( direction )
					{
						case "left":
							for ( var i:int = x; i >= 0; i -= Main.TW )
							{
								if ( currentWorld.collidePoint("wall", i, y) )
								{
									blockedByWallX = i;
									blockedByWallY = y;
									
									i = -1;
								}
							}	
							canSeePlayer = playerX < x && playerY == y && blockedByWallX < playerX;
							break;
						case "right":
							for ( var j:int = x; j < FP.width; j += Main.TW )
							{
								if ( currentWorld.collidePoint("wall", j, y) )
								{
									blockedByWallX = j;
									blockedByWallY = y;
									
									j = FP.width;
								}
							}
							canSeePlayer = playerX > x && playerY == y && blockedByWallX > playerX;
							break;
						case "up":
							for ( var k:int = y; k >=0; k -= Main.TW )
							{
								if ( currentWorld.collidePoint("wall", x, k) )
								{
									blockedByWallX = x;
									blockedByWallY = k;
									
									k = -1;
								}
							}
							canSeePlayer = playerX == x && playerY < y && blockedByWallY < playerY;
							break;
						case "down":
							for ( var l:int = y; l < FP.height; l += Main.TW )
							{
								if ( currentWorld.collidePoint("wall", x, l) )
								{
									blockedByWallX = x;
									blockedByWallY = l;
									
									l = FP.height;
								}
							}
							canSeePlayer = playerX == x && playerY > y && blockedByWallY > playerY;
							break;
						default:
							canSeePlayer = false;
							blockedByWallX = x;
							blockedByWallY = y;
							break;
					}
					
					if ( canSeePlayer )
					{
						return;
					}
					
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
				}
			}
			
			direction = "stop";
		}
	}

}