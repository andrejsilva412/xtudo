unit controller.log;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.crud;

type

  { TLog }

  TLog = class(TControllerCRUD)
    private
      FDate: TDateTime;
      FDescricao: String;
      FID: Integer;
    public
      function Post: Integer; override;
      property ID: Integer read FID;
      property Date: TDateTime read FDate;
      property Descricao: String read FDescricao write FDescricao;
  end;

implementation

uses model.log;

{ TLog }

function TLog.Post: Integer;
var
  MLog: TModelLog;
begin

  MLog := TModelLog.Create;
  try
    MLog.Post(Self);
  finally
    FreeAndNil(MLog);
  end;

end;

end.

