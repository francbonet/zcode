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

import tv.zarate.utils.TextfieldUtils;
import tv.zarate.utils.MovieclipUtils;
import tv.zarate.utils.Delegate;

import tv.zarate.projects.loqueyosede.Model;

class tv.zarate.projects.loqueyosede.View{
	
	private var model:Model;

	private var base_mc:MovieClip;
	private var background_mc:MovieClip;
	private var title_mc:MovieClip;
	private var titleField:TextField;
	
	private var width:Number = 0;
	private var height:Number = 0;
	
	private var OVER:String = "over";
	private var OUT:String = "out";
	private var PRESS:String = "press";
	
	public function View(){
		
		// hacemos que la vista sea listener de Stage
		// para poder reaccionar a cambios de dimensiones de 
		// la pelicula
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		Stage.addListener(this);
		
	}
	
	public function config(_model:Model,_base_mc:MovieClip):Void{
		
		// nos llega por composicion una instancia del modelo
		// eso nos permitira acceder a sus metodos y propiedades publicas
		model = _model;
		
		// guardamos una referencia al clip con el que trabajara la vista
		base_mc = _base_mc;
		
		// creamos los elementos basicos
		doInitialLayout();
		onResize();
		
	}

	public function displayValue(value:Number):Void{
		
		titleField.text = "Clicks > " + value;
		
	}
	
	// ************************* PRIVATE METHODS *************************

	private function doInitialLayout():Void{
		
		// este metodo solo es llamado una vez
		// y es el encargado de crear los elementos necesarios
		// ya sea por codigo y haciendo attach de elementos de la
		// biblioteca
		
		// aqui no deberia haber nada relacionado con el posicionamiento
		// de eso se encarga el metodo layout
		
		// color de fondo
		background_mc = base_mc.createEmptyMovieClip("background_mc",100);
		
		// creamos el campo de texto con el titulo
		title_mc = base_mc.createEmptyMovieClip("title_mc",200);
		titleField = TextfieldUtils.createField(title_mc);
		titleField.border = true;
		titleField.text = " ";
		
		// creamos el boton
		var button_mc:MovieClip = base_mc.createEmptyMovieClip("button_mc",300);

		var buttonBackground_mc:MovieClip = button_mc.createEmptyMovieClip("buttonBackground_mc",100);
		MovieclipUtils.DrawSquare(buttonBackground_mc,0x0000ff,100,200,50);

		var buttonTitle_mc:MovieClip = button_mc.createEmptyMovieClip("buttonTitle_mc",200);
		var field:TextField = TextfieldUtils.createField(buttonTitle_mc);
		field.text = "Haz click, majete!";
		
		button_mc._y = title_mc._y + title_mc._height + 10;

		// definimos los eventos y los delegamos al metodo manageButton
		button_mc.onPress = Delegate.create(this,manageButton,button_mc,PRESS);
		button_mc.onRollOver = Delegate.create(this,manageButton,button_mc,OVER);
		button_mc.onRollOut = Delegate.create(this,manageButton,button_mc,OUT);
		
	}

	private function layout():Void{
		
		// este metodo es llamado siempre que la pelicula
		// cambia de dimensiones
		
		MovieclipUtils.DrawSquare(background_mc,0xff00ff,100,width,height);
		
			
	}

	private function onResize():Void{
		
		// actualizamos las dimensiones de la pelicula
		width = Stage.width;
		height = Stage.height;
		
		
		// llamamos al metodo de posicionamiento
		layout();
		
	}
	
	private function manageButton(mc:MovieClip,action:String):Void{
		
		// por vagancia no hago nada en el OVER y el OUT
		// pero para eso llega una referencia al button en el parametro
		// mc, para poder, por ejemplo, cambiarle el color
		
		switch(action){
			
			case(OVER):
				break;
			case(OUT):
				break;
			case(PRESS):
				
				// llamamos a un metodo publico del modelo
				// que actualiza el contador de clicks
				model.updateClick();
			
		}
		
	}
	
}