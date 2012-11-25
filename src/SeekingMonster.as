package  
{
	import net.flashpunk.utils.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class SeekingMonster extends MonsterWithSight 
	{
		[Embed(source = '../assets/sprites/eyeball.png')] private const Gfx:Class;
		
		private const seekingTweenTime:Number = 15;
		
		private var checkAllDirections:Boolean = false;
		
		public function SeekingMonster( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			var sprite:Spritemap = new Spritemap(Gfx, 16, 16);
			
			sprite.add("down",  [0,1], 0.1);
			sprite.add("up",    [2,3], 0.1);
			sprite.add("left",  [4,5], 0.1);
			sprite.add("right", [6,7], 0.1);
			
			monsterImage = sprite;
			monsterImage.centerOO();
			graphic = monsterImage;
			addGraphic(monsterSightImage);
			
			isStatic = true;
			
			direction = "up";
			
			sprite.play(direction);
			
			playerLastSeenAtX = startX / Main.TW;
			playerLastSeenAtY = startY / Main.TW;
		}
		
		override public function update():void
		{
			if ( int(x / Main.TW) == playerLastSeenAtX && int(y / Main.TW) == playerLastSeenAtY )
			{
				if ( checkAllDirections )
				{
					checkAllDirections = false;
					
					setDirectionToSeeablePlayer();
					
					if ( direction == "stop" )
					{
						direction = "up";
						sawPlayer = false;
						GameWorld.squelchSound.stop();
					}
				}
				
				super.update();
			}
			else
			{
				if( !GameWorld.squelchSound.playing )
				{
					GameWorld.squelchSound.loop();
				}
				
				updateSight();
				moveWithDirection( seekingTweenTime );
			}
			
			if ( canSeePlayer )
			{
				checkAllDirections = true;
			}
			
			if (direction != "stop") {
				Spritemap(monsterImage).play(direction);
			}
		}
	}

}