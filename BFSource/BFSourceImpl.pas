unit BFSourceImpl;

interface

uses
    BFCommandsIntf
  , BFSourceIntf
  ;

type
    TSource = Class(TInterfacedObject, ISource)
    strict private // Fields
      FCmdList : ICommandList;
      FSource  : String;
      FIdx     : Integer;
    strict private // Methods
      function Token(Idx: Integer): String;
    public
      constructor Create(CmdList: ICommandList; Source: String);
      class function New(CmdList: ICommandList; Source: String): ISource;
      class function NewBrainFuck(Source: String): ISource;
      class function NewOok(Source: String): ISource;
      class function NewMorseFuck(Source: String): ISource;
      class function NewBitFuck(Source: String): ISource;
      function Cmd: TCommandSet;
      function IsValid: Boolean;
      function SkipLoop: ISource;
      function RestartLoop: ISource;
    End;

implementation

uses
    SysUtils
  , Classes
  , BFCommandsImpl
  ;

{ TBFSource }

function TSource.Cmd: TCommandSet;
begin
     Repeat
           Result := FCmdList.Item(Token(FIdx));
           if Result = bfInvalid
              then Delete(FSource, FIdx, 1)
     Until (not IsValid) or (Result <> bfInvalid);
     Inc(FIdx, FCmdList.TokenSize);
end;

constructor TSource.Create(CmdList: ICommandList; Source: String);
begin
     FCmdList := CmdList;
     FSource  := Source;
     FIdx     := 1;
end;

function TSource.IsValid: Boolean;
begin
     Result := FIdx <= FSource.Length;
end;

class function TSource.New(CmdList: ICommandList; Source: String): ISource;
begin
     Result := Create(CmdList, Source);
end;

class function TSource.NewBitFuck(Source: String): ISource;
begin
     Result := New(
                   TCommandList.New('000', '001', '010', '011', '100', '101', '110', '111'),
                   Source
                  );
end;

class function TSource.NewBrainFuck(Source: String): ISource;
begin
     Result := New(
                   TCommandList.New('<', '>', '+', '-', '.', ',', '[', ']' ),
                   Source
                  );
end;

class function TSource.NewMorseFuck(Source: String): ISource;
begin
     Result := New(
                   TCommandList.New('--.', '.--', '..-', '-..', '-.-', '.-.', '---', '...'),
                   Source
                  );
end;

class function TSource.NewOok(Source: String): ISource;
begin
     Result := New(
                   TCommandList.New('Ook?Ook.', 'Ook.Ook?', 'Ook.Ook.', 'Ook!Ook!', 'Ook!Ook.', 'Ook.Ook!', 'Ook!Ook?', 'Ook?Ook!'),
                   StringReplace(Source, ' ', '', [rfReplaceAll])
                  );
end;

function TSource.RestartLoop: ISource;
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

function TSource.SkipLoop: ISource;
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

function TSource.Token(Idx: Integer): String;
begin
     Result := Copy(FSource, Idx, FCmdList.TokenSize);
end;

end.
