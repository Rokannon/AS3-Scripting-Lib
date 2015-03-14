package com.newgonzo.scripting.ecma
{
    import com.newgonzo.scripting.IScript;
    import com.newgonzo.scripting.ScriptContext;
    import com.newgonzo.scripting.errors.ScriptError;
    import com.newgonzo.scripting.events.ScriptErrorEvent;
    import com.newgonzo.scripting.events.ScriptEvent;

    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    public class ESScript extends EventDispatcher implements IScript
    {
        private static const SCRIPT_ID_PREFIX:String = "__script";
        private static var idCount:int = 0;

        // use anonymouse function get get reference to [object global]. hack?
        private static const global:Object = (function ():Object
        {
            return this;
        })();

        private const helperArray:Array = [];

        private var isLoaded:Boolean = false;

        private var scriptId:String;
        private var swfBytes:ByteArray;
        private var loadedScript:Loader;
        private var scriptContext:ScriptContext;
        private var objects:Dictionary;

        private var scriptFunction:Function;

        private var scriptErrors:Array;

        public function ESScript(context:ScriptContext, bytes:ByteArray = null)
        {
            scriptContext = context;
            swfBytes = bytes;

            scriptId = SCRIPT_ID_PREFIX + idCount++;

            objects = new Dictionary();
            scriptErrors = new Array();
        }

        public function get id():String
        {
            return scriptId;
        }

        public function get bytes():ByteArray
        {
            return swfBytes;
        }

        public function set bytes(value:ByteArray):void
        {
            unload();
            swfBytes = value;
        }

        public function get context():ScriptContext
        {
            return scriptContext;
        }

        public function get errors():Array
        {
            return scriptErrors;
        }

        public function get scope():Object
        {
            return getObject(scriptContext.scope);
        }

        public function load():void
        {
            try
            {
                unload();

                // re-create object proxy table
                objects = new Dictionary();

                swfBytes.position = 0;

                // loaded script executes in its own ApplicationDomain
                // to keep it eligible for garbage collection
                var context:LoaderContext = new LoaderContext(false,
                                                              new ApplicationDomain(scriptContext.domain.applicationDomain));
                loadedScript = new Loader();
                loadedScript.loadBytes(bytes, context);
                loadedScript.contentLoaderInfo.addEventListener(Event.COMPLETE, scriptLoaded, false, 0, true);
                loadedScript.contentLoaderInfo.addEventListener(Event.UNLOAD, scriptUnloaded, false, 0, true);
                loadedScript.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, scriptError, false, 0, true);
            }
            catch (error:Error)
            {
                handleScriptError(new ScriptError("Error loading script.", error));
            }
        }

        public function addObject(target:Object, object:ESObject):void
        {
            objects[target] = object;
        }

        public function getObject(target:Object):*
        {
            if (!target)
            {
                target = global;
            }

            if (!context.useObjectProxies)
            {
                return target;
            }

            var obj:ESObject = objects[target] as ESObject;

            if (!obj)
            {
                obj = new ESObject(target, this);
                objects[target] = obj;
            }

            return obj;
        }

        public function unload():void
        {
            if (loadedScript)
            {
                loadedScript.contentLoaderInfo.removeEventListener(Event.COMPLETE, scriptLoaded);
                loadedScript.contentLoaderInfo.removeEventListener(Event.UNLOAD, scriptUnloaded);
                loadedScript.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, scriptError);

                loadedScript.unload();
            }

            loadedScript = null;

            // release script function
            scriptFunction = null;

            // release object proxies
            objects = null;

            // reset errors
            scriptErrors = new Array();

            isLoaded = false;
        }

        public function handleScriptError(error:ScriptError):void
        {
            scriptErrors.push(error);
            dispatchEvent(new ScriptErrorEvent(ScriptErrorEvent.SCRIPT_ERROR, error));
        }

        protected function hasDefinition(name:String):Boolean
        {
            if (loadedScript)
            {
                return loadedScript.contentLoaderInfo.applicationDomain.hasDefinition(name);
            }

            return false;
        }

        protected function getDefinition(name:String):Object
        {
            if (hasDefinition(name))
            {
                return loadedScript.contentLoaderInfo.applicationDomain.getDefinition(name);
            }

            throw new ReferenceError("Definition for \"" + name + "\" not found.");
        }

        public function run():void
        {
            if (isLoaded)
                runScript();
        }

        protected function runScript():void
        {
            try
            {
                dispatchEvent(new ScriptEvent(ScriptEvent.START));

                helperArray[0] = scope;
                helperArray[1] = scriptContext.domain;
                scriptFunction.apply(scope, helperArray);

                dispatchEvent(new ScriptEvent(ScriptEvent.COMPLETE));
            }
            catch (e:Error)
            {
                handleScriptError(new ScriptError(e.message, e));
            }
        }

        private function scriptLoaded(event:Event):void
        {
            try
            {
                scriptFunction = getDefinition(id) as Function;
                isLoaded = true;
                dispatchEvent(new ScriptEvent(ScriptEvent.LOAD));
            }
            catch (e:Error)
            {
                handleScriptError(new ScriptError("Error loading script definition \"" + id + "\".", e));
            }
        }

        private function scriptUnloaded(event:Event):void
        {
            dispatchEvent(new ScriptEvent(ScriptEvent.UNLOAD));
        }

        private function scriptError(event:IOErrorEvent):void
        {
            handleScriptError(new ScriptError("Error loading script bytes: " + event.text));
        }
    }
}