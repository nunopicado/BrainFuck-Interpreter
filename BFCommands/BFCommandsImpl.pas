unit BFCommandsImpl;

interface

uses
    BFCommandsIntf
  , Classes
  ;

type
    TBFCommandList = Class(TInterfacedObject, IBFCommandList)
    strict private
      FCmdList   : TStringList;
      FTokenSize : Byte;
    public
      constructor Create(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String);
      destructor Destroy; Override;
      class function New(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String): IBFCommandList;
      function TokenSize           : Byte;
      function Item(Idx: Byte)     : TBFCommandSet; Overload;
      function Item(Token: String) : TBFCommandSet; Overload;
    End;

implementation

uses
    SysUtils
  ;

{ TBFCommandList }

constructor TBFCommandList.Create(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String);
begin
     FCmdList := TStringList.Create;
     with FCmdList do
          begin
               Add(sMoveLeft);
               Add(sMoveRight);
               Add(sAdd);
               Add(sSub);
               Add(sWrite);
               Add(sRead);
               Add(sLoopStart);
               Add(sLoopStop);
          end;
     FTokenSize := sMoveLeft.Length;
end;

destructor TBFCommandList.Destroy;
begin
     FCmdList.Free;
     inherited;
end;

function TBFCommandList.Item(Idx: Byte): TBFCommandSet;
begin
     Result := TBFCommandSet(Idx);
end;

function TBFCommandList.Item(Token: String): TBFCommandSet;
begin
     Result := TBFCommandSet(FCmdList.IndexOf(Token));
end;

class function TBFCommandList.New(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart,
  sLoopStop: String): IBFCommandList;
begin
     Result := Create(sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop);
end;

function TBFCommandList.TokenSize: Byte;
begin
     Result := FTokenSize;
end;

end.
