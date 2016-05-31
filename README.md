# Continuations as Elm Msgs

Right now this only works if you have an explicit `ThreadId` concept, and a
store of all the pending threads. Likewise, you need to pass the thread id
through the FFI itself, to maintain synchronousity. Then, you just pass a
callback into the `Msg` that initiates the FFI.

To build this, you can either use [ltext](http://ltext.github.io) to plug-in the
code, or import it yourself by editing `index-param.html`. But, to use `ltext`, just
issue this command:

```bash
elm make src/Main.elm --output dist/Main.js && ltext "index-param.html dist/Main.js" > index.html
```
