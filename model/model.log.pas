unit model.log;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, model.crud;

  type

    { TModelLog }

    TModelLog = class(TModelCRUD)
      private
         FTableLog: String;
         procedure CreateLogTable;
      protected
        function GetNextID: Integer; overload;
      public
        constructor Create;
        procedure Post(const msg: String; AErrorCode: Integer);
    end;

implementation

{ TModelLog }

procedure TModelLog.CreateLogTable;
begin
  if not TableExists(FTableLog, true) then
  begin
    SQL.Clear;
    SQL.Add('CREATE TABLE "log" (');
    SQL.Add('"id"	INTEGER NOT NULL UNIQUE,');
    SQL.Add('"data"	TEXT NOT NULL,');
    SQL.Add('"errorcode"	INTEGER NOT NULL,');
    SQL.Add('"descricao"	TEXT NOT NULL,');
    SQL.Add('PRIMARY KEY("id"));');
    // Cria a tabela Log
    StartTransaction(true);
    ExecuteDirect(SQL, true);
    SQL.Clear;
    SQL.Add('CREATE INDEX idx_errorcode ON log (errorcode);');
    ExecuteDirect(SQL, true);
    Commit(true);
  end;
end;

function TModelLog.GetNextID: Integer;
begin
  Result := inherited GetNextID(FTableLog, 'id', true);
end;

constructor TModelLog.Create;
begin

  inherited;
  FTableLog := 'log';
  CreateLogTable;

end;

procedure TModelLog.Post(const msg: String; AErrorCode: Integer);
var
  lID: Integer;
begin

  StartTransaction(true);
  try
    lID := GetNextID;
    Inherited Insert(FTableLog, 'id = :id, data = :data, '
      + 'errorcode = :errorcode, descricao = :descricao', [lID,
        DateTimeToCacheDateTime(Date), AErrorCode, msg], true);
    Commit(true);
  except
    on E: Exception do
    begin
      RollBack(true);
    end;
  end;

end;

end.

