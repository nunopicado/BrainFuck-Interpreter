unit BFInputImpl;

interface

uses
    BFInputIntf
  ;

type
    TBFInput = Class(TInterfacedObject, IBFInput)
    strict private
      FInput: String;
      FIdx: LongWord;
    public
      constructor Create(InputChain: String);
      class function New(InputChain: String): IBFInput;
      function Value: Byte;
    End;

implementation

uses
    SysUtils
  ;

{ TBFInput }

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
     if FIdx > LongWord(FInput.Length)
        then raise EInOutError.Create('Invalid operation: Input queue has no more data.');
     Result := Ord(FInput[FIdx]);
end;

end.
