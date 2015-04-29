package com.newgonzo.scripting.ecma
{
    import com.newgonzo.scripting.ICompiler;
    import com.newgonzo.scripting.IScript;
    import com.newgonzo.scripting.ScriptContext;
    import com.newgonzo.scripting.ScriptDomain;
    import com.newgonzo.scripting.events.CompilerEvent;

    import flash.display.Sprite;
    import flash.events.Event;

    [SWF(width='1', height='1', backgroundColor='#FFFFFF', frameRate='30')]

    public class ESCompilerSWF extends Sprite implements ICompiler
    {
        private var compiler:ESCompiler;

        public function ESCompilerSWF()
        {
            compiler = new ESCompiler();
            compiler.addEventListener(CompilerEvent.INIT, compilerInit, false, 0, true);
        }

        public function get initialized():Boolean
        {
            return compiler.initialized;
        }

        public function compile(input:String, context:ScriptContext = null):IScript
        {
            return compiler.compile(input, context);
        }

        public function compileAndLoad(input:String, context:ScriptContext = null):IScript
        {
            return compiler.compileAndLoad(input, context);
        }

        private function compilerInit(event:Event):void
        {
            // dispatch bubbling even that will bubble up
            // to the Loader object that loaded this shell
            dispatchEvent(new CompilerEvent(CompilerEvent.INIT, true));
        }
    }
}
