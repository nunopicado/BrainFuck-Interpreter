unit BFParser;

interface

uses
    SysUtils
  , BFStackIntf
  ;

type
    TBFSource = Class(TInterfacedObject, IBFSource)
    strict private // Constants
      const
           cLeft      = '<';
           cRight     = '>';
           cAdd       = '+';
           cSub       = '-';
           cWrite     = '.';
           cRead      = ',';
           cLoopStart = '[';
           cLoopStop  = ']';
    strict private // Fields
      FSource : String;
      FIdx    : LongWord;
    public
      constructor Create(Source: String);
      class function New(Source: String): IBFSource;
      function Cmd: TBFCommand;
      function IsValid: Boolean;
      function SkipLoop: IBFSource;
      function RestartLoop: IBFSource;
    End;

implementation

uses
    Classes
  ;

{ TBFSource }

function TBFSource.Cmd: TBFCommand;
begin
     case FSource[FIdx] of
          cLeft      : Result := bfLeft;
          cRight     : Result := bfRight;
          cAdd       : Result := bfAdd;
          CSub       : Result := bfSub;
          cWrite     : Result := bfWrite;
          cRead      : Result := bfRead;
          cLoopStart : Result := bfLoopStart;
          cLoopStop  : Result := bfLoopStop;
     end;
     Inc(FIdx);
end;

constructor TBFSource.Create(Source: String);
begin
     FSource := Source;
     FIdx    := 1;
end;

function TBFSource.IsValid: Boolean;
begin
     Result := FIdx <= FSource.Length;
end;

class function TBFSource.New(Source: String): IBFSource;
begin
     Result := Create(Source);
end;

function TBFSource.RestartLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     for i := FIdx-2 downto Low(FSource) do
         begin
              if FSource[i] = cLoopStop
                 then Inc(Count);
              if (FSource[i] = cLoopStart) and (Count = 0)
                 then begin
                           Pair := i;
                           Break;
                      end;
         end;
     if Pair = -1
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d ends without starting.', [FIdx]));
     FIdx := Pair + 1;
end;

function TBFSource.SkipLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     for i := FIdx+1 to High(FSource) do
         begin
              if FSource[i] = cLoopStart
                 then Inc(Count);
              if (FSource[i] = cLoopStop) and (Count = 0)
                 then begin
                           Pair := i;
                           Break;
                      end;
         end;
     if Pair = 0
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d has no end.', [FIdx]));
     FIdx := Pair + 1;
end;

end.
