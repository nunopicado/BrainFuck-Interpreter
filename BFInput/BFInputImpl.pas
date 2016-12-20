unit BFInputImpl;

interface

uses
    BFInputIntf
  ;

type
    TInput = Class(TInterfacedObject, IInput)
    strict private
      FInput : String;
      FIdx   : Integer;
    public
      constructor Create(InputChain: String);
      class function New(InputChain: String): IInput;
      function Value : Byte;
      function Count : Integer;
    End;

implementation

uses
    SysUtils
  ;

{ TBFInput }

function TInput.Count: Integer;
begin
     Result := FInput.Length;
end;

constructor TInput.Create(InputChain: String);
begin
     FInput := InputChain;
end;

class function TInput.New(InputChain: String): IInput;
begin
     Result := Create(InputChain);
end;

function TInput.Value: Byte;
begin
     Inc(FIdx);
     if FIdx > FInput.Length
        then raise EInOutError.Create('Invalid operation: Input queue has no more data.');
     Result := Ord(FInput[FIdx]);
end;

end.
