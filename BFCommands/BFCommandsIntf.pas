unit BFCommandsIntf;

interface

type
    TCommandSet  = (bfInvalid=-1, bfLeft=0, bfRight, bfAdd, bfSub, bfWrite, bfRead, bfLoopStart, bfLoopStop);

    ICommandList = Interface ['{DE71F770-9527-4AFA-BCC6-F857AAEE229C}']
      function TokenSize           : Byte;
      function Item(Idx: Byte)     : TCommandSet; Overload;
      function Item(Token: String) : TCommandSet; Overload;
    End;

implementation

end.
