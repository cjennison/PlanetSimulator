package com.jennison 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class Planet extends MovieClip 
	{
		
		public var mass:Number;
		public var volume:Number;
		public var planetname:String;
				public var tooltip:ToolTip;

		public function Planet() 
		{
			addEventListener(Event.ENTER_FRAME, rotatePlanet);
			this.addEventListener(MouseEvent.MOUSE_OVER, showInformation);
			this.addEventListener(MouseEvent.MOUSE_MOVE, update);
			this.addEventListener(MouseEvent.MOUSE_OUT, removeTool);
		}
		
		private function rotatePlanet(e:Event):void 
		{
			this.rotation += .1;
			this.ring.rotation += .1;
				if (tooltip) {
					tooltip.rotation = -this.rotation;
				}
		}
		
		private function update(e:MouseEvent):void 
		{
			if (tooltip) {
				tooltip.x = mouseX;
				tooltip.y = mouseY;
				tooltip.rotation = -this.rotation;
			}
			
		}
		
		private function removeTool(e:MouseEvent):void 
		{
			removeChild(tooltip);
		}
		
		private function showInformation(e:MouseEvent):void 
		{
			trace("SHOWING");
			tooltip = new ToolTip();
			tooltip.mouseEnabled = false;
			addChild(tooltip);
			tooltip.planetName.text = this.planetname;;
			tooltip.x = mouseX;
			tooltip.y = mouseY;
		}
		
	}

}