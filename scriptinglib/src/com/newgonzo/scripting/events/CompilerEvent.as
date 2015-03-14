package com.newgonzo.scripting.events
{
	import com.newgonzo.scripting.ICompiler;
	
	import flash.events.Event;

	public class CompilerEvent extends Event
	{
		public static const INIT:String = "compilerInit";
		
		private var targetCompiler:ICompiler;
		
		public function CompilerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, compiler:ICompiler = null)
		{
			super(type, bubbles, cancelable);
			
			targetCompiler = compiler;
		}
		
		public function get compiler():ICompiler
		{
			return targetCompiler ? targetCompiler : (target as ICompiler);
		}
		
		override public function clone():Event
		{
			return new CompilerEvent(type, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("CompilerEvent", "compiler");
		}
	}
}