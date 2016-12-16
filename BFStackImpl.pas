unit BFStackImpl;

interface

uses
    Generics.Collections
  , BFStackIntf
  ;

type
    TBFCell = Class(TInterfacedObject, IBFCell)
    strict private
      FCell : Byte;
    public
      class function New              : IBFCell;
      function Add                    : IBFCell;
      function Sub                    : IBFCell;
      function Value                  : Byte;
      function Define(NewValue: Byte) : IBFCell;
    End;

    TBFStack = Class(TInterfacedObject, IBFStack)
    strict private
      FCells : TList<IBFCell>;
      FIdx   : LongWord;
    public
      constructor Create;
      destructor Destroy; Override;
      class function New : IBFStack;
      function Cell      : IBFCell;
      function MoveLeft  : IBFStack;
      function MoveRight : IBFStack;
    End;

    TBFInput = Class(TInterfacedObject, IBFInput)
    strict private
      FInput: String;
      FIdx: LongWord;
    public
      constructor Create(InputChain: String);
      class function New(InputChain: String): IBFInput;
      function Value: Byte;
    End;

    TBFProgram = Class(TInterfacedObject, IBFProgram)
    private
      FSource: IBFSource;
      FOutput: String;
      FOutputStack: IBFStack;
      procedure AddOutput(Value: Byte);
    public
      constructor Create(BFSource: IBFSource);
      class function New(BFSource: IBFSource): IBFProgram;
      function Run(Input: IBFInput): IBFProgram;
      function Output: String;
    End;

implementation

uses
    SysUtils
  ;

{ TBFCell }

function TBFCell.Add: IBFCell;
begin
     if FCell = High(Byte)
        then raise EOverflow.Create('Invalid operation: Cell value is already in its upper limit.');

     Result := Self;
     Inc(FCell);
end;

function TBFCell.Define(NewValue: Byte): IBFCell;
begin
     Result := Self;
     FCell  := NewValue;
end;

class function TBFCell.New: IBFCell;
begin
     Result := Create;
end;

function TBFCell.Sub: IBFCell;
begin
     if FCell = Low(Byte)
        then raise EUnderflow.Create('Invalid operation: Cell value is already in its lower limit.');

     Result := Self;
     Dec(FCell);
end;

function TBFCell.Value: Byte;
begin
     Result := FCell;
end;

{ TBFStack }

function TBFStack.Cell: IBFCell;
begin
     Result := FCells[FIdx];
end;

constructor TBFStack.Create;
begin
     FCells := TList<IBFCell>.Create;
     FCells.Add(TBFCell.New);
end;

destructor TBFStack.Destroy;
begin
     FCells.Free;
     inherited;
end;

function TBFStack.MoveLeft: IBFStack;
begin
     if FIdx = 0
        then raise EInvalidOp.Create('Invalid operation: Already in the leftmost position.');

     Result := Self;
     Dec(FIdx);
end;

function TBFStack.MoveRight: IBFStack;
begin
     Result := Self;
     Inc(FIdx);
     if FIdx = FCells.Count
        then FCells.Add(TBFCell.New);
end;

class function TBFStack.New: IBFStack;
begin
     Result := Create;
end;

{ TBFInput }

constructor TBFInput.Create(InputChain: String);
begin
     FInput := InputChain;
end;

class function TBFInput.New(InputChain: String): IBFInput;
begin
     Result := Create(InputChain);
end;

function TBFInput.Value: Byte;
begin
     Inc(FIdx);
     if FIdx > FInput.Length
        then raise EInOutError.Create('Invalid operation: Input queue has no more data.');
     Result := Ord(FInput[FIdx]);
end;

{ TBFProgram }

procedure TBFProgram.AddOutput(Value: Byte);
begin
     FOutput := FOutput + Chr(Value);
end;

constructor TBFProgram.Create(BFSource: IBFSource);
begin
     FSource      := BFSource;
     FOutputStack := TBFStack.New;
end;

class function TBFProgram.New(BFSource: IBFSource): IBFProgram;
begin
     Result := Create(BFSource);
end;

function TBFProgram.Output: String;
begin
     Result := FOutput;
end;

function TBFProgram.Run(Input: IBFInput): IBFProgram;
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
