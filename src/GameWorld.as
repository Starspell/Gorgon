package  
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class GameWorld extends World 
	{
		private var playerStartX:Number;
		private var playerStartY:Number;
		
		public var player:Player;
		
		public function GameWorld( levelData:LevelData ) 
		{
			var foundTile:uint;
			
			for ( var r:int = 0; r < levelData.tiles.rows; r++ )
			{
				for ( var c:int = 0; c < levelData.tiles.columns; c++ )
				{
					foundTile = levelData.tiles.getTile(c,r);
					
					switch(foundTile)
					{
						case 0: break;
						case 1: 
							add( new Wall( c * Main.TW, r * Main.TW ) );
							break;
						case 2: 
							playerStartX = c * Main.TW; playerStartY = r * Main.TW; 
							break;
						case 3: 
							add( new Monster( c * Main.TW + Main.TW / 2, r * Main.TW + Main.TW / 2 ) ); 
							break;
						case 4: 
							add( new Goal( c * Main.TW, r * Main.TW ) ); 
							break;
						default: trace( "Unknown Tile Type: " + foundTile + " at " + c + " " + r );
					}
				}
			}
			
			player = new Player( playerStartX + Main.TW / 2, playerStartY + Main.TW / 2 );
			
			add(player);
		}
		
		override public function update():void
		{
			super.update();
			
			if ( Input.pressed( Key.E ) )
			{
				FP.world = new Editor();
			}
		}
	}

}