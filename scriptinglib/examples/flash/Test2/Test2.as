package
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	
	import com.newgonzo.scripting.events.CompilerEvent;
	import com.newgonzo.scripting.events.ScriptErrorEvent;
	import com.newgonzo.scripting.utils.CompilerLoader;
	import com.newgonzo.scripting.IScript;
	import com.newgonzo.scripting.ICompiler;
	import com.newgonzo.scripting.ScriptContext;
	
	public class Test2 extends MovieClip
	{
		// stage instances
		public var scriptUrl:TextInput;
		public var scriptText:TextArea;
		public var consoleText:TextArea;
		public var runButton:Button;
		public var clearButton:Button;
		public var loadButton:Button;
		
		private var compiler:ICompiler;
		private var script:IScript;
		private var context:ScriptContext;
		
		private var scriptLoader:URLLoader;
		private var compilerLoader:CompilerLoader;
		
		public function Test2()
		{
			initComponents();
			loadCompiler();
		}
		
		private function initComponents():void
		{
			scriptText.setStyle("embedFonts", true);
			scriptText.setStyle("textFormat", new TextFormat("Monaco", 14));
			
			runButton.addEventListener(MouseEvent.CLICK, runClicked);
			clearButton.addEventListener(MouseEvent.CLICK, clearClicked);
			loadButton.addEventListener(MouseEvent.CLICK, loadClicked);
		}
		
		private function loadCompiler():void
		{
			// load compiler
			compilerLoader = new CompilerLoader();
			compilerLoader.addEventListener(CompilerEvent.INIT, compilerInit);
			compilerLoader.load("../../../swf/bin-release/com/newgonzo/scripting/ecma/ESCompilerSWF.swf");
		}
		
		private function loadScript():void
		{	
			try
			{
				if(scriptLoader)
				{
					scriptLoader.close();
				}
				
				scriptLoader = new URLLoader();
				scriptLoader.addEventListener(Event.COMPLETE, scriptLoaded);
				scriptLoader.addEventListener(IOErrorEvent.IO_ERROR, scriptError);
				scriptLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, scriptError);
				scriptLoader.load(new URLRequest(scriptUrl.text));
			}
			catch(e:Error)
			{
				trace(e);
			}
		}
		
		private function runScript():void
		{
			if(script) script.unload();
			
			// setup context
			context = new ScriptContext(this);
			
			context.exposeDefinition(consolePrint, "console.print");
			context.exposeDefinition(consoleClear, "console.clear");
			
			consolePrint("--Compile--");
			
			try
			{
				script = compiler.compileAndLoad(scriptText.text, context);
				script.addEventListener(ScriptErrorEvent.SCRIPT_ERROR, scriptError);
			}
			catch(e:Error)
			{
				consolePrint(e.toString());
			}
		}
		
		private function consolePrint(input:String):void
		{
			consoleText.appendText(input + "\n");
		}
		
		private function consoleClear():void
		{
			consoleText.text = "";
		}
		
		private function compilerInit(event:CompilerEvent):void
		{
			compiler = event.compiler;
			loadScript();
		}
		
		private function scriptLoaded(event:Event):void
		{
			scriptText.text = scriptLoader.data;
			consoleClear();
			runScript();
		}
		
		private function scriptError(event:ErrorEvent):void
		{
			consolePrint(event.text);
		}
		
		private function loadClicked(event:MouseEvent):void
		{
			loadScript();
		}
		
		private function runClicked(event:MouseEvent):void
		{
			runScript();
		}
		
		private function clearClicked(event:MouseEvent):void
		{
			consoleClear();
		}
	}
}