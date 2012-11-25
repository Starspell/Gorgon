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
			
			var mirror:Mirror;
			
			if ( currentWorld )
			{				
				switch( direction )
				{
					case "left":
						for ( var i:int = positionX; i >= 0; i -= Main.TW )
						{
							mirror = currentWorld.collidePoint( "mirror", i, positionY ) as Mirror;
							
							if ( i == positionX )
							{
								// Ignore this square
							}
							else if ( currentWorld.collidePoint( "wall", i, positionY )
								|| currentWorld.collidePoint( "monster", i, positionY )
								|| currentWorld.collidePoint( "player", i, positionY )
								|| currentWorld.collidePoint( "gorgon", i, positionY ) )
							{
								blockingPoints[pointsIndex] = i;
								blockingPoints[++pointsIndex] = positionY;
								
								pointsIndex++;
								
								i = -1;
							}
							else if ( mirror && i != positionX )
							{
								blockingPoints[pointsIndex] = i;
								blockingPoints[++pointsIndex] = positionY;
								
								blockingPoints = blockingPoints.concat( getPointsOfSight( i, positionY, mirror.getBounceDir( "left" ) ) );
								pointsIndex = blockingPoints.length;
								
								i = -1;
							}
						}	
						break;
					case "right":
						for ( var j:int = positionX; j < FP.width; j += Main.TW )
						{
							mirror = currentWorld.collidePoint( "mirror", j, positionY ) as Mirror;
							
							if ( j == positionX )
							{
								// Ignore this square
							}
							else if ( currentWorld.collidePoint( "wall", j, positionY )
								|| currentWorld.collidePoint( "monster", j, positionY )
								|| currentWorld.collidePoint( "player", j, positionY )
								|| currentWorld.collidePoint( "gorgon", j, positionY )  )
							{
								blockingPoints[pointsIndex] = j;
								blockingPoints[++pointsIndex] = positionY;
								
								pointsIndex++;
								
								j = FP.width;
							}
							else if ( mirror && j != positionX )
							{
								blockingPoints[pointsIndex] = j;
								blockingPoints[++pointsIndex] = positionY;
								
								blockingPoints = blockingPoints.concat( getPointsOfSight( j, positionY, mirror.getBounceDir( "right" ) ) );
								pointsIndex = blockingPoints.length;
								
								j = FP.width;
							}
						}
						break;
					case "up":
						for ( var k:int = positionY; k >=0; k -= Main.TW )
						{
							mirror = currentWorld.collidePoint( "mirror", positionX, k ) as Mirror;
							
							if ( k == positionY )
							{
								// Ignore this square
							}
							else if ( currentWorld.collidePoint( "wall", positionX, k )
								|| currentWorld.collidePoint( "monster", positionX, k )
								|| currentWorld.collidePoint( "player", positionX, k )
								|| currentWorld.collidePoint( "gorgon", positionX, k ) )
							{
								blockingPoints[pointsIndex] = positionX;
								blockingPoints[++pointsIndex] = k;
								
								pointsIndex++;
								
								k = -1;
							}
							else if ( mirror && k != positionY )
							{
								blockingPoints[pointsIndex] = positionX;
								blockingPoints[++pointsIndex] = k;
								
								blockingPoints = blockingPoints.concat( getPointsOfSight( positionX, k, mirror.getBounceDir( "up" ) ) );
								pointsIndex = blockingPoints.length;
								
								k = -1;
							}
						}
						break;
					case "down":
						for ( var l:int = positionY; l < FP.height; l += Main.TW )
						{
							mirror = currentWorld.collidePoint( "mirror", positionX, l ) as Mirror;
							
							if ( l == positionY )
							{
								// Ignore this square
							}
							else if ( currentWorld.collidePoint( "wall", positionX, l )
								|| currentWorld.collidePoint( "monster", positionX, l )
								|| currentWorld.collidePoint( "player", positionX, l ) 
								|| currentWorld.collidePoint( "gorgon", positionX, l ) )
							{
								blockingPoints[pointsIndex] = positionX;
								blockingPoints[++pointsIndex] = l;
								
								pointsIndex++;
								
								l = FP.height;
							}
							else if ( mirror && l != positionY )
							{
								blockingPoints[pointsIndex] = positionX;
								blockingPoints[++pointsIndex] = l;
								
								blockingPoints = blockingPoints.concat( getPointsOfSight( positionX, l, mirror.getBounceDir( "down" ) ) );
								pointsIndex = blockingPoints.length;
								
								l = FP.height;
							}
						}
						break;
				}
			}
			
			return blockingPoints;
		}
		
	}

}