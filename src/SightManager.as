package  
{
	import net.flashpunk.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class SightManager 
	{
		
		public function SightManager() 
		{
			
		}
		
		public static function getPointsOfSight( positionX:int, positionY:int, direction:String ):Array
		{
			var blockingPoints:Array = new Array();
			
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			var pointsIndex:int = 0;
			
			if ( currentWorld )
			{				
				switch( direction )
				{
					case "left":
						for ( var i:int = positionX; i >= 0; i -= Main.TW )
						{
							if ( currentWorld.collidePoint( "wall", i, positionY )
								|| currentWorld.collidePoint( "monster", i, positionY )
								|| currentWorld.collidePoint( "player", i, positionY )
								|| currentWorld.collidePoint( "gorgon", i, positionY ) )
							{
								blockingPoints[pointsIndex] = i;
								blockingPoints[++pointsIndex] = positionY;
								
								pointsIndex++;
							}
						}	
						break;
					case "right":
						for ( var j:int = positionX; j < FP.width; j += Main.TW )
						{
							if ( currentWorld.collidePoint( "wall", j, positionY )
								|| currentWorld.collidePoint( "monster", j, positionY )
								|| currentWorld.collidePoint( "player", j, positionY )
								|| currentWorld.collidePoint( "gorgon", j, positionY )  )
							{
								blockingPoints[pointsIndex] = j;
								blockingPoints[++pointsIndex] = positionY;
								
								pointsIndex++;
							}
						}
						break;
					case "up":
						for ( var k:int = positionY; k >=0; k -= Main.TW )
						{
							if ( currentWorld.collidePoint( "wall", positionX, k )
								|| currentWorld.collidePoint( "monster", positionX, k )
								|| currentWorld.collidePoint( "player", positionX, k )
								|| currentWorld.collidePoint( "gorgon", positionX, k ) )
							{
								blockingPoints[pointsIndex] = positionX;
								blockingPoints[++pointsIndex] = k;
								
								pointsIndex++;
							}
						}
						break;
					case "down":
						for ( var l:int = positionY; l < FP.height; l += Main.TW )
						{
							if ( currentWorld.collidePoint( "wall", positionX, l )
								|| currentWorld.collidePoint( "monster", positionX, l )
								|| currentWorld.collidePoint( "player", positionX, l ) 
								|| currentWorld.collidePoint( "gorgon", positionX, l ) )
							{
								blockingPoints[pointsIndex] = positionX;
								blockingPoints[++pointsIndex] = l;
								
								pointsIndex++;
							}
						}
						break;
				}
			}
			
			return blockingPoints;
		}
		
	}

}