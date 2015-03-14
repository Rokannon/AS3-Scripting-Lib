package com.newgonzo.scripting.ecma
{
	import com.newgonzo.scripting.ICompiler;
	import com.newgonzo.scripting.IScript;
	import com.newgonzo.scripting.ScriptContext;
	import com.newgonzo.scripting.errors.CompilerError;
	import com.newgonzo.scripting.events.CompilerErrorEvent;
	import com.newgonzo.scripting.events.CompilerEvent;
	import com.newgonzo.scripting.utils.SWFFormat;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class ESCompiler extends EventDispatcher implements ICompiler
	{
		public static const CONTEXT_NAME:String = "ESCompiler";
		
		private static var escLoader:ESCLoader = new ESCLoader();
		private static var compileFunction:Function;

		public function ESCompiler()
		{
			if(!initialized)
			{
				escLoader.addEventListener(Event.INIT, compilerInit, false, 0, true);
			}
		}
		
		public function get initialized():Boolean
		{
			return escLoader.initialized;
		}
		
		public function compile(input:String, context:ScriptContext = null):IScript
		{
			var scriptContext:ScriptContext = context ? context : new ScriptContext();
			var script:IScript = createScript(scriptContext);
			var source:String = precompile(input, script);
			
			var bytes:ByteArray = compileByteArray(source, scriptContext);
			script.bytes = bytes;
			return script;
		}
		
		public function compileAndLoad(input:String, context:ScriptContext = null):IScript
		{
			var script:IScript = compile(input, context);
			script.load();
			return script;
		}
		
		
		
		protected function compileByteArray(input:String, context:ScriptContext):ByteArray
		{
			if(!initialized) throw new IllegalOperationError("ESCompiler not yet initialized.");
			
			try
			{
				var array:ByteArray = compileFunction(input, CONTEXT_NAME);
				return SWFFormat.makeSWF([array]);
			}
			catch(e:Error)
			{
				var error:Object = e as Object;
				handleCompilerError(new CompilerError(error.message, error.line, e));
			}
			
			return null;
		}
		
		protected function precompile(input:String, script:IScript):String
		{
			var source:String = buildFunction(input, script);
			//trace("\n" + source + "\n");
			return source;
		}
		
		protected function buildFunction(input:String, script:IScript):String
		{
			var source:String = "function " + script.id + "(thisObject:Object, definitions:Object):void {"
			source += defineTypes(script);
			
			if(script.scope)
			{
				source += "with(thisObject) {";
				source += input;
				source += "}";
			}
			else
			{
				source += input;
			}
			
			source += "}";
			
			return source;
		}
		
		protected function defineTypes(script:IScript):String
		{
			var source:String = "";
			var name:String;
			var pack:String;
			
			var definitions:Array = script.context.domain.definitionNames;
			
			for each(name in definitions)
			{
				pack = buildPackage(name);
				
				if(pack)
				{
					source += pack + name + " = definitions.getDefinition(\"" + name + "\");";	
				}
				else
				{
					source += "var " + name + " = definitions.getDefinition(\"" + name + "\");";
				}
			}
			
			return source;
		}
		
		protected function buildPackage(input:String):String
		{
			if(input.indexOf(".") == -1) return null;
			
			var packs:Array = input.split(".");
			
			// remove type name to get package only
			packs.pop();
			
			var i:int = 0;
			var len:int = packs.length;
			var source:String = "";
			var pack:String;
			var path:Array = new Array();
			
			while(i < len)
			{
				pack = packs[i];
				path.push(pack);
				
				source += "if(!" + path.join(".") + "){" + (i == 0 ? "var " : "") + path.join(".") + "={};};";
				
				i++;
			}
			
			return source;
		}
		
		protected function createScript(context:ScriptContext):IScript
		{
			return new ESScript(context);
		}
		
		protected function handleCompilerError(error:CompilerError):void
		{
			dispatchEvent(new CompilerErrorEvent(CompilerErrorEvent.COMPILER_ERROR, error));
		}
		
		
		
		private function compilerInit(event:Event):void
		{
			compileFunction = escLoader.compiler;
			dispatchEvent(new CompilerEvent(CompilerEvent.INIT));
		}
	}
}