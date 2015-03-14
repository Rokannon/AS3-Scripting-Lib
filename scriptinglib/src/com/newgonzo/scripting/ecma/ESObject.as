package com.newgonzo.scripting.ecma
{
    import com.newgonzo.scripting.errors.ScriptError;

    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    // so flex doesn't remove our import
    flash_proxy;

    dynamic public class ESObject extends Proxy
    {
        private var parentScript:ESScript;

        // for keeping weak event listeners from being garbage collected
        private var listenerReferences:Array;

        protected var target:Object;

        public function ESObject(targetObject:Object, script:ESScript)
        {
            super();

            target = targetObject;
            parentScript = script;

            listenerReferences = new Array();
        }

        public function toString():String
        {
            return "{{{" + target + "}}}";
        }

        protected function getScriptValue(value:*):*
        {
            if (value is String || value is int || value is uint || value is Number || value is Boolean || value is XML)
            {
                return value;
            }

            return parentScript.getObject(value);
        }

        protected function getArgumentValue(value:*):*
        {
            if (value is ESObject)
            {
                return value.target;
            }

            return value;
        }

        protected function getArguments(args:Array):Array
        {
            var a:Array = new Array();
            var arg:*;

            for each(arg in args)
            {
                a.push(getArgumentValue(arg));
            }

            return a;
        }

        /*
            these should be moved into a more flexible implementation
        */
        protected function addEventListener(type:String, handler:Function, useCapture:Boolean = false, priority:int = 0,
                                            weakReferences:Boolean = true):void
        {
            // for controlling GC
            listenerReferences.push(handler);

            // ALWAYS use weak references
            target.addEventListener(type, handler, useCapture, priority, true);
        }

        protected function removeEventListener(type:String, handler:Function, useCapture:Boolean = false):void
        {
            var idx:int = listenerReferences.indexOf(handler);
            if (idx != -1) listenerReferences.splice(idx, 1);

            target.removeEventListener(type, handler, useCapture);
        }

        /*
        Proxy implementation
        */
        flash_proxy override function hasProperty(name:*):Boolean
        {
            try
            {
                return target.hasOwnProperty(name);
            }
            catch (e:Error)
            {
                parentScript.handleScriptError(new ScriptError(e.message, e));
            }

            return false;
        }

        flash_proxy override function getProperty(name:*):*
        {
            //trace("getProperty(" + name + ")");

            try
            {
                return getScriptValue(target[name]);
            }
            catch (e:Error)
            {
                parentScript.handleScriptError(new ScriptError(e.message, e));
            }
        }

        flash_proxy override function setProperty(name:*, value:*):void
        {
            try
            {
                target[name] = value;
            }
            catch (e:Error)
            {
                parentScript.handleScriptError(new ScriptError(e.message, e));
            }
        }

        flash_proxy override function callProperty(name:*, ...rest):*
        {
            try
            {
                var funcName:String = (name as QName).localName;
                var funcArgs:Array = getArguments(rest);

                // this should be moved into a more flexible implementation
                switch (funcName)
                {
                    case "addEventListener":
                        addEventListener.apply(null, funcArgs);
                        break;
                    case "removeEventListener":
                        removeEventListener.apply(null, funcArgs);
                        break;

                    default:
                        return getScriptValue(target[name].apply(target, funcArgs));
                }
            }
            catch (e:Error)
            {
                parentScript.handleScriptError(new ScriptError(e.message, e));
            }
        }

        /*
        flash_proxy override function nextName(index:int):String
        {
            try
            {
            }
            catch(e:Error)
            {
                parentScript.handleScriptError(new ScriptError(e.message, e));
            }

            return null;
        }

        flash_proxy override function nextNameIndex(index:int):int
        {
            try
            {
            }
            catch(e:Error)
            {
                parentScript.handleScriptError(new ScriptError(e.message, e));
            }

            return 0;
        }

        flash_proxy override function nextValue(index:int):*
        {
            try
            {
            }
            catch(e:Error)
            {
                parentScript.handleScriptError(new ScriptError(e.message, e));
            }

            return null;
        }
        */
    }
}