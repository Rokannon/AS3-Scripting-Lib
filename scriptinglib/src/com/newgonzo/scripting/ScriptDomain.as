package com.newgonzo.scripting
{
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;

    public class ScriptDomain
    {
        private var appDomain:ApplicationDomain;

        private var namesToDefinitions:Dictionary;
        private var definitionsToNames:Dictionary;

        private var namesCache:Array;
        private var definitionsCache:Array;

        public function ScriptDomain(applicationDomain:ApplicationDomain = null)
        {
            appDomain = applicationDomain;

            namesToDefinitions = new Dictionary();
            definitionsToNames = new Dictionary();
            namesCache = new Array();
            definitionsCache = new Array();
        }

        public function get applicationDomain():ApplicationDomain
        {
            return appDomain;
        }

        public function get definitionNames():Array
        {
            // return clone
            return namesCache.concat();
        }

        public function get definitions():Array
        {
            // return clone
            return definitionsCache.cocat();
        }

        public function hasDefinition(name:String):Boolean
        {
            return namesToDefinitions[name] != null;
        }

        public function getDefinition(name:String):*
        {
            return namesToDefinitions[name];
        }

        public function getDefinitionName(type:*):String
        {
            return definitionsToNames[type];
        }

        public function addDefinition(type:*, name:String):void
        {
            namesToDefinitions[name] = type;
            definitionsToNames[type] = name;

            if (namesCache.indexOf(name) == -1)
            {
                namesCache.push(name);
            }

            if (definitionsCache.indexOf(type) != -1)
            {
                definitionsCache.push(type);
            }
        }

        public function removeDefinition(type:*, name:String):void
        {
            var definition:* = getDefinition(name);

            if (!definition)
            {
                throw new Error("Definition for \"" + name + "\" not found.");
            }

            var definitionName:String = getDefinitionName(type);

            if (!definitionName)
            {
                throw new Error("Definition " + type + " not found.");
            }

            if (definition != type || definitionName != name)
            {
                throw new Error("No match found for type " + type + " with name \"" + name + "\".");
            }

            // remove from tables
            delete namesToDefinitions[name];
            delete definitionsToNames[type];

            // remove from names list
            var idx:int = namesCache.indexOf(name);
            if (idx != -1) namesCache.splice(idx, 1);

            // remove from types list
            idx = definitionsCache.indexOf(type);
            if (idx != -1) definitionsCache.splice(idx, 1);
        }

        public function removeDefinitionByName(name:String):void
        {
            removeDefinition(getDefinition(name), name);
        }

        public function removeAllDefinitions():void
        {
            namesToDefinitions = new Dictionary();
            definitionsToNames = new Dictionary();
            namesCache = new Array();
            definitionsCache = new Array();
        }
    }
}