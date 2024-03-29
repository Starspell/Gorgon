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
		[Embed(source="../assets/sprites/static-tiles.png")]
		public static const StaticTilesGfx: Class;
		
		[Embed(source="../assets/sprites/deathscreen.png")] private static const DEATHSCREEN:Class;
		
		[Embed(source = '../assets/audio/squelch2.mp3')] private static const SQUELCH:Class;
		[Embed(source = '../assets/fonts/amiga4ever pro2.ttf', embedAsCFF = "false", fontFamily = 'My Font')] 
		private const MY_FONT:Class;
		
		public static var squelchSound:Sfx = new Sfx(SQUELCH);
		
		public var playerStartX:Number;
		public var playerStartY:Number;
		
		private var deathScreenEntity:Entity;
		private var deathText:Text;
		private var deathTextEntity:Entity;
		
		public var player:Player;
		public var startAtEnd:Boolean;
		public var spawnBabyOnStairs:Boolean;
		public var showDeath:Boolean = false;
		
		public var monsters:Array = [];
		public var gorgonBabyRef:GorgonBaby;
		
		public var scent:BitmapData;
		public var scent2:BitmapData;
		public var scentDebug:Image;
		
		/*public var playerSight:BitmapData;
		public var playerSightImage:Image;*/
		
		public var id:int;
		public var levelData:LevelData;
		
		public function GameWorld( _id:int, _levelData:LevelData = null, startAtEnd:Boolean = false, spawnBabyOnStairs:Boolean = false ) 
		{
			Text.font = "My Font";
			
			this.id = _id;
			this.levelData = _levelData;
			
			this.startAtEnd = startAtEnd;
			this.spawnBabyOnStairs = spawnBabyOnStairs;
			
			if (! levelData) {
				if (id <= 0) {
					id = LevelList.levels.length - 1;
				}
				
				if ( id >= LevelList.levels.length )
				{
					id = 1;
				}
				
				levelData = LevelList.levels[id];
			}
			var tiles:Tilemap = levelData.tiles;
			
			var foundTile:uint;
			
			var wallMask:Grid = new Grid(FP.width, FP.height, Main.TW, Main.TW);
			var staticTiles:Tilemap = new Tilemap(StaticTilesGfx, FP.width, FP.height, Main.TW, Main.TW);
			
			var wall:Entity = new Entity(0, 0, staticTiles, wallMask);
			wall.type = "wall";
			wall.layer = 100;
			
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
							break;
						case 2: 
							if ( !startAtEnd )
							{
								playerStartX = ix * Main.TW; playerStartY = iy * Main.TW; 
							}
							e = new StairsUp( ix * Main.TW, iy * Main.TW );
							break;
						case 3: 
							e = new Monster( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 );
							break;
						case 4: 
							if ( startAtEnd )
							{
								playerStartX = ix * Main.TW; playerStartY = iy * Main.TW; 
							}
							e = new StairsDown( ix * Main.TW, iy * Main.TW ); 
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
						case 8:
							e = new SeekingMonster( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 );
							break;
						case 9:
							e = new Spikes( ix * Main.TW, iy * Main.TW );
							break;
						case 10:
							var mirrorDir:int = 0;
							if (tiles.getTile(ix-1,iy) != 1) {
								mirrorDir += 1;
							}
							if (tiles.getTile(ix,iy-1) != 1) {
								mirrorDir += 2;
							}
							e = new Mirror(ix, iy, mirrorDir);
							break;
						case 11:
							e = new Gorgon( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 );
							break;
						case 12:
							e = new Block( ix * Main.TW, iy * Main.TW );
							break;
						case 13:
							e = new GlassBlock( ix * Main.TW, iy * Main.TW );
							break;
						case 14:
							if ( !spawnBabyOnStairs )
							{
								e = new GorgonBaby( ix * Main.TW + Main.TW / 2, iy * Main.TW + Main.TW / 2 );
								gorgonBabyRef = e as GorgonBaby;
							}
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
			
			AutoTile.chooseTiles(staticTiles, levelData.tiles);
			
			add(wall);
			
			updateLists();
			
			// Need to put the player in a nice spot
			if ( getTypeAt( playerStartX, playerStartY - Main.TW ) != "wall" )
			{
				player = new Player( playerStartX + Main.TW / 2, playerStartY - Main.TW + Main.TW / 2 );
			}
			else if ( getTypeAt( playerStartX + Main.TW , playerStartY ) != "wall" )
			{
				player = new Player( playerStartX + Main.TW + Main.TW / 2, playerStartY + Main.TW / 2 );
			}
			else if ( getTypeAt( playerStartX , playerStartY + Main.TW ) != "wall" )
			{
				player = new Player( playerStartX + Main.TW / 2, playerStartY + Main.TW + Main.TW / 2 );
			}
			else if ( getTypeAt( playerStartX - Main.TW , playerStartY ) != "wall" )
			{
				player = new Player( playerStartX - Main.TW + Main.TW / 2, playerStartY + Main.TW / 2 );
			}
			else
			{
				trace( "Unable to place player" );
			}
			
			if ( spawnBabyOnStairs )
			{
				gorgonBabyRef = new GorgonBaby( playerStartX + Main.TW / 2, playerStartY + Main.TW / 2 );
				monsters.push(gorgonBabyRef);
				add(gorgonBabyRef);
			}
			
			add(player);
			
			scent = new BitmapData(tiles.columns, tiles.rows, false, 0x0);
			scent2 = new BitmapData(tiles.columns, tiles.rows, false, 0x0);
			
			scentDebug = new Image(scent);
			scentDebug.scale = Main.TW;
			scentDebug.alpha = 0.5;
			scentDebug.visible = false;
			addGraphic(scentDebug);
			
			deathScreenEntity = new Entity(0, 0, new Image(DEATHSCREEN) );
			deathScreenEntity.visible = false;
			add( deathScreenEntity );

			deathText = new Text("You are dead\nPress 'R' to Restart\n\n\nLook away...");
			deathTextEntity = new Entity(75, 70, deathText);
			deathTextEntity.visible = false;
			add( deathTextEntity );
			
			/*playerSightImage = new Image( playerSight );
			playerSightImage.scale = Main.TW;*/
		}
		
		override public function update():void
		{
			super.update();
			
			updateScent();
			//updatePlayerSight();
			
			if ( Input.pressed( Key.F3 ) )
			{
				Main.honourMode = !Main.honourMode;
			}
			
			if ( Main.devMode)
			{
				if ( Input.pressed( Key.E ) )
				{
					if (! Input.check(Key.SHIFT)) {
						Editor.data.fromString(levelData.toString());
					
						Editor.changed();
					}
					
					FP.world = new Editor();
				}
			
				if ( Input.pressed( Key.F2 ) )
				{
					scentDebug.visible = ! scentDebug.visible;
				}
			
				if ( Input.pressed( Key.PAGE_DOWN ) )
				{
					FP.world = new GameWorld(id+1);
					return;
				}
			
				if ( Input.pressed( Key.PAGE_UP ) )
				{
					FP.world = new GameWorld(id-1);
					return;
				}
			}
			
			deathTextEntity.visible = deathScreenEntity.visible = showDeath;
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
		
		public function getTypeAt( posX:int, posY:int ):String
		{			
			if ( collidePoint( "wall"	, posX, posY ) ) return "wall";
			
			if ( collidePoint( "monster", posX, posY ) ) return "monster";
			
			if ( collidePoint( "player"	, posX, posY ) ) return "player";
			
			if ( collidePoint( "gorgon"	, posX, posY ) ) return "gorgon";
			
			if ( collidePoint( "mirror"	, posX, posY ) ) return "mirror";
			
			return null;
		}
		
		override public function end():void
		{
			squelchSound.stop();
		}
		
		override public function render():void
		{
			if ( player.blind )
			{
				FP.buffer.fillRect( FP.bounds, 0xFF000000 );
				player.render();
			}
			else
			{
				super.render();
				//renderReflections();
			}
		}
		
		public function renderReflections():void
		{
			var dirs:Array = ["left", "right", "up", "down"];
			
			for each (var dir:String in dirs) {
				var entities:Array = SightManager.getPointsOfSight(player.x, player.y, dir);
				
				var first:Entity = entities[0];
				
				if (first.type != "mirror") continue;
				
				var last:Entity = entities[entities.length - 1];
				
				if (last.type == "mirror" || last.type == "wall") continue;
				
				var _x:Number = last.x;
				var _y:Number = last.y;
				
				last.x = first.x;
				last.y = first.y;
				
				last.render();
				
				last.x = _x;
				last.y = _y;
			}
		}
	}

}