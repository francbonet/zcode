/*
*
* MIT License
* 
* Copyright (c) 2008, Juan Delgado - Zarate
* 
* http://zarate.tv/projects/zcode/
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
* 
*/

package tv.zarate.application{
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import tv.zarate.application.evConfigReady;
	import tv.zarate.utils.FlashVars;
	
	public class Config extends EventDispatcher{
		
		public var dataXML:XML;
		
		protected var hardCodedXMLPath:String;
		protected var flashvars:FlashVars;
		protected var dataXMLPath:String;
		
		public function Config(){
			
			super();
			
		}
		
		public function setFlashVars(flashvars:FlashVars):void{
			this.flashvars = flashvars;
		}
		
		public function loadXML():void{
			
			dataXMLPath = (hardCodedXMLPath != null)? hardCodedXMLPath : flashvars.initString("fv_xmlPath","");
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,xmlLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR,xmlFail);
			loader.load(new URLRequest(dataXMLPath));
			
		}
		
		// ******************** PRIVATE METHODS ********************
		
		protected function xmlLoaded(e:Event):void{
			
			dataXML = new XML(e.target.data);
			parseXML();
			dispatchReadyEvent();
			
		}
		
		protected function parseXML():void{
			
			// You might want to extract some data from the XML before launching,
			// override this method to do so.
			
		}
		
		protected function dispatchReadyEvent():void{
			dispatchEvent(new evConfigReady());
		}
		
		protected function xmlFail(e:IOErrorEvent):void{
			dispatchEvent(e);
		}
		
	}
	
}