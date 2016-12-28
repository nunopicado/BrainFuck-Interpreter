unit BFInterpreterImpl;

interface

uses
    BFInterpreterIntf
  , BFSourceIntf
  , BFTapeIntf
  , BFInputIntf
  ;

type
    TInterpreter = Class(TInterfacedObject, IInterpreter)
    private
      FSource : ISource;
      FOutput : String;
      FTape   : ITape;
      FInput  : IInput;
    public
      constructor Create(Source: ISource; Tape: ITape; Input: IInput = nil);
      class function New(Source: ISource; Tape: ITape; Input: IInput = nil): IInterpreter;
      function Run      : IInterpreter;
      function AsString : String;
    End;

implementation

uses
    BFCommandsIntf
  ;

{ TInterpreter }

constructor TInterpreter.Create(Source: ISource; Tape: ITape; Input: IInput = nil);
begin
     FSource := Source;
     FTape   := Tape;
     FInput  := Input;
end;

class function TInterpreter.New(Source: ISource; Tape: ITape; Input: IInput = nil): IInterpreter;
begin
     Result := Create(Source, Tape, Input);
end;

function TInterpreter.AsString: String;
begin
     Result := FOutput;
end;

function TInterpreter.Run: IInterpreter;
var
   Times: Integer;
begin
     Result := Self;
     while FSource.IsValid do
           with FTape do
                case FSource.Command(Times) of
                     bfRight     : MoveRight(Times);
                     bfLeft      : MoveLeft(Times);
                     bfAdd       : Cell.Add(Times);
                     bfSub       : Cell.Sub(Times);
                     bfWrite     : FOutput := FOutput + Chr(Cell.Value);
                     bfRead      : Cell.Define(FInput.Value);
                     bfLoopStart : if Cell.Value = 0
                                      then FSource.SkipLoop;
                     bfLoopStop  : if Cell.Value <> 0
                                      then FSource.RestartLoop;
                end;
end;

end.
