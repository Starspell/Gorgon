package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
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
		
		public var monsters:Array = [];
		
		public var scent:BitmapData;
		public var scent2:BitmapData;
		public var scentDebug:Image;
		
		public function GameWorld( levelData:LevelData ) 
		{
			var tiles:Tilemap = levelData.tiles;
			
			var foundTile:uint;
			
			for ( var r:int = 0; r < tiles.rows; r++ )
			{
				for ( var c:int = 0; c < tiles.columns; c++ )
				{
					foundTile = tiles.getTile(c,r);
					
					var e:Entity = null;
					
					switch(foundTile)
					{
						case 0: break;
						case 1: 
							e = new Wall( c * Main.TW, r * Main.TW );
							break;
						case 2: 
							playerStartX = c * Main.TW; playerStartY = r * Main.TW; 
							break;
						case 3: 
							e = new Monster( c * Main.TW + Main.TW / 2, r * Main.TW + Main.TW / 2 );
							break;
						case 4: 
							e = new Goal( c * Main.TW, r * Main.TW ); 
							break;
						case 5:
							e = new MonsterWithSight( c * Main.TW + Main.TW / 2, r * Main.TW + Main.TW / 2 ); 
							break;
						default: trace( "Unknown Tile Type: " + foundTile + " at " + c + " " + r );
					}
					
					if (e) {
						add(e)
						
						if (e is Monster) {
							monsters.push(e);
						}
					}
				}
			}
			
			player = new Player( playerStartX + Main.TW / 2, playerStartY + Main.TW / 2 );
			
			add(player);
			
			scent = new BitmapData(tiles.columns, tiles.rows, false, 0x0);
			scent2 = new BitmapData(tiles.columns, tiles.rows, false, 0x0);
			
			scentDebug = new Image(scent);
			scentDebug.scale = Main.TW;
			scentDebug.alpha = 0.5;
			//addGraphic(scentDebug);

			deathText = new Text("If you see this you are DEAD");
			deathTextEntity = new Entity(0, 120, deathText);
			add( deathTextEntity );
		}
		
		override public function update():void
		{
			super.update();
			
			updateScent();
			
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
		
		public function updateScent ():void
		{
			scent.setPixel(player.centerX/Main.TW, player.centerY/Main.TW, 255);
			
			var e:Entity;
			
			for each (e in monsters) {
				scent.setPixel(e.centerX/Main.TW, e.centerY/Main.TW, 0);
			}
			
			scent2.copyPixels(scent, scent.rect, FP.zero);
			
			var i:int;
			var j:int;
			
			for (i = 0; i < scent.width; i++) {
				for (j = 0; j < scent.height; j++) {
					var strength:uint = Math.max(
						scent2.getPixel(i-1,j), scent2.getPixel(i+1,j),
						scent2.getPixel(i,j-1), scent2.getPixel(i,j+1)
					);
					
					if (collidePoint("wall", i*Main.TW, j*Main.TW)) {
						strength = 0;
					}
					
					var decay:int = 8;
					
					if (strength >= decay) strength -= decay;
					
					scent.setPixel(i, j, strength);
				}
			}
			
			scent.setPixel(player.centerX/Main.TW, player.centerY/Main.TW, 255);
			
			for each (e in monsters) {
				scent.setPixel(e.centerX/Main.TW, e.centerY/Main.TW, 0);
			}
			
			scentDebug.updateBuffer();
		}
	}

}