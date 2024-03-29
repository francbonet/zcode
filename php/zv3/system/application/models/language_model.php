<?php

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

class Language_model extends Model{
	
	var $cookieName = "zv3_lang";
	var $currentLang;
	var $newLanguage = false;
	
	public function Language_model(){
		
		parent::Model();
		
		$this->load->model('Section_model');
		$this->load->library('validate');
		
	}

	public function setLanguageByID($language_id){
		
		$res = false;
		
		$validate = array();
		$validate['input_type'] = 'value';
		$validate[] = array('input'=>$language_id,'rules'=>'maximum:8|required');
		
		if($this->validate->run($validate)){
			
			$lang = $this->getLanguageByID($language_id);
			
			if($lang != false){
				
				$this->setCurrentLang($lang);
				$res = true;
				
			}
			
		}
		
		return $res;
		
	}

	public function getLanguages(){
		
		$languages = array();
		$q = $this->db->get("language");
		
		foreach($q->result() as $language){ $languages[] = $language; }
		
		return $languages;
		
	}

	public function IsNewLanguage(){
		return $this->newLanguage;
	}

	public function checkLanguage(){
		
		$urilang = $this->getLanguageByShortID($this->uri->segment(1));
		
		if($urilang == false){ // no language in URI
			
			if($this->Section_model->isUniqueRewrite($this->uri->segment(1))){ // unique section rewrite
				
				$section = $this->Section_model->setSectionFromRewrite($this->uri->segment(1),true);
				
				$lang = $this->getLanguageByID($section->language_id);
				
				$this->setCurrentLang($lang);
				
			} else { // section rewrite conflict
				
				$session_language_id = $this->session->userdata('language_id');
				
				if(isset($session_language_id) && $session_language_id != ""){
					
					$lang = $this->getLanguageByID($session_language_id);
					$this->setCurrentLang($lang);
					
				} else {
					
					$cookieLang = $this->getCookieLanguage();
					
					if($cookieLang == false){ // no language in cookie
						
						$defaultLang = $this->getDefaultLanguage();
						
						$this->setCurrentLang($defaultLang);
						
					} else { // language in cookie, let's use it
						
						$this->setCurrentLang($cookieLang);
						
					}
					
				}
				
			}
			
		} else {
			
			$this->setCurrentLang($urilang);
			$this->newLanguage = true;
			
		}
		
		return $this->currentLang;
		
	}

	// *********************** PRIVATE METHODS ***********************

	private function setCurrentLang($lang){
		
		$this->load->helper('url');
		
		$this->currentLang = $lang;
		
		$this->session->set_userdata('language_id',$this->currentLang->language_id);
		$this->session->set_userdata('language_folder',$this->currentLang->lang_file);
		
		$cookie = array(
			'name'   => $this->cookieName,
			'value'  => $this->currentLang->language_id,
			'expire' => 60*60*24*365,
			'domain' => "",
			'path'   => '/',
			'prefix' => '',
		);
		
		$config['language'] = $this->currentLang->lang_file; // update CI lang file
		
		set_cookie($cookie);
		
	}

	private function getCookieLanguage(){
		
		$lang = false;
		$cookie = get_cookie($this->cookieName);
		
		if($cookie != false){
			
			$lang = $this->getLanguageByID($cookie["value"]);
			
		}
		
		return $lang;
		
	}
	
	private function getDefaultLanguage(){
		return $this->getLanguageByShortID("es");
	}
	
	private function getLanguageByID($language_id){
		
		$this->db->where("language_id",$language_id);
		$q = $this->db->get("language");
		return $q->row();
		
	}
	
	private function getLanguageByShortID($short_id){
		
		if($short_id == ""){  $short_id = " ";  } // temp fix until this is solved: http://codeigniter.com/forums/viewthread/70024/
		
		$this->db->from("language");
		$this->db->where("shortID",$short_id);
		$q = $this->db->get();
		
		$res = ($q->num_rows() > 0)? $q->row() : false;
		
		return $res;
		
	}

}

?>