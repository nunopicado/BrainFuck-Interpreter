unit BFInputImpl;

interface

uses
    BFInputIntf
  ;

type
    TBFInput = Class(TInterfacedObject, IBFInput)
    strict private
      FInput : String;
      FIdx   : Integer;
    public
      constructor Create(InputChain: String);
      class function New(InputChain: String): IBFInput;
      function Value : Byte;
      function Count : Integer;
    End;

implementation

uses
    SysUtils
  ;

{ TBFInput }

function TBFInput.Count: Integer;
begin
     Result := FInput.Length;
end;

constructor TBFInput.Create(InputChain: String);
begin
     FInput := InputChain;
end;

class function TBFInput.New(InputChain: String): IBFInput;
begin
     Result := Create(InputChain);
end;

function TBFInput.Value: Byte;
begin
     Inc(FIdx);
     if FIdx > FInput.Length
        then raise EInOutError.Create('Invalid operation: Input queue has no more data.');
     Result := Ord(FInput[FIdx]);
end;

end.
