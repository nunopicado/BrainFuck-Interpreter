unit BFStackImpl;

interface

uses
    Generics.Collections
  , Classes
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

    TBFCommandList = Class(TInterfacedObject, IBFCommandList)
    strict private
      FCmdList   : TStringList;
      FTokenSize : Byte;
    public
      constructor Create(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String);
      destructor Destroy; Override;
      class function New(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String): IBFCommandList;
      function TokenSize: Byte;
      function Item(Idx: Byte): TBFCommand; Overload;
      function Item(Token: String): TBFCommand; Overload;
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

    TBFSource = Class(TInterfacedObject, IBFSource)
    strict private // Fields
      FCmdList : IBFCommandList;
      FSource  : String;
      FIdx     : LongWord;
    strict private // Methods
      function Token(Idx: LongWord = 0): String;
    public
      constructor Create(CmdList: IBFCommandList; Source: String);
      class function New(CmdList: IBFCommandList; Source: String): IBFSource;
      function Cmd: TBFCommand;
      function IsValid: Boolean;
      function SkipLoop: IBFSource;
      function RestartLoop: IBFSource;
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
     if FIdx = LongWord(FCells.Count)
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
     if FIdx > LongWord(FInput.Length)
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

{ TBFCommandList }

constructor TBFCommandList.Create(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String);
begin
     FCmdList := TStringList.Create;
     with FCmdList do
          begin
               Add(sMoveLeft);
               Add(sMoveRight);
               Add(sAdd);
               Add(sSub);
               Add(sWrite);
               Add(sRead);
               Add(sLoopStart);
               Add(sLoopStop);
          end;
     FTokenSize := sMoveLeft.Length;
end;

destructor TBFCommandList.Destroy;
begin
     FCmdList.Free;
     inherited;
end;

function TBFCommandList.Item(Idx: Byte): TBFCommand;
begin
     Result := TBFCommand(Idx);
end;

function TBFCommandList.Item(Token: String): TBFCommand;
begin
     Result := TBFCommand(FCmdList.IndexOf(Token));
end;

class function TBFCommandList.New(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart,
  sLoopStop: String): IBFCommandList;
begin
     Result := Create(sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop);
end;

function TBFCommandList.TokenSize: Byte;
begin
     Result := FTokenSize;
end;

{ TBFSource }

function TBFSource.Cmd: TBFCommand;
begin
     Result := FCmdList.Item(Token(FIdx));
     Inc(FIdx, FCmdList.TokenSize);
end;

constructor TBFSource.Create(CmdList: IBFCommandList; Source: String);
begin
     FCmdList := CmdList;
     FSource  := StringReplace(Source, ' ', '', [rfReplaceAll]);
     FIdx     := 1;
end;

function TBFSource.IsValid: Boolean;
begin
     Result := FIdx <= LongWord(FSource.Length);
end;

class function TBFSource.New(CmdList: IBFCommandList; Source: String): IBFSource;
begin
     Result := Create(CmdList, Source);
end;

function TBFSource.RestartLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     i     := FIdx-(2 * FCmdList.TokenSize);
     while i>=Low(FSource) do
           begin
                if FCmdList.Item(Token(i)) = bfLoopStop
                   then Inc(Count);
                if (FCmdList.Item(Token(i)) = bfLoopStart) and (Count = 0)
                   then begin
                             Pair := i;
                             Break;
                        end;
                Dec(i, FCmdList.TokenSize);
           end;
     if Pair = -1
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d ends without starting.', [FIdx]));
     FIdx := Pair + FCmdList.TokenSize;
end;

function TBFSource.SkipLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     i     := FIdx + FCmdList.TokenSize;
     while i <= High(FSource) do
           begin
                if FCmdList.Item(Token(i)) = bfLoopStart
                   then Inc(Count);
                if (FCmdList.Item(Token(i)) = bfLoopStop) and (Count = 0)
                   then begin
                             Pair := i;
                             Break;
                        end;
                Inc(i, FCmdList.TokenSize);
           end;
     if Pair = 0
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d has no end.', [FIdx]));
     FIdx := Pair + FCmdList.TokenSize;
end;

function TBFSource.Token(Idx: LongWord = 0): String;
begin
     if Idx = 0
        then Idx := FIdx;
     Result := Copy(FSource, Idx, FCmdList.TokenSize);
end;

end.
