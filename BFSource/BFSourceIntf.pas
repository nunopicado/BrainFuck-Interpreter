unit BFSourceIntf;

interface

uses
    BFCommandsIntf
  ;

type
    IBFSource = Interface ['{FF053E57-BB4D-4F22-BA67-C4092F4C93A8}']
      function Cmd: TBFCommandSet;
      function IsValid: Boolean;
      function SkipLoop: IBFSource;
      function RestartLoop: IBFSource;
    End;

implementation

end.
