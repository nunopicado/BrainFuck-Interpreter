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
      class function New               : ITapeCell;
      function Add(Times: Integer = 1) : ITapeCell;
      function Sub(Times: Integer = 1) : ITapeCell;
      function Value                   : Byte;
      function Define(Value: Byte)     : ITapeCell;
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
      class function New(CellFactory: TTapeCellFactory) : ITape;
      function Cell                                     : ITapeCell;
      function MoveLeft(Times: Integer = 1)             : ITape;
      function MoveRight(Times: Integer = 1)            : ITape;
      function AsString                                 : String;
    End;

implementation

uses
    SysUtils
  ;

{ TTapeCell }

function TTapeCell.Add(Times: Integer = 1): ITapeCell;
begin
     Result := Self;
     Inc(FCell, Times);
end;

function TTapeCell.Define(Value: Byte): ITapeCell;
begin
     Result := Self;
     FCell  := Value;
end;

class function TTapeCell.New: ITapeCell;
begin
     Result := Create;
end;

function TTapeCell.Sub(Times: Integer = 1): ITapeCell;
begin
     Result := Self;
     Dec(FCell, Times);
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

function TTape.MoveLeft(Times: Integer = 1): ITape;
begin
     if FIdx-Times < 0
        then raise EInvalidOp.Create('Invalid operation: Already in the leftmost position.');
     Result := Self;
     Dec(FIdx, Times);
end;

function TTape.MoveRight(Times: Integer = 1): ITape;
begin
     Result := Self;
     Inc(FIdx, Times);
     while FIdx > Pred(FCells.Count) do
           FCells.Add(FCellFactory);
end;

class function TTape.New(CellFactory: TTapeCellFactory): ITape;
begin
     Result := Create(CellFactory);
end;

end.
