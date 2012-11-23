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
					case 1: add( new Wall( c*Main.TW, r*Main.TW ) );
					}
				}
			}
			
			player = new Player();
			
			add(player);
			add(new Monster());
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