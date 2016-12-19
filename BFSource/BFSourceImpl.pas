unit BFSourceImpl;

interface

uses
    BFCommandsIntf
  , BFSourceIntf
  ;

type
    TBFSource = Class(TInterfacedObject, IBFSource)
    strict private // Fields
      FCmdList : IBFCommandList;
      FSource  : String;
      FIdx     : Integer;
    strict private // Methods
      function Token(Idx: Integer): String;
    public
      constructor Create(CmdList: IBFCommandList; Source: String);
      class function New(CmdList: IBFCommandList; Source: String): IBFSource;
      class function NewBrainFuck(Source: String): IBFSource;
      class function NewOok(Source: String): IBFSource;
      class function NewMorseFuck(Source: String): IBFSource;
      class function NewBitFuck(Source: String): IBFSource;
      function Cmd: TBFCommandSet;
      function IsValid: Boolean;
      function SkipLoop: IBFSource;
      function RestartLoop: IBFSource;
    End;

implementation

uses
    SysUtils
  , Classes
  , BFCommandsImpl
  ;

{ TBFSource }

function TBFSource.Cmd: TBFCommandSet;
begin
     Repeat
           Result := FCmdList.Item(Token(FIdx));
           if Result = bfInvalid
              then Delete(FSource, FIdx, 1)
     Until (not IsValid) or (Result <> bfInvalid);
     Inc(FIdx, FCmdList.TokenSize);
end;

constructor TBFSource.Create(CmdList: IBFCommandList; Source: String);
begin
     FCmdList := CmdList;
     FSource  := Source;
     FIdx     := 1;
end;

function TBFSource.IsValid: Boolean;
begin
     Result := FIdx <= FSource.Length;
end;

class function TBFSource.New(CmdList: IBFCommandList; Source: String): IBFSource;
begin
     Result := Create(CmdList, Source);
end;

class function TBFSource.NewBitFuck(Source: String): IBFSource;
begin
     Result := New(
                   TBFCommandList.New('000', '001', '010', '011', '100', '101', '110', '111'),
                   Source
                  );
end;

class function TBFSource.NewBrainFuck(Source: String): IBFSource;
begin
     Result := New(
                   TBFCommandList.New('<', '>', '+', '-', '.', ',', '[', ']' ),
                   Source
                  );
end;

class function TBFSource.NewMorseFuck(Source: String): IBFSource;
begin
     Result := New(
                   TBFCommandList.New('--.', '.--', '..-', '-..', '-.-', '.-.', '---', '...'),
                   Source
                  );
end;

class function TBFSource.NewOok(Source: String): IBFSource;
begin
     Result := New(
                   TBFCommandList.New('Ook?Ook.', 'Ook.Ook?', 'Ook.Ook.', 'Ook!Ook!', 'Ook!Ook.', 'Ook.Ook!', 'Ook!Ook?', 'Ook?Ook!'),
                   StringReplace(Source, ' ', '', [rfReplaceAll])
                  );
end;

function TBFSource.RestartLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     i     := FIdx-(2 * FCmdList.TokenSize);
     while i>=Low(FSource) do
           begin
                if FCmdList.Item(Token(i)) = bfLoopStop
                   then Inc(Count);
                if (FCmdList.Item(Token(i)) = bfLoopStart)
                   then if Count = 0
                           then begin
                                     Pair := i;
                                     Break;
                                end
                           else Dec(Count);
                Dec(i, FCmdList.TokenSize);
           end;
     if Pair = -1
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d ends without starting.', [FIdx]));
     FIdx := Pair + FCmdList.TokenSize;
end;

function TBFSource.SkipLoop: IBFSource;
var
   i, Count, Pair: Integer;
begin
     Pair  := 0;
     Count := 0;
     i     := FIdx;
     while i <= High(FSource) do
           begin
                if FCmdList.Item(Token(i)) = bfLoopStart
                   then Inc(Count);
                if (FCmdList.Item(Token(i)) = bfLoopStop)
                   then if Count = 0
                           then begin
                                     Pair := i;
                                     Break;
                                end
                           else Dec(Count);
                Inc(i, FCmdList.TokenSize);
           end;
     if Pair = 0
        then raise EInvalidOperation.Create(Format('Invalid Operation: Loop at %d has no end.', [FIdx]));
     FIdx := Pair + FCmdList.TokenSize;
end;

function TBFSource.Token(Idx: Integer): String;
begin
     Result := Copy(FSource, Idx, FCmdList.TokenSize);
end;

end.
