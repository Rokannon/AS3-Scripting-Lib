This library aims to provide an API for compiling and executing runtime ActionScript/JavaScript within the Flash client (no server required) via Adobe's ECMAScript 4 compiler (from the Tamarin project).

Examples for Flex and Flash are included in the zip.

In its current state, it can:

  * Compile AS3/JavaScript at runtime within the Flash Player
  * Execute compiled code in the scope of any object
  * Control which classes and functions are exposed to the script domain

Please note: there are currently several bugs in Adobe's compiler that will cause it to choke on perfectly good script. I'm filing bugs with the Tamarin project team as I find them. I will try to document them in this project as well.

A [Flex app](http://testing.newgonzo.com/newgonzo/scriptingdemo/index.html) is available for testing and has a few examples included in the left-hand column. Clicking an example populates the editable script area, which can then be compiled and loaded by clicking "Compile and Load."

Its eventual, intended use is to be the scripting engine for the [Cannonball](http://code.google.com/p/as3cannonball) project.

You can contact me at john at newgonzo dot com.