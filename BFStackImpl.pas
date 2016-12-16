unit BFStackImpl;

interface

uses
    Generics.Collections
  , BFStackIntf
  ;

type
    TCell = Class(TInterfacedObject, IBFCell)
    private
      FCell : Byte;
    public
      constructor Create(Value: Byte);
      class function New(Value: Byte=0) : IBFCell;
      function Add                      : IBFCell;
      function Sub                      : IBFCell;
      function Value                    : Byte;
      function Define(NewValue: Byte)   : IBFCell;
    End;

    TStack = Class(TInterfacedObject, IBFStack)
    private
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

implementation

uses
    SysUtils
  ;

{ TCell }

function TCell.Add: IBFCell;
begin
     Result := Self;
     Inc(FCell);
end;

constructor TCell.Create(Value: Byte);
begin
     FCell := Value;
end;

function TCell.Define(NewValue: Byte): IBFCell;
begin
     Result := Self;
     FCell  := NewValue;
end;

class function TCell.New(Value: Byte): IBFCell;
begin
     Result := Create(Value);
end;

function TCell.Sub: IBFCell;
begin
     Result := Self;
     Dec(FCell);
end;

function TCell.Value: Byte;
begin
     Result := FCell;
end;

{ TStack }

function TStack.Cell: IBFCell;
begin
     Result := FCells[FIdx];
end;

constructor TStack.Create;
begin
     FCells := TList<IBFCell>.Create;
     FCells.Add(
                TCell.New
               );
end;

destructor TStack.Destroy;
begin
     FCells.Free;
     inherited;
end;

function TStack.MoveLeft: IBFStack;
begin
     if FIdx = 0
        then raise EInvalidOp.Create('Invalid Operation: Left when position = 0');

     Result := Self;
     Dec(FIdx);
end;

function TStack.MoveRight: IBFStack;
begin
     Result := Self;
     Inc(FIdx);
     if FIdx = FCells.Count
        then FCells.Add(
                        TCell.New
                       );
end;

class function TStack.New: IBFStack;
begin
     Result := Create;
end;

end.
