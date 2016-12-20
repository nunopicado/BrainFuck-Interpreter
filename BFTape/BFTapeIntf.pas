unit BFTapeIntf;

interface

type
    ITapeCell = Interface ['{68191C4D-9539-4730-B4AB-3C423145376C}']
      function Add                    : ITapeCell;
      function Sub                    : ITapeCell;
      function Value                  : Byte;
      function Define(NewValue: Byte) : ITapeCell;
    End;

    ITapeCellFactory = Interface ['{4252A8BE-BEE4-401D-BBD0-A10C8F40A251}']
      function NewCell: ITapeCell;
    End;

    ITape = Interface ['{0149AEDA-BF0B-481C-9227-C8710CDC2AAF}']
      function Cell      : ITapeCell;
      function MoveLeft  : ITape;
      function MoveRight : ITape;
      function AsString  : String;
    End;

implementation

end.
