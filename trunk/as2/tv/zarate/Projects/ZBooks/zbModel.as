import tv.zarate.Projects.ZBooks.zbData;
import tv.zarate.Projects.ZBooks.zbView;
import tv.zarate.Utils.Delegate;
import tv.zarate.Utils.FlashVars;

import tv.zarate.Projects.ZBooks.Label;
import tv.zarate.Projects.ZBooks.Bookmark;
import tv.zarate.Projects.ZBooks.Config;

class tv.zarate.Projects.ZBooks.zbModel{
	
	private var currentLabel:Label;
	private var view:zbView;
	private var data:zbData;
	private var userConfig:Config;
	private var flashVars:FlashVars;
	
	private var currentLabelID:String = "0";
	private var totalBookmarks:Number = 0;
	private var pages:Number = 1;
	private var currentPage:Number = 1;
	private var labels:Array;
	private var loggedIn:Boolean = false;
	
	private var currentUser:String = "1";
	private var timeLine_mc:MovieClip;
	private var externalAdded:Boolean = false;
	private var searching:Boolean = false;
	private var searchQuery:String = "";
	
	public function zbModel(){}
	
	public function config(_view:zbView,m:MovieClip):Void{
		
		view = _view;
		timeLine_mc = m;
		flashVars = FlashVars.getInstance();
		flashVars.config(timeLine_mc);
		
		currentUser = flashVars.initString("fv_user_id",currentUser);
		currentLabelID = flashVars.initString("fv_label_id",currentLabelID);
		
		data = new zbData(currentUser,timeLine_mc);
		
	}
	
	public function start():Void{
		data.getConfig(Delegate.create(this,configLoaded));
	}

	public function goToOwnPage():Void{
		
		/* we could do it with out reloading the whole page
		* but dont want to leave the old user_id in the browser's
		* address bar */
		
		getURL("?user_id=" + getUserConfig().user_id);
		
	}
	
	public function logout():Void{
		data.changeLogin("logout",Delegate.create(this,afterLoginProcess));
	}
	
	public function login(name:String,pass:String):Void{
		data.changeLogin("login",Delegate.create(this,afterLoginProcess),name,pass);
	}
	
	private function afterLoginProcess(validLogin:Boolean,errorText:String):Void{
		
		loggedIn = validLogin;
		
		if(validLogin){
			
			data.getConfig(Delegate.create(this,configLoaded,true));
			
		} else {
			
			view.showError(errorText,Delegate.create(view,view.showLoginForm));
			
		}
		
	}
	
	public function nextPage():Void{
		if(currentPage < pages && pages > 1){ setNewPage(currentPage+1); }
	}

	public function previousPage():Void{
		if(currentPage > 1) setNewPage(currentPage-1);
	}

	public function setNewPage(page:Number):Void{
		
		view.disableApp();
		currentPage = page;
		data.getLabelData(currentLabelID,page,this,dataXMLLoaded);
		
	}
	
	public function setNewLabel(label_id:String,keepPage:Boolean):Void{
		
		view.disableApp();
		currentLabelID = label_id;
		if(keepPage == undefined || keepPage == null) currentPage = 1;
		data.getLabelData(currentLabelID,currentPage,this,dataXMLLoaded);
		
	}
	
	public function manageBookmark(action:String,book:Bookmark):Void{
		data.manageBookmark(action,book,this,dataAdded);
	}
	
	public function dataAdded(success:Boolean,errorText:String):Void{
		
		if(success){
			
			data.getLabelData(currentLabelID,currentPage,this,dataXMLLoaded);
			
		} else {
			
			view.showError(errorText);
			
		}
		
	}
	
	public function search(q:String):Void{
		
		currentPage = 1;
		searching = true;
		searchQuery = q;
		data.search(q,currentLabelID,currentPage,this,dataXMLLoaded);
		
	}
	
	public function reloadCurrentLabel():Void{
		data.getLabelData(currentLabelID,currentPage,this,dataXMLLoaded);
	}
	
	public function getLabels():Array{
		return labels;
	}
	
	public function getCurrentLabel():Label{
		return currentLabel;
	}
	
	public function getUserConfig():Config{
		return userConfig;
	}
	
	public function lookingAtOwnBookmarks():Boolean{
		return (userConfig.user_id == currentUser);
	}
	
	public function isLoggedIn():Boolean{
		return loggedIn;
	}
	
	// PRIVATE METHODS
	
	private function configLoaded(confObj:Config,keepPage:Boolean):Void{
		
		loggedIn = confObj.edit;
		
		userConfig = confObj;
		setNewLabel(currentLabelID,keepPage);
		
	}
	
	private function dataXMLLoaded(_currentLabel:Label,_labels:Array):Void{
		
		currentLabel = _currentLabel;
		labels = _labels;
		
		userConfig.owner = currentLabel.owner;
		pages = currentLabel.pages;
		
		view.startDraw();
		
		var externalURL:String = unescape(flashVars.initString("fv_url",""));
		
		if(externalURL != "" && !externalAdded){
			
			if(config.edit == true){
				
				externalAdded = true;
				var externalTitle:String = unescape(flashVars.initString("fv_title",""));
				
				var b:Bookmark = new Bookmark();
				b.url = externalURL;
				b.title = externalTitle;
				
				view.showBookmarkForm(b);
				
			} else {
				
				view.showError("You must be logged in to add new links.");
				
			}
			
		}
		
		if(searching){
			
			searching = false;
			view.focusSearchField(searchQuery);
			
		}
		
	}
	
}