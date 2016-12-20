unit BFInterpreterIntf;

interface

uses
    BFInputIntf
  ;

type
    IBFInterpreter = Interface ['{56E9D1C7-756B-4C96-9F7F-A66FE2A5BE06}']
      function Run: IBFInterpreter;
      function AsString: String;
    End;

implementation

end.
