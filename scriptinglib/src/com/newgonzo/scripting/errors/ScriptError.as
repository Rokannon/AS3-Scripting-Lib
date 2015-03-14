package com.newgonzo.scripting.errors
{
    public class ScriptError extends Error
    {
        public var internalError:Error;

        public function ScriptError(message:String = "", internalError:Error = null, id:int = 0)
        {
            super(message, id);
            this.name = "ScriptError";
        }
    }
}