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
		
		protected var monsterSight:BitmapData;
		protected var monsterSightImage:Image;
		
		protected var playerLastSeenAtX:int;
		protected var playerLastSeenAtY:int;
		
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
			/*
			var lineEndPointX:Number;
			var lineEndPointY:Number;*/
			
			canSeePlayer = false;
			
			monsterSight.fillRect( monsterSight.rect, 0 );
			
			if ( currentWorld )
			{
				var directionToUse:String = direction == "stop" ? previousDir : direction;
				
				var entities:Array = SightManager.getPointsOfSight( x, y, directionToUse );
				
				var last:Entity = entities[entities.length - 1];
				
				if (last && last.type == "player") {
					canSeePlayer = true;
					
					var first:Entity = entities[0];
					
					playerLastSeenAtX = int( first.x / Main.TW );
					playerLastSeenAtY = int( first.y / Main.TW );
				}
				
				sawPlayer = sawPlayer || canSeePlayer;
			}
			
			/*Draw.setTarget( monsterSight );
			Draw.line( x, y, int( lineEndPointX ), int( lineEndPointY ) );
			monsterSightImage.updateBuffer();*/
		}
	
		public function setDirectionToSeeablePlayer():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			canSeePlayer = false;
			
			if ( currentWorld )
			{
				var blockingPoints:Array;
					
				for ( var d:int = 0; d < 4; d++ )
				{
					var entities:Array = SightManager.getPointsOfSight( x, y, direction );
					
					var last:Entity = entities[entities.length - 1];
					
					if (last.type == "player") {
						canSeePlayer = true;
						
						playerLastSeenAtX = last.x;
						playerLastSeenAtY = last.y;
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
		}
	}

}