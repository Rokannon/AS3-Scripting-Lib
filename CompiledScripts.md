# Introduction #

Compiled scripts can be referenced and reused much faster than recompiling. Both `ICompiler.compile()` and `ICompiler.compileAndLoad()` return an instance of `IScript` that can be used to re-execute the compiled code.

# Details #

Assuming an initialized instance of `ICompiler` already exists:

```

import com.newgonzo.scripting.ICompiler;
import com.newgonzo.scripting.IScript;
import com.newgonzo.scripting.ScriptContext;

var source:String = "trace('Hello, World!');";

var script:IScript = compiler.compile(source);

script.load();
script.load();
script.load();

// Hello, World!
// Hello, World!
// Hello, World!


```