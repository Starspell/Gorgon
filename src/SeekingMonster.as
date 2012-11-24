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
			
			playerLastSeenAtX = x;
			playerLastSeenAtY = y;
		}
		
		override public function update():void
		{
			if ( x == playerLastSeenAtX && y == playerLastSeenAtY )
			{
				if ( checkAllDirections )
				{
					checkAllDirections = false;
					getSeeableDirection();
					
					if ( direction == "stop" )
					{
						direction = "up";
					}
				}
				
				super.update();
			}
			else
			{
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