unit model.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, model.crud;

type

  { TModelConfig }

  TModelConfig = class(TModelCRUD)
    public
      constructor Create;
      procedure CreateConfigTable;
      function GetConfig(AConfig: String; Global: Boolean): String;
      procedure SetConfig(AConfig: String; AValue: String; Global: Boolean);
      function Connected(ACache: Boolean): Boolean;
  end;

implementation

{ TModelConfig }

procedure TModelConfig.CreateConfigTable;
begin

  // Cria a tabela de configuração no cache
  if not TableExists('config', true) then
  begin
    SQL.Clear;
    SQL.Add('CREATE TABLE "config" (');
    SQL.Add('"id"	INTEGER NOT NULL UNIQUE,');
    SQL.Add('"nome"	TEXT NOT NULL,');
    SQL.Add('"valor"	TEXT NOT NULL,');
    SQL.Add('PRIMARY KEY("id"));');
    StartTransaction(true);
    ExecuteDirect(SQL, true);
    SQL.Clear;
    SQL.Add('CREATE UNIQUE INDEX "idx_config" ON "config" (');
    SQL.Add('"nome");');
    ExecuteDirect(SQL, true);
    Commit(true);
  end;
  if not TableExists('config', false) then
  begin
    SQL.Clear;
    SQL.Add('CREATE TABLE CONFIG (');
    SQL.Add('ID     INTEGER NOT NULL,');
    SQL.Add('NOME   VARCHAR(255) NOT NULL,');
    SQL.Add('VALOR  VARCHAR(1000) NOT NULL);');
    StartTransaction();
    ExecuteDirect(SQL);
    SQL.Clear;
    SQL.Add('ALTER TABLE CONFIG ADD CONSTRAINT PK_CONFIG PRIMARY KEY (ID);');
    ExecuteDirect(SQL);
    SQL.Clear;
    SQL.Add('CREATE UNIQUE INDEX CONFIG_IDX1 ON CONFIG (NOME);');
    ExecuteDirect(SQL);
    Commit();
  end;

end;

constructor TModelConfig.Create;
begin
  inherited;
end;

function TModelConfig.GetConfig(AConfig: String; Global: Boolean): String;
begin

  if not Global then
    Result := Search('config', 'valor', 'where nome = :nome', [AConfig], '', true)
  else
    Result := Search('config', 'valor', 'where nome = :nome', [AConfig], '');

end;

procedure TModelConfig.SetConfig(AConfig: String; AValue: String;
  Global: Boolean);
begin

  if not Global then
  begin
    StartTransaction(true);
    try
      Insert('config', 'id = :id, nome = :nome, valor = :valor',
        [GetNextID('config', 'id', true), AConfig, AValue], true);
      Commit(true);
    except
      on E: Exception do
      begin
        RollBack(true);
        raise Exception.Create('Ocorreu uma falha ao salvar a configuração no cache. ' + E.Message);
      end;
    end;
  end else begin
    StartTransaction();
    try
      Insert('config', 'id = :id, nome = :nome, valor = :valor',
        [GetNextID('config', 'id', true), AConfig, AValue]);
      Commit();
    except
      on E: Exception do
      begin
        RollBack();
        raise Exception.Create('Ocorreu uma falha ao salvar a configuração glogal. ' + E.Message);
      end;
    end;
  end;

end;

function TModelConfig.Connected(ACache: Boolean): Boolean;
begin
  Result := DatabaseConnected(ACache);
end;

end.

