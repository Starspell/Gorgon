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
		
		public static function getPointsOfSight( x:Number, y:Number, direction:String ):Array
		{
			var entities:Array = new Array();
			
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			if (! currentWorld) return entities;
			
			var dx:int = 0;
			var dy:int = 0;
			
			switch( direction )
			{
				case "left":
					dx = -1;
				break;
				case "right":
					dx = 1;
				break;
				case "up":
					dy = -1;
				break;
				case "down":
					dy = 1;
				break;
				default:
					return entities;
			}
			
			while (true) {
				x += dx * Main.TW;
				y += dy * Main.TW;
				
				var e:Entity = currentWorld.collidePoint( "wall", x, y );
				if (! e) e = currentWorld.collidePoint( "monster", x, y );
				if (! e) e = currentWorld.collidePoint( "player", x, y );
				if (! e) e = currentWorld.collidePoint( "gorgon", x, y );
				
				if ( e )
				{
					entities.push(e);
					
					break;
				}
				
				var mirror:Mirror = currentWorld.collidePoint( "mirror", x, y ) as Mirror;
				
				if ( mirror )
				{
					entities.push(mirror);
					
					entities = entities.concat( getPointsOfSight( x, y, mirror.getBounceDir( direction ) ) );
					
					break;
				}
			}
			
			return entities;
		}
		
	}

}