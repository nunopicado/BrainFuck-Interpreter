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

    TTapeCellFactory = Class(TInterfacedObject, ITapeCellFactory)
    public
      class function New : ITapeCellFactory;
      function NewCell   : ITapeCell;
    End;

    TTape = Class(TInterfacedObject, ITape)
    strict private
      FCellFactory : ITapeCellFactory;
      FCells       : TList<ITapeCell>;
      FIdx         : Integer;
    public
      constructor Create(CellFactory: ITapeCellFactory);
      destructor Destroy; Override;
      class function New(CellFactory: ITapeCellFactory) : ITape;
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

{ TBFStack }

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

constructor TTape.Create(CellFactory: ITapeCellFactory);
begin
     FCells       := TList<ITapeCell>.Create;
     FCellFactory := CellFactory;
     FCells.Add(FCellFactory.NewCell);
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
        then FCells.Add(FCellFactory.NewCell);
end;

class function TTape.New(CellFactory: ITapeCellFactory): ITape;
begin
     Result := Create(CellFactory);
end;

{ TBFCellFactory }

class function TTapeCellFactory.New: ITapeCellFactory;
begin
     Result := Create;
end;

function TTapeCellFactory.NewCell: ITapeCell;
begin
     Result := TTapeCell.New;
end;

end.
