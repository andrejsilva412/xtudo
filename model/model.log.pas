unit model.log;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, model.crud, controller.log;

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
        function Post(ALog: TLog): Integer;
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
    SQL.Add('"descricao"	TEXT NOT NULL,');
    SQL.Add('PRIMARY KEY("id"));');
    // Cria a tabela Log
    StartTransaction(true);
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

function TModelLog.Post(ALog: TLog): Integer;
var
  ID: Integer;
begin

  StartTransaction(true);
  try
    ID := GetNextID;
    Result := Inherited Insert(FTableLog, 'id = :id, data = :data, '
      + 'descricao = :descricao', [ID,
        DateTimeToCacheDateTime(Date), ALog.Descricao], true);
    Commit(true);
  except
    on E: Exception do
    begin
      RollBack(true);
      raise Exception.Create(E.Message);
    end;
  end;

end;

end.

