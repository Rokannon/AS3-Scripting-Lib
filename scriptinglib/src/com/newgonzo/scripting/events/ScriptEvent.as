package com.newgonzo.scripting.events
{
    import com.newgonzo.scripting.IScript;

    import flash.events.Event;

    public class ScriptEvent extends Event
    {
        public static const LOAD:String = "scriptLoad";
        public static const UNLOAD:String = "scriptUnload";

        public function ScriptEvent(type:String)
        {
            super(type, false, false);
        }

        public function get script():IScript
        {
            return target as IScript;
        }

        override public function clone():Event
        {
            return new ScriptEvent(type);
        }

        override public function toString():String
        {
            return formatToString("ScriptEvent", "script");
        }
    }
}