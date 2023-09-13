unit usyserror;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Forms, SysUtils, uconst;

type

  { SysError }

  SysError = class(Exception)
  public
    class procedure OnException(Sender: TObject; E: Exception);
    constructor Create(const msg: string; ErrorCode: Integer);
    constructor Create(const msg: string);
  end;

implementation

uses model.log;

{ SysError }

class procedure SysError.OnException(Sender: TObject; E: Exception);
begin
  Self.Create(E.Message, C_EXCEPTION_ERROR);
end;

constructor SysError.Create(const msg: string; ErrorCode: Integer);
var
  MLog: TModelLog;
begin

  MLog := TModelLog.Create;
  try
    MLog.Post(msg, ErrorCode);
    inherited Create(msg);
  finally
    FreeAndNil(MLog);
  end;

end;

constructor SysError.Create(const msg: string);
begin
  inherited Create(msg);
end;

end.

