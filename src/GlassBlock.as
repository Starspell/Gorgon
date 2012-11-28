package  
{
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Sarah
	 */
	public class GlassBlock extends Block 
	{
		[Embed(source = '../assets/sprites/glassblock.png')] private const GLASS:Class;
		
		public var broken:Boolean = false;
		
		public function GlassBlock( startX:int, startY:int ) 
		{
			super( startX, startY );
			
			graphic = new Image( GLASS );
			
			type = "glassblock";
			setHitbox(Main.TW, Main.TW);
		}
		
		override public function breakBlock():void
		{
			broken = true;
		}
		
	}

}