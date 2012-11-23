package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class Main extends Engine
	{
		public function Main()
		{
			super(800, 600, 60, false);
			
			FP.world = new GameWorld();
		}
	}
}