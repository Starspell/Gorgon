package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	/**
	 * ...
	 * @author Sarah
	 */
	public class ChargingMonster extends MonsterWithSight 
	{
		[Embed(source = '../assets/sprites/smasher.png')] private const CHARGING:Class;
		
		[Embed(source = '../assets/audio/roar.mp3')] private const ROAR:Class;
		[Embed(source = '../assets/audio/wallimpact.mp3')] private const IMPACT:Class;
		
		private const chargingTweenTime:Number = 6;
		private const pauseTime:Number = 0.25;		
		
		private var shouldPause:Boolean = true;
		private var pauseTimer:Number = 0;
		
		private var roarSound:Sfx = new Sfx(ROAR);
		private var impactSound:Sfx = new Sfx(IMPACT);
		
		public function ChargingMonster( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			var sprite:Spritemap = new Spritemap(CHARGING, 16, 16);
			
			var dirs:Array = ["down", "up", "left", "right"];
			
			for (var i:int = 0; i < dirs.length; i++) {
				sprite.add(dirs[i],  [i*2 + 0], 0.1);
				sprite.add("move" + dirs[i],  [i*2 + 1], 0.1);
			}
			
			monsterImage = sprite;
			
			monsterImage.centerOO();
			graphic = monsterImage;
			addGraphic(monsterSightImage);
			
			isStatic = true;
			
			direction = "up";
			
			sprite.play(direction);
		}
		
		override public function update():void
		{
			if ( !canSeePlayer && !sawPlayer )
			{
				super.update();
				Spritemap(monsterImage).play(direction);
			}
			else
			{
				// Pause before charging
				if ( shouldPause )
				{
					if ( !Main.mute )
					{
						roarSound.play();
					}
					
					pauseTimer += FP.elapsed;
					if ( pauseTimer > pauseTime )
					{
						shouldPause = false;
					}
				}
				else
				{
					updateSight();
					moveWithDirection( chargingTweenTime );
					Spritemap(monsterImage).play("move" + direction);
				}
			}
		}
		
		override protected function hitWall():void
		{
			sawPlayer = false;
			shouldPause = true;
			pauseTimer = 0;
			
			if ( !Main.mute )
			{
				impactSound.play();
				impactSound.volume = 0.5;
			}
			
			Main.startScreenShake();
		}
		
		override protected function hitMirror():void
		{
			// Would end up breaking the mirror but for now doesn't do anything special
			
			hitWall();
		}
		
		override protected function hitGlassblock( glassBlock:GlassBlock ):void
		{
			glassBlock.breakBlock();
		}
	}

}