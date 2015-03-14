# Introduction #

Compiled scripts execute in their own `ApplicationDomain` with no ability to import package definitions. To make classes and functions available to the scripting domain, you must expose them via `ScriptContext.exposeDefinition()`, or by instantiating the `ScriptContext` with a pre-populated `ScriptDomain` object.

# Details #

Assuming an initialized instance of `ICompiler` already exists:

Exposing a local function:
```

import com.newgonzo.scripting.ICompiler;
import com.newgonzo.scripting.ScriptContext;


function printMessage(msg:String):void
{
  trace("MESSAGE: " + msg);
}

var context:ScriptContext = new ScriptContext();

// expose printMessage as console.print
context.exposeDefinition(printMessage, "console.print");

var source:String = "console.print('Hello, World!');"

compiler.compileAndLoad(source, context);

// traces "MESSAGE: Hello, World!"


```

Exposing a class:
```

import com.newgonzo.scripting.ICompiler;
import com.newgonzo.scripting.ScriptContext;
import flash.utils.Dictionary;

var context:ScriptContext = new ScriptContext();

// expose Dictionary
context.exposeDefinition(Dictionary, "flash.utils.Dictionary");

var source:String = "var dict = new flash.utils.Dictionary(); trace(dict);"

compiler.compileAndLoad(source, context);

// traces "[object Dictionary]"


```

Packages can also be "imported" using `with`:

AS3:
```
context.exposeDefinition(Dictionary, "flash.utils.Dictionary");
context.exposeDefinition(trace, "console.print");
```

Script:
```

with(flash.utils)
with(console)
{
  var dict = new Dictionary();
  print(dict); // traces [object Dictionary]
}

```