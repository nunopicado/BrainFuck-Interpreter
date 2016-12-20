unit BFInterpreterImpl;

interface

uses
    BFInterpreterIntf
  , BFSourceIntf
  , BFOutputIntf
  , BFInputIntf
  ;

type
    TBFInterpreter = Class(TInterfacedObject, IBFInterpreter)
    private
      FSource : IBFSource;
      FOutput : String;
      FStack  : IBFStack;
      FInput  : IBFInput;
    public
      constructor Create(BFSource: IBFSource; BFStack: IBFStack; BFInput: IBFInput = nil);
      class function New(BFSource: IBFSource; BFStack: IBFStack; BFInput: IBFInput = nil): IBFInterpreter;
      function Run      : IBFInterpreter;
      function AsString : String;
    End;

implementation

uses
    BFCommandsIntf
  ;

{ TBFInterpreter }

constructor TBFInterpreter.Create(BFSource: IBFSource; BFStack: IBFStack; BFInput: IBFInput = nil);
begin
     FSource := BFSource;
     FStack  := BFStack;
     FInput  := BFInput;
end;

class function TBFInterpreter.New(BFSource: IBFSource; BFStack: IBFStack; BFInput: IBFInput = nil): IBFInterpreter;
begin
     Result := Create(BFSource, BFStack, BFInput);
end;

function TBFInterpreter.AsString: String;
begin
     Result := FOutput;
end;

function TBFInterpreter.Run: IBFInterpreter;
begin
     Result := Self;
     while FSource.IsValid do
           with FStack do
                case FSource.Cmd of
                     bfRight     : MoveRight;
                     bfLeft      : MoveLeft;
                     bfAdd       : Cell.Add;
                     bfSub       : Cell.Sub;
                     bfWrite     : FOutput := FOutput + Chr(Cell.Value);
                     bfRead      : Cell.Define(FInput.Value);
                     bfLoopStart : if Cell.Value = 0
                                      then FSource.SkipLoop;
                     bfLoopStop  : if Cell.Value <> 0
                                      then FSource.RestartLoop;
                end;
end;

end.
