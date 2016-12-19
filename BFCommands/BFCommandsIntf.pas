unit BFCommandsIntf;

interface

type
    TBFCommandSet  = (bfInvalid=-1, bfLeft=0, bfRight, bfAdd, bfSub, bfWrite, bfRead, bfLoopStart, bfLoopStop);

    IBFCommandList = Interface ['{DE71F770-9527-4AFA-BCC6-F857AAEE229C}']
      function TokenSize           : Byte;
      function Item(Idx: Byte)     : TBFCommandSet; Overload;
      function Item(Token: String) : TBFCommandSet; Overload;
    End;

implementation

end.
