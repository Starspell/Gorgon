package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	/**
	 * ...
	 * @author Sarah
	 */
	public class SmellingMonster extends Monster
	{
		[Embed(source = '../assets/sprites/smellingmonster.png')] private const SMELLING:Class;
		
		[Embed(source = '../assets/audio/smellgrowl.mp3')] private const GROWL:Class;
		
		private const smellingTween:Number = 20;
		
		private var hasSmell:Boolean = false;
		private var growlSound:Sfx = new Sfx(GROWL);
		
		public function SmellingMonster( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			monsterImage = new Image(SMELLING);
			monsterImage.centerOO();
			graphic = monsterImage;
			
			isStatic = true;
		}
		
		override public function update():void
		{
			// We move towards the greatest scent
			
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			if ( currentWorld )
			{
				var currentGreatestSmell:Number 	= 0;
				var greatestSmellDir:String 		= "stop";
				
				var scentLeft:Number 	= currentWorld.scent.getPixel( (x - Main.TW) / Main.TW, y / Main.TW );
				var scentRight:Number 	= currentWorld.scent.getPixel( (x + Main.TW) / Main.TW, y / Main.TW );
				var scentUp:Number 		= currentWorld.scent.getPixel( x / Main.TW, (y - Main.TW) / Main.TW );
				var scentDown:Number	= currentWorld.scent.getPixel( x / Main.TW, (y + Main.TW) / Main.TW );
				
				if ( scentLeft > currentGreatestSmell )
				{
					currentGreatestSmell = scentLeft;
					greatestSmellDir = "left";
				}
				
				if ( scentRight > currentGreatestSmell )
				{
					currentGreatestSmell = scentRight;
					greatestSmellDir = "right";
				}
				
				if ( scentUp > currentGreatestSmell )
				{
					currentGreatestSmell = scentUp;
					greatestSmellDir = "up";
				}
				
				if ( scentDown > currentGreatestSmell )
				{
					currentGreatestSmell = scentDown;
					greatestSmellDir = "down";
				}
				
				if ( greatestSmellDir == "stop" )
				{
					// Move randomly
					super.update();
				}
				else
				{
					if ( !hasSmell )
					{
						if ( !Main.mute )
						{
							growlSound.play();
						}
						hasSmell = true;
					}
					direction = greatestSmellDir;
					moveWithDirection( smellingTween );
				}
			}
		}
	}

}