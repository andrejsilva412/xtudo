unit model.database;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, sqldb, BufDataset, controller.config, Math, udbnotifier;

type

  { TModelDatabase }

  generic TModelDatabase<T> = class(TDBNotifier)
    private
      FDatabase: T;
      FConfig: TConfig;
      FTransact: TSQLTransaction;
      procedure BeforeConnect(Sender: TObject); virtual;
      function ClearWhereFromCondition(ACondition: String): String;
      function Execute(const SQL: String; ADataSet: TBufDataset;
        AParams: array of Variant): Integer;
      function CountRecords(ATable, ACondicao: String;
        AParams: array of Variant; ACount: String; AFieldCount: String): Integer;
      function MaxPage(ARecords: Integer): Integer;
    public
      constructor Create;
      destructor Destroy; override;

      procedure Commit;
      function Connected: Boolean;
      procedure ExecuteDirect(ASQL: String);
      function Delete(ATable, ACondicao: String; AParams: array of Variant): Integer;
      function Insert(ATable, AFields: String; AParams: array of Variant): Integer;
      function Select(ATable, AFields, ACondicao: String;
        AParams: array of Variant; ACount: String; AFieldCount: String;
        APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset): Integer; virtual;
      function Select(ATable, AFields, ACondicao: String;
        AParams: array of Variant; ADataSet: TBufDataset): Integer; virtual;
      function Search(ATable, AField, ACondicao: String; AParams: array of Variant; ADefault: String): String; overload;
      function Search(ATable, AField, ACondicao: String; AParams: array of Variant; ADefault: Boolean): Boolean; overload;
      function Search(ATable, AField, ACondicao: String; AParams: array of Variant; ADefault: Integer): Integer; overload;
      procedure StartTransaction;
      function Update(ATable, AFields, Acondicao: String; AParams: array of Variant): Integer;
      procedure RollBack;

  end;

const
  C_MAX_REG = 100; // Limite de Resultado de Registros por página
  C_SELECT = 'select %s from %s';
  C_INSERT = 'insert into %s (%s) values (%s)';
  C_UPDATE = 'update %s set %s where %s';
  C_DELETE = 'delete from %s where %s';

implementation

uses ustrutils, utils;

procedure TModelDatabase.BeforeConnect(Sender: TObject);
begin

end;

function TModelDatabase.ClearWhereFromCondition(ACondition: String): String;
begin
  Result := Trim(StringReplace(ACondition, 'where', '', [rfReplaceAll]));
end;

function TModelDatabase.Execute(const SQL: String; ADataSet: TBufDataset;
  AParams: array of Variant): Integer;
var
  ASQLQuery: TSQLQuery;
  i: Integer;
begin

  ASQLQuery := TSQLQuery.Create(nil);
  try
    ASQLQuery.DataBase := FDatabase;
    ASQLQuery.Transaction := FDatabase.Transaction;
    ASQLQuery.SQL.Clear;
    ASQLQuery.SQL.Add(SQL);
    for i := 0 to ASQLQuery.Params.Count -1 do
    begin
      ASQLQuery.Params[i].Value := AParams[i];
    end;
    if ADataSet = nil then
    begin
      ASQLQuery.ExecSQL;
      Result := ASQLQuery.RowsAffected;
    end else begin
      ASQLQuery.Open;
      ADataSet.CopyFromDataset(ASQLQuery);
      Result := 0;
    end;
    ASQLQuery.Close;
  finally
    FreeAndNil(ASQLQuery);
  end;

end;

function TModelDatabase.CountRecords(ATable, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String): Integer;
var
  APageDataSet: TBufDataset;
  SQL: String;
begin
  APageDataSet := TBufDataset.Create(nil);
  try
    SQL := Trim(Format(C_SELECT, [ACount, ATable]) + ' ' + ACondicao);
    Execute(SQL, APageDataSet, AParams);

    if not APageDataSet.IsEmpty then
      Result := APageDataSet.FieldByName(AFieldCount).AsInteger
    else Result := 0;
  finally
    FreeAndNil(APageDataSet);
  end;
end;

function TModelDatabase.MaxPage(ARecords: Integer): Integer;
var
  AMaxPage: Integer;
begin
  AMaxPage := Ceil(ARecords / C_MAX_REG);
  AMaxPage := iif(AMaxPage = 0, 1, AMaxPage);
  Result := AMaxPage;
end;

procedure TModelDatabase.StartTransaction;
begin
  if not FDataBase.Transaction.Active then
    FDataBase.Transaction.Active := true;
end;

