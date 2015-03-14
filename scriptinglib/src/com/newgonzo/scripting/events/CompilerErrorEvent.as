package com.newgonzo.scripting.events
{
	import com.newgonzo.scripting.errors.CompilerError;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;

	public class CompilerErrorEvent extends ErrorEvent
	{
		public static const COMPILER_ERROR:String = "compilerError";
		
		private var compilerError:CompilerError;
		
		public function CompilerErrorEvent(type:String, error:CompilerError)
		{
			super(type, false, false, error.message);
		
			compilerError = error;
		}
		
		public function get error():CompilerError
		{
			return compilerError;
		}
		
		override public function clone():Event
		{
			return new CompilerErrorEvent(type, compilerError);
		}
		
		override public function toString():String
		{
			return formatToString("CompilerErrorEvent", "error");
		}
	}
}