package com.newgonzo.scripting
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public interface IScript extends IEventDispatcher
	{
		function get id():String
		function get context():ScriptContext
		function get scope():Object
		function get errors():Array
		function get bytes():ByteArray
		function set bytes(value:ByteArray):void
		
		function load():void
		function unload():void
	}
}