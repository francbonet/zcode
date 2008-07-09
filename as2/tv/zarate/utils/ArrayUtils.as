/*
* 
* Copyright (c) 2008, Juan Delgado - Zarate
* 
* Visit http://zarate.tv/proyectos/zcode/ for more info
* 
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.

* You should have received a copy of the GNU Lesser General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*/

class tv.zarate.utils.ArrayUtils{
	
	public static function randomizeArray(a:Array):Void{
		
		// Thanks to mr Steel for the quick googled solution:
		// http://mrsteel.wordpress.com/2007/06/15/randomize-array-shuffle-an-array-in-flash/
		
		var _length:Number = a.length, rn:Number, it:Number, el:Object;
		
		for (it=0;it<_length;it++){
			
			el = a[it];
			a[it] = a[rn = random(_length)];
			a[rn] = el;
			
		}
		
	}

}