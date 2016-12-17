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
      constructor Create(BFSource: IBFSource);
      class function New(BFSource: IBFSource): IBFInterpreter;
      function Run(Input: IBFInput): IBFInterpreter;
      function Output: String;
    End;

implementation

uses
    BFOutputImpl
  , BFCommandsIntf
  ;

{ TBFInterpreter }

procedure TBFInterpreter.AddOutput(Value: Byte);
begin
     FOutput := FOutput + Chr(Value);
end;

constructor TBFInterpreter.Create(BFSource: IBFSource);
begin
     FSource      := BFSource;
     FOutputStack := TBFStack.New;
end;

class function TBFInterpreter.New(BFSource: IBFSource): IBFInterpreter;
begin
     Result := Create(BFSource);
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
