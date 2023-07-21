unit model.database;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, sqldb, BufDataset, IBConnection, model.sqldb;

type

  { TModelDataBase }

  TModelDataBase = class(TModelSQLDB)
    private
      FDataBase: TIBConnection;
      FTransact: TSQLTransaction;
      procedure BeforeConnect(Sender: TObject);
    protected
      procedure StartTransaction;
      procedure Commit;
      procedure RollBack;
      procedure CloseDB;
      procedure Insert(ATable, AFields: String; AParams: array of Variant);
      function Delete(ATable, ACondicao: String; AParams: array of Variant): Integer;
      function GetID: String;
      function Update(ATable, AFields, Acondicao: String; AParams: array of Variant): Integer;
      function Select(ATable, AFields, ACondicao: String;
        AParams: array of Variant; ACount: String; AFieldCount: String;
        APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset): Integer; overload;
    public
      function Connected: Boolean;
      constructor Create;
      destructor Destroy; override;
  end;

implementation

uses ustrutils, controller.config;

{ TModelDataBase }

procedure TModelDataBase.BeforeConnect(Sender: TObject);
var
  Config: TConfig;
begin

  Config := TConfig.Create;
  try
    FDataBase.DatabaseName := Config.Database.DatabaseName;
    FDataBase.CheckTransactionParams := Config.Database.CheckTransaction;
    FDataBase.Dialect := 3;
    FDataBase.HostName := Config.Database.HostName;
    FDataBase.Params.Assign(Config.Database.Params);
    FDataBase.Password := Config.Database.Password;
    FDataBase.Port := Config.Database.Port;
    FDataBase.UserName := Config.Database.Username;
  finally
    FreeAndNil(Config);
  end;

end;

procedure TModelDataBase.StartTransaction;
begin
  if not FDataBase.Transaction.Active then
    FDataBase.Transaction.Active := true;
end;

function TModelDataBase.Connected: Boolean;
begin
  Result := FDataBase.Connected;
end;

procedure TModelDataBase.Commit;
begin
  FDataBase.Transaction.Commit;
end;

procedure TModelDataBase.RollBack;
begin
  FDataBase.Transaction.Rollback;
end;

procedure TModelDataBase.CloseDB;
begin
  FDataBase.CloseDataSets;
  FDataBase.CloseTransactions;
  FDataBase.Close();
end;

procedure TModelDataBase.Insert(ATable, AFields: String;
  AParams: array of Variant);
begin
  inherited Insert(TSQLConnector(FDataBase), ATable, AFields, AParams);
end;

function TModelDataBase.Delete(ATable, ACondicao: String;
  AParams: array of Variant): Integer;
begin
  Result := inherited Delete(TSQLConnector(FDataBase), ATable, ACondicao, AParams);
end;

function TModelDataBase.GetID: String;
begin
  Result := TGuid.NewGuid.ToString();
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

function TModelDataBase.Update(ATable, AFields, Acondicao: String;
  AParams: array of Variant): Integer;
begin
  Result := inherited Update(TSQLConnector(FDataBase), ATable, AFields, Acondicao, AParams);
end;

function TModelDataBase.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String;
  APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset): Integer;
begin
  Result := Inherited Select(TSQLConnector(FDataBase), ATable, AFields, ACondicao, AParams, ACount, AFieldCount,
    ADataSet, APage, AMaxPage);
end;

constructor TModelDataBase.Create;
begin
  FDataBase := TIBConnection.Create(nil);
  FTransact := TSQLTransaction.Create(nil);
  FDataBase.BeforeConnect := @BeforeConnect;
  FDataBase.Transaction := FTransact;
  FDataBase.Open;
end;

destructor TModelDataBase.Destroy;
begin
  CloseDB;
  FreeAndNil(FTransact);
  FreeAndNil(FDataBase);
  inherited Destroy;
end;

end.

