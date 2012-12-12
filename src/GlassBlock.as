package  
{
	import net.flashpunk.graphics.*;
	/**
	 * ...
	 * @author Sarah
	 */
	public class GlassBlock extends Block 
	{
		[Embed(source = '../assets/sprites/glassblock.png')] private const GLASS:Class;
		
		public var glassBlockSpr:Spritemap = new Spritemap(GLASS, 16, 16);
		public var broken:Boolean = false;
		
		public function GlassBlock( startX:int, startY:int ) 
		{
			super( startX, startY );
			
			glassBlockSpr.add("unbroken", [0], 1, false);
			glassBlockSpr.add("broken", [1], 1, false);
			
			graphic = glassBlockSpr;
			
			glassBlockSpr.play("unbroken");
			
			type = "glassblock";
			setHitbox(Main.TW, Main.TW);
		}
		
		override public function breakBlock():void
		{
			broken = true;
			glassBlockSpr.play("broken");
		}
		
	}

}