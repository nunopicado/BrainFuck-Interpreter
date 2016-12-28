unit BFSourceIntf;

interface

uses
    BFCommandsIntf
  ;

type
    ISource = Interface ['{FF053E57-BB4D-4F22-BA67-C4092F4C93A8}']
      function Command(out Times: Integer) : TCommandSet;
      function IsValid                     : Boolean;
      function SkipLoop                    : ISource;
      function RestartLoop                 : ISource;
    End;

implementation

end.
