package
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import fl.controls.TextArea;
	
	import com.newgonzo.scripting.events.CompilerEvent;
	import com.newgonzo.scripting.events.ScriptErrorEvent;
	import com.newgonzo.scripting.utils.CompilerLoader;
	import com.newgonzo.scripting.IScript;
	import com.newgonzo.scripting.ICompiler;
	import com.newgonzo.scripting.ScriptContext;
	
	public class Test1 extends MovieClip
	{
		// stage instances
		public var scriptInput:TextArea;
		public var consoleText:TextArea;
		public var runButton:Button;
		public var clearButton:Button;
		
		private var compiler:ICompiler;
		private var script:IScript;
		private var context:ScriptContext;
		
		private var loader:CompilerLoader;
		
		public function Test1()
		{
			initComponents();
			loadCompiler();
		}
		
		private function initComponents():void
		{
			scriptInput.setStyle("embedFonts", true);
			scriptInput.setStyle("textFormat", new TextFormat("Monaco", 14));
			
			runButton.addEventListener(MouseEvent.CLICK, runClicked);
			clearButton.addEventListener(MouseEvent.CLICK, clearClicked);
		}
		
		private function loadCompiler():void
		{
			// load compiler
			loader = new CompilerLoader();
			loader.addEventListener(CompilerEvent.INIT, compilerInit);
			loader.load("../../../swf/bin-release/com/newgonzo/scripting/ecma/ESCompilerSWF.swf");
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
				script = compiler.compileAndLoad(scriptInput.text, context);
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
			
			runScript();
		}
		
		private function runClicked(event:MouseEvent):void
		{
			runScript();
		}
		
		private function clearClicked(event:MouseEvent):void
		{
			consoleClear();
		}
		
		private function scriptError(event:ScriptErrorEvent):void
		{
			consolePrint(event.text);
		}
	}
}