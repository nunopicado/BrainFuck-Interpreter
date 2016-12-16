unit uStack;

interface

uses
    Generics.Collections
  ;

type
    ICell = Interface ['{68191C4D-9539-4730-B4AB-3C423145376C}']
      function Add  : ICell;
      function Sub  : ICell;
      function Value: Word;
      function Define(NewValue: Word): ICell;
    End;

    IStack = Interface ['{0149AEDA-BF0B-481C-9227-C8710CDC2AAF}']
      function Cell      : ICell;
      function MoveLeft  : IStack;
      function MoveRight : IStack;
    End;

    TCell = Class(TInterfacedObject, ICell)
    private
      FCell: Word;
    public
      class function New: ICell;
      function Add  : ICell;
      function Sub  : ICell;
      function Value: Word;
      function Define(NewValue: Word): ICell;
    End;

    TStack = Class(TInterfacedObject, IStack)
    private
      FList: TList<ICell>;
      FIndex: LongWord;
    public
      constructor Create;
      class function New: IStack;
      function Cell      : ICell;
      function MoveLeft  : IStack;
      function MoveRight : IStack;
    End;

implementation

uses
    SysUtils
  ;

{ TCell }

function TCell.Add: ICell;
begin
     Result := Self;
     Inc(FCell);
end;

function TCell.Define(NewValue: Word): ICell;
begin
     Result := Self;
     FCell  := NewValue;
end;

class function TCell.New: ICell;
begin
     Result := Create;
end;

function TCell.Sub: ICell;
begin
     Result := Self;
     Dec(FCell);
end;

function TCell.Value: Word;
begin
     Result := FCell;
end;

{ TStack }

function TStack.Cell: ICell;
begin
     Result := FList[FIndex];
end;

constructor TStack.Create;
begin
     FList  := TList<ICell>.Create;
     FList.Add(TCell.New);
end;

function TStack.MoveLeft: IStack;
begin
     if FIndex = 0
        then raise EInvalidOp.Create('Invalid Operation: Left when position = 0');

     Result := Self;
     Dec(FIndex);
end;

function TStack.MoveRight: IStack;
begin
     Result := Self;
     Inc(FIndex);
     if FIndex = FList.Count
        then FList.Add(TCell.New);
end;

class function TStack.New: IStack;
begin
     Result := Create;
end;

end.
