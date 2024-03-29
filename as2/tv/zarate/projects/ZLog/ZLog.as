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

import tv.zarate.utils.Delegate;
import flash.external.ExternalInterface;

class tv.zarate.projects.ZLog.ZLog{

	// clips
	private var receiving_lc:LocalConnection;
	private var fakeBR:String = "[br]";

	public function ZLog(m:MovieClip){
		
		receiving_lc = new LocalConnection();
		receiving_lc.allowDomain = function(domain:String):Boolean { return true; }
		receiving_lc.allowInsecureDomain = function(domain:String):Boolean { return true; }
		
		receiving_lc.log = Delegate.create(this,update);
		var success:Boolean = receiving_lc.connect("_ZLog");
		
		var txt:String = (success)? "ZLog up and running..." : "Cannot create LocalConnection. Maybe another instance of ZLog is already running!";
		var type:String = (success)? "log":"fatal";
		
		send(txt,type,false);
		
	}

	public static function main(m:MovieClip):Void{
		var zlog:ZLog = new ZLog(m);
	}

	// PRIVATE METHODS

	private function update(s:Object,type:String,reset:Boolean):Void{
		
		if(s instanceof XML){
			
			var rawXML:String = fakeBR + getNodeString(XMLNode(s.firstChild),0);
			s = replaceEntities(rawXML);
			s = s.split(fakeBR).join("<br>");
			
		}
		
		send(s,type,reset);
		
	}

	private function getNodeString(node:XMLNode,depth:Number):String{
		
		var s:String = "";
		var spacer:String = "";
		
		for(var x:Number=0;x<depth;x++){ spacer += "&nbsp;&nbsp;&nbsp;"; }
		
		if(node.hasChildNodes()){
			
			var attString:String = "";
			
			for(var x:String in node.attributes){ attString += " " + x + '="' + node.attributes[x] + '" '; }
			if(attString != ""){ attString = attString.substring(0,attString.length-1); }
			
			s += spacer + "&lt;" + node.nodeName + attString + "&gt;" + fakeBR;
			
			var totalChilds:Number = node.childNodes.length;
			
			for(var x:Number=0;x<totalChilds;x++){
				
				var n:XMLNode = node.childNodes[x];
				
				if(n.hasChildNodes()){
					
					s += getNodeString(n,depth+1);
					
				} else {
					
					s += spacer + spacer + replaceEntities(n.toString())  + fakeBR;
					
				}
				
			}
			
			s += spacer + "&lt;/" + node.nodeName + "&gt;" + fakeBR;
			
		} else {
			
			s += spacer + replaceEntities(node.toString()) + fakeBR;
			
		}
		
		return s;
		
	}

	private function send(s:Object,type:String,reset:Boolean):Void{
		ExternalInterface.call("updateZLog",escape(s.toString()),type,reset);
	}

	private function replaceEntities(s:String):String{
		return s.split("<").join("&lt;").split(">").join("&gt;");
	}

}