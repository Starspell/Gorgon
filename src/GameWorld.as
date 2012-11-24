package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
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
		
		public var id:int;
		
		public function GameWorld( id:int, levelData:LevelData = null ) 
		{
			this.id = id;
			
			if (! levelData) {
				if ( id >= LevelList.levels.length )
				{
					id = 1;
				}
				
				levelData = LevelList.levels[id];
			}
			var tiles:Tilemap = levelData.tiles;
			
			var foundTile:uint;
			
			var wallMask:Grid = new Grid(FP.width, FP.height, Main.TW, Main.TW);
			var wallTiles:Tilemap = new Tilemap(Editor.EditTilesGfx, FP.width, FP.height, Main.TW, Main.TW);
			
			var wall:Entity = new Entity(0, 0, wallTiles, wallMask);
			wall.type = "wall";
			
			for ( var iy:int = 0; iy < tiles.rows; iy++ )
			{
				for ( var ix:int = 0; ix < tiles.columns; ix++ )
				{
					foundTile = tiles.getTile(ix,iy);
					
					var e:Entity = null;
					
					switch(foundTile)
					{
						case 0: break;
						case 1: 
							wallMask.setTile(ix, iy, true);
							wallTiles.setTile(ix, iy, foundTile);
							break;
						case 2: 
							playerStartX = ix * Main.TW; playerStartY = iy * Main.TW; 
							break;
						case 3: 
							e = new Monster( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 );
							break;
						case 4: 
							e = new Goal( ix * Main.TW, iy * Main.TW ); 
							break;
						case 5:
							e = new MonsterWithSight( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 ); 
							break;
						case 6:
							e = new ChargingMonster( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 ); 
							break;
						case 7:
							e = new SmellingMonster( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 );
							break;
						default: trace( "Unknown Tile Type: " + foundTile + " at " + ix + " " + iy );
					}
					
					if (e) {
						add(e)
						
						if (e is Monster) {
							monsters.push(e);
						}
					}
				}
			}
			
			add(wall);
			
			player = new Player( playerStartX + Main.TW / 2, playerStartY + Main.TW / 2 );
			
			add(player);
			
			scent = new BitmapData(tiles.columns, tiles.rows, false, 0x0);
			scent2 = new BitmapData(tiles.columns, tiles.rows, false, 0x0);
			
			scentDebug = new Image(scent);
			scentDebug.scale = Main.TW;
			scentDebug.alpha = 0.5;
			scentDebug.visible = false;
			addGraphic(scentDebug);

			deathText = new Text("If you see this you are DEAD");
			deathTextEntity = new Entity(0, 120, deathText);
			deathTextEntity.visible = false;
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
			
			if ( Main.devMode && Input.pressed( Key.F2 ) )
			{
				scentDebug.visible = ! scentDebug.visible;
			}
			
			deathTextEntity.visible = showDeath;
		}
		
		public function updateScent ():void
		{
			if ( !player.hasMoved )
			{
				scent.fillRect( scent.rect, 0 );
				return;
			}
			
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
			
			if (scentDebug.visible) {
				scentDebug.updateBuffer();
			}
		}
	}

}