procedure TModelDatabase.Commit;
begin
  FDataBase.Transaction.Commit;
end;

procedure TModelDatabase.RollBack;
begin
  FDataBase.Transaction.Rollback;
end;

function TModelDatabase.Insert(ATable, AFields: String;
  AParams: array of Variant): Integer;
var
  Strings: TStringList;
  ASQL, Aux, Str1, Str2: String;
  i: Integer;
begin

  Str1 := '';
  Str2 := '';
  Strings := TStringList.Create;
  try
    AFields := DelChars(AFields, ' ');
    AFields := StringReplace(AFields, ',', ';', [rfReplaceAll]);
    Split(';', AFields, Strings);
    for i := 0 to Strings.Count -1 do
    begin
      Aux := TextoEntre(Strings[i], '', '=', true);
      Str1 := Str1 + Aux + ',';
      Aux := TextoEntre(Strings[i], '=', '', true);
      Str2 := Str2 + Aux + ',';
    end;
    System.Delete(Str1, Length(Str1), 1);
    System.Delete(Str2, Length(Str2), 1);
    ASQL := Format(C_INSERT, [ATable, Str1, Str2]);
    Result := Execute(ASQL, nil, AParams);
  finally
    FreeAndNil(Strings);
  end;
end;

function TModelDatabase.Delete(ATable, ACondicao: String;
  AParams: array of Variant): Integer;
var
  ASQL: String;
begin

  if Trim(ACondicao) = '' then
  begin
    ASQL := Format(C_DELETE, [ATable, ACondicao]);
    ASQL := Trim(LeftStr(ASQL, Pos('where', ASQL) -1));
  end else begin
    ACondicao := ClearWhereFromCondition(ACondicao);
    ASQL := Format(C_DELETE, [ATable, ACondicao]);
  end;

  Result := Execute(ASQL, nil, AParams);
end;

function TModelDatabase.Update(ATable, AFields, Acondicao: String;
  AParams: array of Variant): Integer;
var
  ASQL: String;
begin

  if Acondicao = '' then
  begin
    ASQL := Format(C_UPDATE, [ATable, AFields]);
    ASQL := Trim(LeftStr(ASQL, Pos('where', ASQL)-1));
  end else begin
    Acondicao := ClearWhereFromCondition(Acondicao);
    ASQL := Format(C_UPDATE, [ATable, AFields, ACondicao]);
  end;
  Result := Execute(ASQL, nil, AParams);

end;

function TModelDatabase.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String;
  APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset): Integer;
begin

end;

function TModelDatabase.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ADataSet: TBufDataset): Integer;
var
  SQL: String;
begin

  SQL := Trim(Format(C_SELECT, [AFields, ATable]) + ' ' + ACondicao);
  Result := Execute(SQL, ADataSet, AParams);

end;

function TModelDatabase.Connected: Boolean;
begin
  Result := FDataBase.Connected;
end;

procedure TModelDatabase.ExecuteDirect(ASQL: String);
begin
  FDatabase.ExecuteDirect(ASQL);
end;

function TModelDatabase.Search(ATable, AField, ACondicao: String;
  AParams: array of Variant; ADefault: String): String;
var
  ADataSet: TBufDataset;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    Select(ATable, AField, ACondicao,
      AParams, ADataSet);
    if ADataSet.IsEmpty then
      Result := ADefault
    else
      Result := ADataSet.FieldByName(AField).AsString;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelDatabase.Search(ATable, AField, ACondicao: String;
  AParams: array of Variant; ADefault: Boolean): Boolean;
var
  LBoolean: String;
begin

  LBoolean := Search(ATable, AField, ACondicao, AParams, '');
  Result := iif(LBoolean = '', ADefault, true);

end;

function TModelDatabase.Search(ATable, AField, ACondicao: String;
  AParams: array of Variant; ADefault: Integer): Integer;
var
  LInteger: String;
begin

  LInteger := Search(ATable, AField, ACondicao, AParams, '');
  Result := iif(LInteger = '', ADefault, StrToIntDef(LInteger, ADefault));

end;

constructor TModelDatabase.Create;
begin
  FConfig := TConfig.Create;
  FDataBase := T.Create(nil);
  FTransact := TSQLTransaction.Create(nil);
  FDataBase.BeforeConnect := @BeforeConnect;
  FDataBase.Transaction := FTransact;
  FDataBase.Open;
end;

destructor TModelDatabase.Destroy;
begin
  FreeAndNil(FConfig);
  FDataBase.CloseDataSets;
  FDataBase.CloseTransactions;
  FDataBase.Close;
  inherited Destroy;
end;

end.

