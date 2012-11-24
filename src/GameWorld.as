package  
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class GameWorld extends World 
	{
		private var playerStartX:Number;
		private var playerStartY:Number;
		
		private var deathText:Text;
		private var deathTextEntity:Entity;
		
		public var player:Player;
		public var showDeath:Boolean = false;
		
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
						case 5:
							add( new MonsterWithSight( c * Main.TW + Main.TW / 2, r * Main.TW + Main.TW / 2 ) ); 
							break;
						case 6:
							add( new ChargingMonster( c * Main.TW + Main.TW / 2, r * Main.TW + Main.TW / 2 ) ); 
							break;
						default: trace( "Unknown Tile Type: " + foundTile + " at " + c + " " + r );
					}
				}
			}
			
			player = new Player( playerStartX + Main.TW / 2, playerStartY + Main.TW / 2 );
			
			add(player);
			
			deathText = new Text("If you see this you are DEAD");
			deathTextEntity = new Entity(0, 120, deathText);
			add( deathTextEntity );
		}
		
		override public function update():void
		{
			super.update();
			
			if ( Input.pressed( Key.E ) )
			{
				FP.world = new Editor();
			}
			
			if ( showDeath )
			{
				Image(deathTextEntity.graphic).alpha = 1.0;
			}
			else
			{
				Image(deathTextEntity.graphic).alpha = 0.0;
			}
		}
	}

}