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
      FSource    : IBFSource;
      FOutputStr : String;
      FOutput    : IBFStack;
      FInput     : IBFInput;
      procedure AddOutput(Value: Byte);
    public
      constructor Create(BFSource: IBFSource; BFOutput: IBFStack; BFInput: IBFInput = nil);
      class function New(BFSource: IBFSource; BFOutput: IBFStack; BFInput: IBFInput = nil): IBFInterpreter;
      function Run      : IBFInterpreter;
      function AsString : String;
    End;

implementation

uses
    BFCommandsIntf
  ;

{ TBFInterpreter }

procedure TBFInterpreter.AddOutput(Value: Byte);
begin
     FOutputStr := FOutputStr + Chr(Value);
end;

constructor TBFInterpreter.Create(BFSource: IBFSource; BFOutput: IBFStack; BFInput: IBFInput = nil);
begin
     FSource := BFSource;
     FOutput := BFOutput;
     FInput  := BFInput;
end;

class function TBFInterpreter.New(BFSource: IBFSource; BFOutput: IBFStack; BFInput: IBFInput = nil): IBFInterpreter;
begin
     Result := Create(BFSource, BFOutput, BFInput);
end;

function TBFInterpreter.AsString: String;
begin
     Result := FOutputStr;
end;

function TBFInterpreter.Run: IBFInterpreter;
begin
     Result := Self;
     while FSource.IsValid do
           with FOutput do
                case FSource.Cmd of
                     bfRight     : MoveRight;
                     bfLeft      : MoveLeft;
                     bfAdd       : Cell.Add;
                     bfSub       : Cell.Sub;
                     bfWrite     : AddOutput(Cell.Value);
                     bfRead      : Cell.Define(FInput.Value);
                     bfLoopStart : if Cell.Value = 0
                                      then FSource.SkipLoop;
                     bfLoopStop  : if Cell.Value <> 0
                                      then FSource.RestartLoop;
                end;
end;

end.
