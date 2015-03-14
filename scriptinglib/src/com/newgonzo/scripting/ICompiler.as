package com.newgonzo.scripting
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public interface ICompiler extends IEventDispatcher
	{
		function get initialized():Boolean
		
		function compile(input:String, context:ScriptContext = null):IScript
		function compileAndLoad(input:String, context:ScriptContext = null):IScript
	}
}