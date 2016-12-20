unit BFOutputIntf;

interface

type
    IBFCell = Interface ['{68191C4D-9539-4730-B4AB-3C423145376C}']
      function Add                    : IBFCell;
      function Sub                    : IBFCell;
      function Value                  : Byte;
      function Define(NewValue: Byte) : IBFCell;
    End;

    IBFStack = Interface ['{0149AEDA-BF0B-481C-9227-C8710CDC2AAF}']
      function Cell      : IBFCell;
      function MoveLeft  : IBFStack;
      function MoveRight : IBFStack;
      function AsString  : String;
    End;

implementation

end.
