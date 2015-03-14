package com.newgonzo.scripting.events
{
    import com.newgonzo.scripting.errors.ScriptError;

    import flash.events.ErrorEvent;
    import flash.events.Event;

    public class ScriptErrorEvent extends ErrorEvent
    {
        public static const SCRIPT_ERROR:String = "scriptError";

        private var scriptError:ScriptError;

        public function ScriptErrorEvent(type:String, error:ScriptError)
        {
            super(type, false, false, error.message);

            scriptError = error;
        }

        public function get error():ScriptError
        {
            return scriptError;
        }

        override public function clone():Event
        {
            return new ScriptErrorEvent(type, scriptError);
        }

        override public function toString():String
        {
            return formatToString("ScriptErrorEvent", "error");
        }
    }
}