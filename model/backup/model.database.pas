unit model.database;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, model.sqldb;

type

  { TModelDataBase }

  TModelDataBase = class(TModelSQLDB)
    private
      FDataBase: TSQLConnector;
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
      constructor Create;
      destructor Destroy; override;
  end;

implementation

uses ustrutils;

{ TModelDataBase }

procedure TModelDataBase.BeforeConnect(Sender: TObject);
begin
  FDataBase.DatabaseName := 'data.db';
   FDataBase.CharSet := 'UTF8';
   FDataBase.ConnectorType := 'SQLite3';
end;

procedure TModelDataBase.StartTransaction;
begin
  if not FDataBase.Transaction.Active then
    FDataBase.Transaction.Active := true;
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
  inherited Insert(FDataBase, ATable, AFields, AParams);
end;

function TModelDataBase.Delete(ATable, ACondicao: String;
  AParams: array of Variant): Integer;
begin
  Result := inherited Delete(FDataBase, ATable, ACondicao, AParams);
end;

function TModelDataBase.GetID: String;
begin
  Result := TGuid.NewGuid.ToString();
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
  Result := DelChars(Result, '-');
end;

function TModelDataBase.Update(ATable, AFields, Acondicao: String;
  AParams: array of Variant): Integer;
begin
  Result := inherited Update(FDataBase, ATable, AFields, Acondicao, AParams);
end;

function TModelDataBase.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String;
  APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset): Integer;
begin
  Result := Inherited Select(FDataBase, ATable, AFields, ACondicao, AParams, ACount, AFieldCount,
    ADataSet, APage, AMaxPage);
end;

constructor TModelDataBase.Create;
begin
  FDataBase := TSQLConnector.Create(nil);
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

