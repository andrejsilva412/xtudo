unit model.sqldb;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, sqldb, BufDataset, ustatus;

type

  { TModelSQLDB }

  TModelSQLDB = class(TDBStatus)
    private
      function ClearWhereFromCondition(ACondition: String): String;
      function Execute(AConnector: TSQLConnector; const SQL: String; ADataSet: TBufDataset;
        AParams: array of Variant): Integer;
      procedure SQLQueryToBufDataSet(InDataSet: TSQLQuery; OutDataSet: TBufDataset);
      function AddLimit(OffSet: Integer): String;
    protected
      procedure Insert(AConnector: TSQLConnector; ATable, AFields: String; AParams: array of Variant);
      function Delete(AConnector: TSQLConnector; ATable, ACondicao: String; AParams: array of Variant): Integer;
      function Update(AConnector: TSQLConnector; ATable, AFields, Acondicao: String; AParams: array of Variant): Integer;
      // Seleciona os registros e retorna a quantidade
      function Select(AConnector: TSQLConnector; ATable, AFields, ACondicao: String;
        AParams: array of Variant; ACount: String; AFieldCount: String; ADataSet: TBufDataset;
        APage: Integer; out AMaxPage: Integer): Integer;
  end;

const
  C_MAX_REG = 100; // Limite de Resultado de Registros por página
  C_SELECT = 'select %s from %s';
  C_INSERT = 'insert into %s (%s) values (%s)';
  C_UPDATE = 'update %s set %s where %s';
  C_DELETE = 'delete from %s where %s';

implementation

uses ustrutils;

{ TModelSQLDB }

function TModelSQLDB.ClearWhereFromCondition(ACondition: String): String;
begin

  Result := Trim(StringReplace(ACondition, 'where', '', [rfReplaceAll]));

end;

function TModelSQLDB.Execute(AConnector: TSQLConnector; const SQL: String;
  ADataSet: TBufDataset; AParams: array of Variant): Integer;
var
  ASQLQuery: TSQLQuery;
  i: Integer;
begin

  ASQLQuery := TSQLQuery.Create(nil);
  try
    ASQLQuery.DataBase := AConnector;
    ASQLQuery.Transaction := AConnector.Transaction;
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
      SQLQueryToBufDataSet(ASQLQuery, ADataSet);
    end;
    ASQLQuery.Close;
  finally
    FreeAndNil(ASQLQuery);
  end;

end;

procedure TModelSQLDB.SQLQueryToBufDataSet(InDataSet: TSQLQuery;
  OutDataSet: TBufDataset);
var
  MemoryStream: TMemoryStream;
begin

  if OutDataSet.ClassType = TBufDataset then
  begin
    MemoryStream := TMemoryStream.Create;
    try
      InDataSet.SaveToStream(MemoryStream, dfBinary);
      OutDataSet.LoadFromStream(MemoryStream, dfBinary);
    finally
      FreeAndNil(MemoryStream);
    end;
  end else
    raise Exception.Create('Informe um dataset do tipo TBufDataSet');

end;

function TModelSQLDB.AddLimit(OffSet: Integer): String;
begin

  Result := Format('limit %d, %d', [OffSet, C_MAX_REG]);

end;

procedure TModelSQLDB.Insert(AConnector: TSQLConnector; ATable,
  AFields: String; AParams: array of Variant);
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
    Execute(AConnector, ASQL, nil, AParams);

  finally
    FreeAndNil(Strings);
  end;



end;

function TModelSQLDB.Delete(AConnector: TSQLConnector; ATable,
  ACondicao: String; AParams: array of Variant): Integer;
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

  Result := Execute(AConnector, ASQL, nil, AParams);

end;

function TModelSQLDB.Update(AConnector: TSQLConnector; ATable, AFields,
  Acondicao: String; AParams: array of Variant): Integer;
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
  Result := Execute(AConnector, ASQL, nil, AParams);

end;

function TModelSQLDB.Select(AConnector: TSQLConnector; ATable, AFields,
  ACondicao: String; AParams: array of Variant; ACount: String;
  AFieldCount: String; ADataSet: TBufDataset; APage: Integer; out
  AMaxPage: Integer): Integer;
sLimit, SQL: String;
APageDataSet: TBufDataset;
OffSet, ARecords: Integer;
begin

  APageDataSet := TBufDataset.Create(nil);
  try
    SQL := Trim(Format(C_SELECT, [ACount, ATable]) + ' ' + ACondicao);
    Execute(AConnector, SQL, APageDataSet, AParams);

    if not APageDataSet.IsEmpty then
      ARecords := APageDataSet.FieldByName(AFieldCount).AsInteger
    else ARecords := 0;

    OffSet := (C_MAX_REG * APage) - C_MAX_REG;

    sLimit := AddLimit(OffSet);

    SQL := Trim(Format(C_SELECT, [AFields, ATable]) + ' ' + ACondicao);
    SQL := SQL + ' ' + sLimit;
    Execute(AConnector, SQL, ADataSet, AParams);

    AMaxPage := Ceil(ARecords / C_MAX_REG);
    AMaxPage := iif(AMaxPage = 0, 1, AMaxPage);
    Result := ARecords;
  finally
    FreeAndNil(APageDataSet);
  end;

end;

end.

