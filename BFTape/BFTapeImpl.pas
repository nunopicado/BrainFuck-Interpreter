unit BFTapeImpl;

interface

uses
    Generics.Collections
  , BFTapeIntf
  ;

type
    TTapeCell = Class(TInterfacedObject, ITapeCell)
    strict private
      FCell : Byte;
    public
      class function New              : ITapeCell;
      function Add                    : ITapeCell;
      function Sub                    : ITapeCell;
      function Value                  : Byte;
      function Define(NewValue: Byte) : ITapeCell;
    End;

    TTapeCellFactory = Reference to Function: ITapeCell;
    TTape = Class(TInterfacedObject, ITape)
    strict private
      FCellFactory : TTapeCellFactory;
      FCells       : TList<ITapeCell>;
      FIdx         : Integer;
    public
      constructor Create(CellFactory: TTapeCellFactory);
      destructor Destroy; Override;
      class function New(CellFactory: TTapeCellFactory): ITape;
      function Cell      : ITapeCell;
      function MoveLeft  : ITape;
      function MoveRight : ITape;
      function AsString  : String;
    End;

implementation

uses
    SysUtils
  ;

{ TBFCell }

function TTapeCell.Add: ITapeCell;
begin
     Result := Self;
     Inc(FCell);
end;

function TTapeCell.Define(NewValue: Byte): ITapeCell;
begin
     Result := Self;
     FCell  := NewValue;
end;

class function TTapeCell.New: ITapeCell;
begin
     Result := Create;
end;

function TTapeCell.Sub: ITapeCell;
begin
     Result := Self;
     Dec(FCell);
end;

function TTapeCell.Value: Byte;
begin
     Result := FCell;
end;

{ TTape }

function TTape.AsString: String;
var
   Cell: ITapeCell;
begin
     Result := '';
     for Cell in FCells do
         Result := Result + Chr(Cell.Value);
end;

function TTape.Cell: ITapeCell;
begin
     Result := FCells[FIdx];
end;

constructor TTape.Create(CellFactory: TTapeCellFactory);
begin
     FCells       := TList<ITapeCell>.Create;
     FCellFactory := CellFactory;
     FCells.Add(FCellFactory);
end;

destructor TTape.Destroy;
begin
     FCells.Free;
     inherited;
end;

function TTape.MoveLeft: ITape;
begin
     if FIdx = 0
        then raise EInvalidOp.Create('Invalid operation: Already in the leftmost position.');

     Result := Self;
     Dec(FIdx);
end;

function TTape.MoveRight: ITape;
begin
     Result := Self;
     Inc(FIdx);
     if FIdx = FCells.Count
        then FCells.Add(FCellFactory);
end;

class function TTape.New(CellFactory: TTapeCellFactory): ITape;
begin
     Result := Create(CellFactory);
end;

end.
