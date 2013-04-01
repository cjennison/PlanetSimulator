package com.jennison 
{
	/**
	 * ...
	 * @author 
	 */
	public class Math2 
	{
		
		public function Math2() 
		{
			
		}
		
		public static function randomiseBetween(range_min:int, range_max:int):int {
			var range:int = range_max - range_min;
			var randomised:int = Math.random() * range + range_min;
			return randomised;
		}
		
	}

}