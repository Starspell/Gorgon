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
		[Embed(source = '../assets/sprites/seekingmonster.png')] private const SEEKING:Class;
		
		private const seekingTweenTime:Number = 15;
		
		private var checkAllDirections:Boolean = false;
		
		public function SeekingMonster( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			monsterImage = new Image(SEEKING);
			monsterImage.centerOO();
			graphic = monsterImage;
			addGraphic(monsterSightImage);
			
			isStatic = true;
			
			direction = "up";
			
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
		}
	}

}