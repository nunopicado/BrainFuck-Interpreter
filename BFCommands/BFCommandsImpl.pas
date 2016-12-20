unit BFCommandsImpl;

interface

uses
    BFCommandsIntf
  , Classes
  ;

type
    TCommandList = Class(TInterfacedObject, ICommandList)
    strict private
      FCmdList   : TStringList;
      FTokenSize : Byte;
    public
      constructor Create(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String);
      destructor Destroy; Override;
      class function New(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String): ICommandList;
      function TokenSize           : Byte;
      function Item(Idx: Byte)     : TCommandSet; Overload;
      function Item(Token: String) : TCommandSet; Overload;
    End;

implementation

uses
    SysUtils
  ;

{ TBFCommandList }

constructor TCommandList.Create(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop: String);
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

destructor TCommandList.Destroy;
begin
     FCmdList.Free;
     inherited;
end;

function TCommandList.Item(Idx: Byte): TCommandSet;
begin
     Result := TCommandSet(Idx);
end;

function TCommandList.Item(Token: String): TCommandSet;
begin
     Result := TCommandSet(FCmdList.IndexOf(Token));
end;

class function TCommandList.New(const sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart,
  sLoopStop: String): ICommandList;
begin
     Result := Create(sMoveLeft, sMoveRight, sAdd, sSub, sWrite, sRead, sLoopStart, sLoopStop);
end;

function TCommandList.TokenSize: Byte;
begin
     Result := FTokenSize;
end;

end.
