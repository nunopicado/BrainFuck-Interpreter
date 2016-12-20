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

    TBFCellFactory = Class(TInterfacedObject, IBFCellFactory)
    public
      class function New: IBFCellFactory;
      function NewCell: IBFCell;
    End;

    TBFStack = Class(TInterfacedObject, IBFStack)
    strict private
      FCellFactory : IBFCellFactory;
      FCells       : TList<IBFCell>;
      FIdx         : Integer;
    public
      constructor Create(CellFactory: IBFCellFactory);
      destructor Destroy; Override;
      class function New(CellFactory: IBFCellFactory) : IBFStack;
      function Cell      : IBFCell;
      function MoveLeft  : IBFStack;
      function MoveRight : IBFStack;
      function AsString  : String;
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

function TBFStack.AsString: String;
var
   Cell: IBFCell;
begin
     Result := '';
     for Cell in FCells do
         Result := Result + Chr(Cell.Value);
end;

function TBFStack.Cell: IBFCell;
begin
     Result := FCells[FIdx];
end;

constructor TBFStack.Create(CellFactory: IBFCellFactory);
begin
     FCells       := TList<IBFCell>.Create;
     FCellFactory := CellFactory;
     FCells.Add(FCellFactory.NewCell);
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
        then FCells.Add(FCellFactory.NewCell);
end;

class function TBFStack.New(CellFactory: IBFCellFactory): IBFStack;
begin
     Result := Create(CellFactory);
end;

{ TBFCellFactory }

class function TBFCellFactory.New: IBFCellFactory;
begin
     Result := Create;
end;

function TBFCellFactory.NewCell: IBFCell;
begin
     Result := TBFCell.New;
end;

end.
