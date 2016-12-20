# BrainFuck Interpreter
A simple interpreter to run BrainFuck programs

This interpreter aims to be a simple *BrainFuck* interpreter, for academic purposes only.
It receives a string with *BrainFuck* source code and an optional input string, and parses the code outputing it to another string.

  - Developed in Object Pascal, in this case, Delphi 10 Seattle
  - Object Oriented Paradigm
  - Allows native parsing of ***BrainFuck***, ***Ook!***, ***MorseFuck*** and ***BitFuck***
  - Allows parsing other *BrainFuck-like* languages, as long as the same logic is applied and only the operators change

The idea behind this project **is not** to be the best or more efficient *BrainFuck* parser availble, but rather to be an OOP implementation of the algorithmn behind the language.

### Tech

*BrainFuck* Interpreter relies on an number of objects that communicate in order to achieve the interpreter goal. Each object is interface based to allow different implementations, and each object has it's own well defined mission.

* IBFInterpreter - Represents the Interpreter. This is the main object where *BrainFuck* logic is applied
* IBFCommandList - Represents the list of available commands for the language being used. 
* IBFInput - Represents the input string, which holds the characters the source code will try to read
* IBFStack - Represent the list of cells where the source code logic is applied
* IBFCell - Represents a single cell in the stack
* IBFSource - Represents the source code


### Usage

To use ***BrainFuck* Interpreter**, you need to instantiate all the classes, and let them do their job. Here's an example:

```
Write(
      TBFInterpreter.New(
                         TBFSource.NewBrainFuck(
                                                '>++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]'+
                                                '<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.'+
                                                '+++.------.--------.>+.>+.'
                                               ),
                         TBFStack.New
                        )
                    .Run
                    .AsString
     );
```


### Licence

*BrainFuck* Interpreter's code itself is open source, and [GNU Public Licence](https://www.gnu.org/licenses/gpl-3.0.en.html "GNU Public Licence") Licence]. Any other licences involved are property of their respective owners and must be obliged under those terms.
