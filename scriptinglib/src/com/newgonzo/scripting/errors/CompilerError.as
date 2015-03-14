package com.newgonzo.scripting.errors
{
    public class CompilerError extends Error
    {
        public var line:int = -1;
        public var internalError:Error;

        public function CompilerError(message:String = "", line:int = -1, internalError:Error = null, id:int = 0)
        {
            super(message, id);

            this.line = line;
            this.internalError = internalError;
            this.name = "CompilerError";
        }
    }
}