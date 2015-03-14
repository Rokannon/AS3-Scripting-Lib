package com.newgonzo.scripting
{
	import flash.system.ApplicationDomain;
	
	public class ScriptContext
	{
		private var thisObject:Object;
		private var exposedDefs:ScriptDomain;
		
		private var useProxies:Boolean = false;
		
		public function ScriptContext(scope:Object = null, useObjectProxies:Boolean = false, scriptDomain:ScriptDomain = null)
		{
			thisObject = scope;
			useProxies = useObjectProxies;
			exposedDefs = scriptDomain ? scriptDomain : new ScriptDomain();
		}
		
		public function get scope():Object
		{
			return thisObject;
		}
		
		public function get domain():ScriptDomain
		{
			return exposedDefs;
		}
		
		public function get useObjectProxies():Boolean
		{
			return useProxies;
		}
		
		public function exposeDefinition(type:*, name:String = null):void
		{
			exposedDefs.addDefinition(type, name);
		}
		
		public function getDefinition(name:String):*
		{
			return exposedDefs[name];
		}
		
		public function toString():String
		{
			return "[ScriptContext(scope=" + thisObject + " proxyObjects=" + useProxies + ")]";
		}
	}
}
