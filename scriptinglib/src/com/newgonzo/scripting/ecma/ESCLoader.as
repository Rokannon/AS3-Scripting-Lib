package com.newgonzo.scripting.ecma
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    public class ESCLoader extends EventDispatcher
    {
        private var isLoading:Boolean = false;
        private var compilerLoader:Loader;
        private var compileFunction:Function;
        private var isInit:Boolean = false;

        public function ESCLoader()
        {
            super();
            loadESC();
        }

        public function get loading():Boolean
        {
            return isLoading;
        }

        public function get initialized():Boolean
        {
            return isInit;
        }

        public function get compiler():Function
        {
            return compileFunction;
        }

        protected function init():void
        {
            try
            {
                var domain:ApplicationDomain = compilerLoader.contentLoaderInfo.applicationDomain;

                var flags:Object = domain.getDefinition("ESC::flags");

                // this frees newer reserved keywords (like 'yield') from throwing compiler errors
                // BUG: this doesn't work for 'type'-- "var type = ..." will throw a compiler error
                flags.es3_keywords = true;

                compileFunction = domain.getDefinition("ESC::compileStringToBytes") as Function;

                isInit = true;
                dispatchEvent(new Event(Event.INIT));
            }
            catch (e:Error)
            {
                throw e;
            }
        }

        protected function loadESC():void
        {
            if (isInit || isLoading) return;

            isLoading = true;
            compilerLoader = new Loader();
            compilerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, escLoaded, false, 0, true);

            var swfBytes:ByteArray = ESC.swfBytes;
            var loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain());
            loaderContext.allowCodeImport = true;
            compilerLoader.loadBytes(swfBytes, loaderContext);
        }

        private function escLoaded(event:Event):void
        {
            isLoading = false;
            init();
        }
    }
}