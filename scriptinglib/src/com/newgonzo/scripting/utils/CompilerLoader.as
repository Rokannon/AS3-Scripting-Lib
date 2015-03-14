package com.newgonzo.scripting.utils
{
	import com.newgonzo.scripting.ICompiler;
	import com.newgonzo.scripting.events.CompilerEvent;
	
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class CompilerLoader extends EventDispatcher
	{
		protected var loader:Loader;
		protected var loadedCompiler:ICompiler;
		
		public function CompilerLoader(url:String = null)
		{
			super();
			
			if(url)
			{
				loadCompiler(url);
			}
		}
		
		public function get compiler():ICompiler
		{
			return loadedCompiler;
		}
		
		public function load(url:String):void
		{
			loadCompiler(url);
		}
		
		protected function loadCompiler(url:String):void
		{
			loader = new Loader();
			loader.addEventListener(CompilerEvent.INIT, compilerInit, false, 0, true);
			loader.load(new URLRequest(url), new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain)));
		}
		
		private function compilerInit(event:CompilerEvent):void
		{
			loadedCompiler = event.compiler;
			dispatchEvent(new CompilerEvent(CompilerEvent.INIT, false, false, loadedCompiler));
		}
	}
}