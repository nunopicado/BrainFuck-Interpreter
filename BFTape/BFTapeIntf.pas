unit BFTapeIntf;

interface

type
    ITapeCell = Interface ['{68191C4D-9539-4730-B4AB-3C423145376C}']
      function Add(Times: Integer = 1) : ITapeCell;
      function Sub(Times: Integer = 1) : ITapeCell;
      function Value                   : Byte;
      function Define(NewValue: Byte)  : ITapeCell;
    End;

    ITape = Interface ['{0149AEDA-BF0B-481C-9227-C8710CDC2AAF}']
      function Cell                          : ITapeCell;
      function MoveLeft(Times: Integer = 1)  : ITape;
      function MoveRight(Times: Integer = 1) : ITape;
      function AsString                      : String;
    End;

implementation

end.
