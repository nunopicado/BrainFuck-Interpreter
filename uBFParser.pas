unit uBFParser;

interface

uses
    SysUtils
  , uStack
  , Generics.Collections
  ;

type
    IBFProgram = Interface ['{56E9D1C7-756B-4C96-9F7F-A66FE2A5BE06}']
      function Run(Input: String = ''): IBFProgram;
      function Output: String;
    End;

    TBFProgram = Class(TInterfacedObject, IBFProgram)
    private
      FSource: String;
      FOutput: String;
      FStack: IStack;
      FLoops: TList<LongWord>;
      FIndex: LongWord;
      function StartLoop: Boolean;
      function StopLoop: Boolean;
      function FindLoopStart: Integer;
      function FindLoopStop: Integer;
    public
      constructor Create(Source: String);
      class function New(Source: String): IBFProgram;
      class function NewFromFile(SourceFile: TFileName): IBFProgram;
      function Run(Input: String = ''): IBFProgram;
      function Output: String;
    End;

implementation

uses
    Classes
  , Crt32
  ;

{ TBFProgram }

constructor TBFProgram.Create(Source: String);
begin
     FLoops  := TList<LongWord>.Create;
     FSource := Source;
     FStack  := TStack.New;
end;

function TBFProgram.FindLoopStart: Integer;
var
   i, Count: Integer;
begin
     Result := -1;
     Count  := 0;
     for i := FIndex-1 downto 1 do
         begin
              if FSource[i]=']'
                 then Inc(Count);
              if (FSource[i]='[') and (Count = 0)
                 then begin
                           Result := i;
                           Break;
                      end;
         end;
     if Result = -1
        then raise EInvalidOperation.Create('Invalid Operation: Loop ends without starting.');
end;

function TBFProgram.FindLoopStop: Integer;
var
   i, Count: Integer;
begin
     Result := -1;
     Count  := 0;
     for i := FIndex+1 to Length(FSource) do
         begin
              if FSource[i]='['
                 then Inc(Count);
              if (FSource[i]=']') and (Count = 0)
                 then begin
                           Result := i;
                           Break;
                      end;
         end;
     if Result = -1
        then raise EInvalidOperation.Create('Invalid Operation: Loop has no end.');
end;

class function TBFProgram.New(Source: String): IBFProgram;
begin
     Result := Create(Source);
end;

class function TBFProgram.NewFromFile(SourceFile: TFileName): IBFProgram;
var
   Lst: TStringList;
begin
     if not FileExists(SourceFile)
        then raise EInOutError.Create(Format('%s file not found.', [SourceFile]));

     Lst := TStringList.Create;
     try
        Lst.LoadFromFile(SourceFile);
        Result := Create(Lst.Text);
     finally
        Lst.Free;
     end;
end;

function TBFProgram.Output: String;
begin
     Result := FOutput;
end;

function TBFProgram.Run(Input: String = ''): IBFProgram;
var
   InputIndex: Word;
begin
     Result     := Self;
     FIndex     := 1;
     InputIndex := 0;
     while FIndex <= Length(FSource) do
           with FStack do
                begin
                     case FSource[FIndex] of
                          '>': MoveRight;
                          '<': MoveLeft;
                          '+': Cell.Add;
                          '-': Cell.Sub;
                          '.': FOutput := FOutput + Chr(Cell.Value);
                          ',': begin
                                    Inc(InputIndex);
                                    if InputIndex > Length(Input)
                                       then raise EInOutError.Create('Invalid Operation: Missing input value');
                                    Cell.Define(Ord(Input[InputIndex]));
                               end;
                          '[': if not StartLoop
                                  then FIndex := FindLoopStop-1;
                          ']': if not StopLoop
                                  then FIndex := FindLoopStart;
                     end;
                     Inc(FIndex);
                end;
end;

function TBFProgram.StartLoop: Boolean;
begin
     FLoops.Add(FIndex);
     Result := FStack.Cell.Value <> 0;
end;

function TBFProgram.StopLoop: Boolean;
begin
     Result := FStack.Cell.Value = 0;
     if Result
        then FLoops.Delete(FLoops.Count-1);
end;


end.
