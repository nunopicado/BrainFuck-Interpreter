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
      FSource: IBFSource;
      FOutput: String;
      FOutputStack: IBFStack;
      procedure AddOutput(Value: Byte);
    public
      constructor Create(BFSource: IBFSource; BFOutput: IBFStack);
      class function New(BFSource: IBFSource; BFOutput: IBFStack): IBFInterpreter;
      function Run(Input: IBFInput): IBFInterpreter;
      function Output: String;
    End;

implementation

uses
    BFCommandsIntf
  ;

{ TBFInterpreter }

procedure TBFInterpreter.AddOutput(Value: Byte);
begin
     FOutput := FOutput + Chr(Value);
end;

constructor TBFInterpreter.Create(BFSource: IBFSource; BFOutput: IBFStack);
begin
     FSource      := BFSource;
     FOutputStack := BFOutput;
end;

class function TBFInterpreter.New(BFSource: IBFSource; BFOutput: IBFStack): IBFInterpreter;
begin
     Result := Create(BFSource, BFOutput);
end;

function TBFInterpreter.Output: String;
begin
     Result := FOutput;
end;

function TBFInterpreter.Run(Input: IBFInput): IBFInterpreter;
begin
     Result := Self;
     while FSource.IsValid do
           with FOutputStack do
                case FSource.Cmd of
                     bfRight     : MoveRight;
                     bfLeft      : MoveLeft;
                     bfAdd       : Cell.Add;
                     bfSub       : Cell.Sub;
                     bfWrite     : AddOutput(Cell.Value);
                     bfRead      : Cell.Define(Input.Value);
                     bfLoopStart : if Cell.Value = 0
                                      then FSource.SkipLoop;
                     bfLoopStop  : if Cell.Value <> 0
                                      then FSource.RestartLoop;
                end;
end;

end.
