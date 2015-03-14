package com.newgonzo.scripting
{
    import flash.events.IEventDispatcher;

    public interface ICompiler extends IEventDispatcher
    {
        function get initialized():Boolean

        function compile(input:String, context:ScriptContext = null):IScript

        function compileAndLoad(input:String, context:ScriptContext = null):IScript
    }
}