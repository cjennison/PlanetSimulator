package com.jennison 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class Planet extends MovieClip 
	{
		
		public function Planet() 
		{
			addEventListener(Event.ENTER_FRAME, rotatePlanet);
		}
		
		private function rotatePlanet(e:Event):void 
		{
			this.rotation += .1;
		}
		
	}

}