unit controller.log;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Forms, SysUtils, controller.crud;

type

  { TLog }

  TLog = class(TControllerCRUD)
    private
      FDate: TDateTime;
      FDescricao: String;
      FID: Integer;
    public
      function Post: Integer; override;
      procedure OnException(Sender: TObject; E: Exception);
      property ID: Integer read FID;
      property Date: TDateTime read FDate;
      property Descricao: String read FDescricao write FDescricao;
  end;

implementation

uses model.log;

{ TLog }

procedure TLog.OnException(Sender: TObject; E: Exception);
begin
  // Teste
end;

function TLog.Post: Integer;
var
  MLog: TModelLog;
begin

  MLog := TModelLog.Create;
  try
    Result := MLog.Post(Self);
  finally
    FreeAndNil(MLog);
  end;

  Application.OnException := @OnException;

end;

end.

