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

import com.meychi.ascrypt.MD5;

import tv.zarate.utils.Delegate;

import tv.zarate.projects.ZBooks.Label;
import tv.zarate.projects.ZBooks.Bookmark;
import tv.zarate.projects.ZBooks.Config;

class tv.zarate.projects.ZBooks.zbData{

	private var WSPath:String = "";
	private var dataXML:XML;
	private var currentUser:String = "1";
	private var serverKey:String = "";

	function zbData(_currentUser:String,_WSPath:String){

		WSPath = _WSPath;
		currentUser = _currentUser;

	}

	public function changeLogin(action:String,callback:Function,username:String,password:String,cookie:Boolean):Void{

		var hashedPass:String = MD5.calculate(password);
		var combinedHashed:String = MD5.calculate(hashedPass + serverKey);

		var query:String = WSPath+"?action=" + action;
		if(action == "login"){ query += "&username=" + username + "&password=" + combinedHashed + "&useCookie=" + cookie; }

		dataXML = new XML();
		dataXML.ignoreWhite = true;
		dataXML.addRequestHeader("Connection","'close'");
		dataXML.onLoad = Delegate.create(this,loginFinish,callback);
		dataXML.sendAndLoad(query,dataXML);

	}

	public function search(q:String,label_id:String,currentPage:Number,callback:Function):Void{

		dataXML = new XML();
		dataXML.ignoreWhite = true;
		dataXML.onLoad = Delegate.create(this,xmlLoaded,callback);
		dataXML.sendAndLoad(WSPath+"?action=search&query="+q+"&user_id="+currentUser+"&page="+currentPage,dataXML);

	}

	public function getLabelData(label_id:String,currentPage:Number,callback:Function):Void{

		dataXML = new XML();
		dataXML.ignoreWhite = true;
		dataXML.onLoad = Delegate.create(this,xmlLoaded,callback);
		dataXML.sendAndLoad(WSPath+"?user_id="+currentUser+"&label_id="+label_id+"&currentPage="+currentPage,dataXML);

	}

	public function manageBookmark(action:String,book:Bookmark,callback:Function):Void{

		book.title = escape(book.title);
		book.url = escape(book.url);
		book.labels = escape(book.labels);

		var path:String = WSPath+"?action="+action+"&bookmark_id="+book.id+"&private="+((book.isPrivate)? "1":"0")+"&title="+book.title+"&url="+book.url+"&label="+book.labels;

		dataXML = new XML();
		dataXML.ignoreWhite = true;
		dataXML.addRequestHeader("Connection","'close'");
		dataXML.onLoad = Delegate.create(this,dataAdded,callback);
		dataXML.sendAndLoad(path,dataXML);

	}

	public function getConfig(callback:Function):Void{

		var configXML:XML = new XML();
		configXML.ignoreWhite = true;
		configXML.onLoad = Delegate.create(this,configLoaded,configXML,callback);
		configXML.sendAndLoad(WSPath+"?user_id="+currentUser+"&action=getConfig",configXML);

	}

	// PRIVATE METHODS

	private function loginFinish(success:Boolean,callback:Function):Void{

		var error:Boolean = (dataXML.firstChild.attributes["error"] == "true")? true:false;
		var errorText:String = dataXML.firstChild.childNodes[0].childNodes[0].nodeValue;

		callback(error,errorText);

	}

	private function configLoaded(success:Boolean,configXML:XML,callback:Function):Void{

		if(success){

			var userConfig:Config = new Config();
			userConfig.setXML(configXML);

			serverKey = userConfig.key;

			callback(userConfig);

		}

	}

	private function xmlLoaded(success:Boolean,callback:Function):Void{

		if(success){

			// current label
			var currentLabel:Label = new Label();
			currentLabel.setData(dataXML.firstChild.childNodes[0]);

			// labels

			var labels:Array = new Array();

			var labelsRaw:String = dataXML.firstChild.childNodes[1].firstChild.nodeValue;

			var labelsData:Array = labelsRaw.split("*");
			var lng:Number = labelsData.length-1; // last item on the raw data is a "*" so we get one extra row

			for(var x:Number=0;x<lng;x++){

				var labelData:Array = labelsData[x].split("_");

				var l:Label = new Label();

				l.title = unescape(labelData[2]);
				l.id = labelData[0];
				l.isPrivate = labelData[1];

				labels.push(l);

			}

			delete dataXML;

			callback(currentLabel,labels);

		}

	}

	private function dataAdded(success:Boolean,callback:Function):Void{

		var result:Boolean = (dataXML.firstChild.attributes["error"] == "false")? true:false;
		var errorText:String = dataXML.firstChild.childNodes[0].childNodes[0].toString();
		callback(result,errorText);

	}

}