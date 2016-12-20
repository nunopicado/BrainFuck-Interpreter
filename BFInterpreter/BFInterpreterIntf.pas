unit BFInterpreterIntf;

interface

uses
    BFInputIntf
  ;

type
    IInterpreter = Interface ['{56E9D1C7-756B-4C96-9F7F-A66FE2A5BE06}']
      function Run      : IInterpreter;
      function AsString : String;
    End;

implementation

end.
