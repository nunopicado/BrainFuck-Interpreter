unit OOKParser;

interface

uses
    SysUtils
  , BFStackIntf
  ;

type
    TOOKSource = Class(TInterfacedObject, IBFSource)
    strict private // Constants
      const
           TokenSize  = 10;
           cLeft      = 'Ook? Ook. ';
           cRight     = 'Ook. Ook? ';
           cAdd       = 'Ook. Ook. ';
           cSub       = 'Ook! Ook! ';
           cWrite     = 'Ook! Ook. ';
           cRead      = 'Ook. Ook! ';
           cLoopStart = 'Ook! Ook? ';
           cLoopStop  = 'Ook? Ook! ';
    strict private // Fields
      FSource : String;
      FIdx    : LongWord;
    strict private
      function Token(Idx: LongWord = 0): String;
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

function TOOKSource.Cmd: TBFCommand;
begin
     if Token(FIdx) = cLeft
        then Result := bfLeft;
     if Token(FIdx) = cRight
        then Result := bfRight;
     if Token(FIdx) = cAdd
        then Result := bfAdd;
     if Token(FIdx) = CSub
        then Result := bfSub;
     if Token(FIdx) = cWrite
        then Result := bfWrite;
     if Token(FIdx) = cRead
        then Result := bfRead;
     if Token(FIdx) = cLoopStart
        then Result := bfLoopStart;
     if Token(FIdx) = cLoopStop
        then Result := bfLoopStop;
     Inc(FIdx, TokenSize);
end;

constructor TOOKSource.Create(Source: String);
begin
     FSource := Source;
     FIdx    := 1;
end;

function TOOKSource.IsValid: Boolean;
begin
     Result := FIdx <= FSource.Length;
end;

class function TOOKSource.New(Source: String): IBFSource;
begin
     Result := Create(Source);
end;

function TOOKSource.RestartLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     i     := FIdx-(2 * TokenSize);
     while i>=Low(FSource) do
           begin
                if (i mod TokenSize) = 1
                   then begin
                             if Token(i) = cLoopStop
                                then Inc(Count);
                             if (Token(i) = cLoopStart) and (Count = 0)
                                then begin
                                          Pair := i;
                                          Break;
                                     end;
                        end;
                Dec(i, TokenSize);
           end;
     if Pair = -1
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d ends without starting.', [FIdx]));
     FIdx := Pair + TokenSize;
end;

function TOOKSource.SkipLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     i     := FIdx + TokenSize;
     while i <= High(FSource) do
           begin
                if Token(i) = cLoopStart
                   then Inc(Count);
                if (Token(i) = cLoopStop) and (Count = 0)
                   then begin
                             Pair := i;
                             Break;
                        end;
                Inc(i, TokenSize);
           end;
     if Pair = 0
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d has no end.', [FIdx]));
     FIdx := Pair + TokenSize;
end;

function TOOKSource.Token(Idx: LongWord = 0): String;
begin
     if Idx = 0
        then Idx := FIdx;
     Result := Copy(FSource, Idx, TokenSize);
end;

end.
