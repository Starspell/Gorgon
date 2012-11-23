package  
{
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class GameWorld extends World 
	{
		public var player:Player;
		
		public function GameWorld() 
		{
			player = new Player();
			
			add(player);
		}
		
	}

}