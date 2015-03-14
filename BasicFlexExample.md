# Introduction #

The scripting lib can be used in Flex projects by referencing the library SWC or loading the ESCompilerSWF the same way FlashCS3 projects have to.

# Details #

Example (assuming scriptinglib.swc is in your Flex classpath)

```

<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" creationComplete="creationComplete();">
	<mx:Script>
		<![CDATA[
		
			import com.newgonzo.scripting.ICompiler;
			import com.newgonzo.scripting.events.CompilerEvent;
			import com.newgonzo.scripting.ecma.ESCompiler;
			
			private var compiler:ICompiler;
			
			private function creationComplete():void
			{
				compiler = new ESCompiler();
				compiler.addEventListener(CompilerEvent.INIT, compilerInit);
			}
				
			private function compilerInit(event:CompilerEvent):void
			{
			  compiler.compileAndLoad("trace('Hello, World!');");
			}
			
		]]>
	</mx:Script>
</mx:Application>

```