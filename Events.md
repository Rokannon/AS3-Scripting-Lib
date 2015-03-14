# Introduction #

Compiler errors and runtime errors are reported via events. `ICompiler` dispatches `CompilerErrorEvent`s for compiler errors and `IScript` dispatches `ScriptErrorEvent`s for runtime errors.

# Details #

Assuming an initialized instance of `ICompiler` already exists:

Compile Error
```

import com.newgonzo.scripting.ICompiler;
import com.newgonzo.scripting.IScript;
import com.newgonzo.scripting.events.CompilerErrorEvent;

// listen for compile errors
compiler.addEventListener(CompilerErrorEvent.COMPILER_ERROR, compilerError);

var invalid:String = "trace(";

var script:IScript = compiler.compile(source);

function compilerError(event:CompilerErrorEvent):void
{
  trace("COMPILER ERROR: " + event);
}

// traces "COMPILER ERROR: [CompilerErrorEvent(error=CompilerError: ESCompiler:1: String or identifier required, found rightbrace)]"

```


Runtime Error
```

import com.newgonzo.scripting.ICompiler;
import com.newgonzo.scripting.IScript;
import com.newgonzo.scripting.events.ScriptErrorEvent;

var invalid:String = "trace(invalid);";

var script:IScript = compiler.compile(source);

script.addEventListener(ScriptErrorEvent.SCRIPT_ERROR, scriptError);

// run the script
script.load();


function scriptError(event:ScriptErrorEvent):void
{
  trace("RUNTIME ERROR: " + event);
}

// traces "RUNTIME ERROR: [ScriptErrorEvent(error=ScriptError: Error #1065: Variable invalid is not defined.)]"

```