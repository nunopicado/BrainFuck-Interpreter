unit BFStackIntf;

interface

type
    IBFCell = Interface ['{68191C4D-9539-4730-B4AB-3C423145376C}']
      function Add  : IBFCell;
      function Sub  : IBFCell;
      function Value: Byte;
      function Define(NewValue: Byte): IBFCell;
    End;

    IBFStack = Interface ['{0149AEDA-BF0B-481C-9227-C8710CDC2AAF}']
      function Cell      : IBFCell;
      function MoveLeft  : IBFStack;
      function MoveRight : IBFStack;
    End;

    IBFInput = Interface ['{2410C17E-5E31-4FEF-8144-B84A72E44412}']
      function Value: Byte;
    End;

    TBFCommand    = (bfLeft, bfRight, bfAdd, bfSub, bfWrite, bfRead, bfLoopStart, bfLoopStop);
    IBFSource = Interface ['{FF053E57-BB4D-4F22-BA67-C4092F4C93A8}']
      function Cmd: TBFCommand;
      function IsValid: Boolean;
      function SkipLoop: IBFSource;
      function RestartLoop: IBFSource;
    End;

    IBFProgram = Interface ['{56E9D1C7-756B-4C96-9F7F-A66FE2A5BE06}']
      function Run(Input: IBFInput): IBFProgram;
      function Output: String;
    End;

implementation

end.
