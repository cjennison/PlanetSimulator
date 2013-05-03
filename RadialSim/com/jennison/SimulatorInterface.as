package com.jennison 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class SimulatorInterface extends MovieClip 
	{
		public var yearsNum:Number = 50000000;
		public var IncRate:Number = .0048;
		public var enabledx:Boolean = false;
		public var retractTimer:Timer = new Timer(1000, 5);
		
		public function SimulatorInterface() 
		{
			yearsNum = randomMinMax(49000000, 54000000);
			planetFlyup.addEventListener(MouseEvent.MOUSE_OVER, movePlanetUI);
			planetFlyup.addEventListener(MouseEvent.MOUSE_MOVE, resetTimer);
			planetFlyup.addEventListener(MouseEvent.MOUSE_OUT, startTimer);
			planetFlyup.volume.restrict = "0-9";
			planetFlyup.mass.restrict = "0-9";
			
			retractTimer.addEventListener(TimerEvent.TIMER_COMPLETE, retractUI);
			addEventListener(Event.ENTER_FRAME, increaseYears);
		}
		
		private function increaseYears(e:Event):void 
		{
			//trace(IncRate);
			yearsNum += IncRate;
			
			years.text = Math.round(yearsNum) + " years";
		}
		
		private function startTimer(e:MouseEvent):void 
		{
			retractTimer.start();
			trace("OUT");
		}
		
		private function retractUI(e:TimerEvent):void 
		{
			retractTimer.stop();
			enabledx = false;
			trace("DOING OUT");
			var UiTweenOut:Tween = new Tween(planetFlyup, "y", Strong.easeOut, 730.15, 878.2, 1, true);
			
		}
		
		private function resetTimer(e:MouseEvent):void 
		{
			//retractTimer.reset();
			trace("ON");

		}
		
		private function movePlanetUI(e:MouseEvent):void 
		{
			trace("IN");
			retractTimer.reset();
			
			if (enabledx == false) {
				enabledx = true;
				var UiTween:Tween = new Tween(planetFlyup, "y", Strong.easeOut, 878.2, 730.15, 1, true);
			}

		}
		
		public function getPlanetData() {
			var data:Object = {volume:Number, mass:Number, name:String, type:String, hasRings:Boolean};
			data.volume = planetFlyup.volume.text;
			if (planetFlyup.volume.text == "") {
				data.volume = Math.random() * 100;
			}
			data.mass = planetFlyup.mass.text;
			if (planetFlyup.volume.text == "") {
				data.mass = Math.random() * 100;
			}
			data.name = planetFlyup.planet_name.text;
			if (planetFlyup.volume.text == "") {
				data.name = "XR" + Math.ceil(Math.random() * 2000);
			}
			
			if (planetFlyup.ring_selector.value == "rings") {
				data.hasRings = true;
			} else {
				data.hasRings = false;
			}
			
			data.type = planetFlyup.planet_type.value;
			trace(data.type);
			
			return data;
		}
		
		function randomMinMax( min:Number, max:Number ):Number
		{
			 return min + (max - min) * Math.random();
		}
		
	}

}