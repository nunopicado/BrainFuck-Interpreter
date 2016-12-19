unit BFOutputImpl;

interface

uses
    Generics.Collections
  , BFOutputIntf
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
      FIdx   : Integer;
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

{ TBFCell }

function TBFCell.Add: IBFCell;
begin
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

end.
