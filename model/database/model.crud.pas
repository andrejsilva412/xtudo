unit model.crud;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, model.database.firebird, model.database.sqlite,
  udbnotifier;

type

  { TModelCRUD }

  TModelCRUD = class(TDBNotifier)
    private
      FDatabaseCache: TModelSQLite;
      FDatabase: TModelFirebird;
      FSQL: TStringList;
      function Database: TModelFirebird;
      function DatabaseCache: TModelSQLite;
    protected
      procedure StartTransaction(ACache: Boolean = false);
      procedure Commit(ACache: Boolean = false);
      procedure RollBack(ACache: Boolean = false);
      function Insert(ATable, AFields: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function Delete(ATable, ACondicao: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function GetGUID: String;
      function GetPasswordHash(APassword: String): String;
      function GetNextID(ATable, AIDField: String; ACache: Boolean): Integer; overload;
      function Update(ATable, AFields, Acondicao: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function Select(ATable, AFields, ACondicao: String;
        AParams: array of Variant; ACount: String; AFieldCount: String;
        APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset;
        ACache: Boolean = false): Integer; overload;
      function Select(ATable, AFields, ACondicao: String;
        AParams: array of Variant; ADataSet: TBufDataset;
        ACache: Boolean = false): Integer; overload;
      function Search(ATable, AField, ACondicao: String;
         AParams: array of Variant; ADefault: String; ACache: Boolean = false): String; overload;
      function Search(ATable, AField, ACondicao: String;
         AParams: array of Variant; ADefault: Boolean; ACache: Boolean = false): Boolean; overload;
      function TableExists(ATable: String; ACache: Boolean = false): Boolean;
      procedure ExecuteDirect(ASQL: String; ACache: Boolean = false);
      procedure ExecuteDirect(ASQL: TStringList; ACache: Boolen = false);
      function DateTimeToCacheDateTime(ADateTime: TDateTime): String;
      property SQL: TStringList read FSQL;
    public
      constructor Create;
      destructor Destroy; override;
      function Connected(ACache: Boolean): Boolean;
  end;

implementation

uses ucript;

{ TModelCRUD }

destructor TModelCRUD.Destroy;
begin
  if Assigned(FDatabase) then
    FreeAndNil(FDatabase);
  if Assigned(FDatabaseCache) then
    FreeAndNil(FDatabaseCache);
  FreeAndNil(FSQL);
  inherited Destroy;
end;

function TModelCRUD.Database: TModelFirebird;
begin
  if not Assigned(FDatabase) then
    FDatabase := TModelFirebird.Create;
  Result := FDatabase;
end;

function TModelCRUD.DatabaseCache: TModelSQLite;
begin
  if not Assigned(FDatabaseCache) then
      FDatabaseCache := TModelSQLite.Create;
  Result := FDatabaseCache;
end;

procedure TModelCRUD.StartTransaction(ACache: Boolean);
begin
  if ACache then
    DatabaseCache.StartTransaction
  else
    Database.StartTransaction;
end;

procedure TModelCRUD.Commit(ACache: Boolean);
begin
  if ACache then
    DatabaseCache.Commit
  else
    Database.Commit;
end;

procedure TModelCRUD.RollBack(ACache: Boolean);
begin
  if ACache then
    DatabaseCache.RollBack
  else
    Database.RollBack;
end;

function TModelCRUD.Insert(ATable, AFields: String; AParams: array of Variant;
  ACache: Boolean): Integer;
begin
  if ACache then
    Result := DatabaseCache.Insert(ATable, AFields, AParams)
  else
    Result := Database.Insert(ATable, AFields, AParams);
end;

function TModelCRUD.Delete(ATable, ACondicao: String; AParams: array of Variant;
  ACache: Boolean): Integer;
begin
  if ACache then
    Result := DatabaseCache.Delete(ATable, ACondicao, AParams)
  else
    Result := Database.Delete(ATable, ACondicao, AParams);
end;

function TModelCRUD.GetGUID: String;
begin
  Result := TGuid.NewGuid.ToString();
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

function TModelCRUD.GetPasswordHash(APassword: String): String;
var
  Cript: TCript;
begin

  Cript := TCript.Create;
  try
    Result := Cript.GetHash(APassword);
  finally
    FreeAndNil(Cript);
  end;

end;

function TModelCRUD.GetNextID(ATable, AIDField: String; ACache: Boolean
  ): Integer;
const
  C_MAX_ID_FIELD = 'max(%s) as %s';
var
  ADataSet: TBufDataset;
  IDRes: Integer;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    AIDField := Format(C_MAX_ID_FIELD, [AIDField, AIDField]);
    if ACache then
      DatabaseCache.Select(ATable, AIDField, '', [], ADataSet)
    else
      Database.Select(ATable, AIDField, '', [], ADataSet);
    IDRes := 0;
    if not ADataSet.IsEmpty then
      IDRes := StrToIntDef(ADataSet.Fields[0].AsString, 0);
    Inc(IDRes);
    Result := IDRes;
    ADataSet.Close;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelCRUD.Update(ATable, AFields, Acondicao: String;
  AParams: array of Variant; ACache: Boolean): Integer;
begin

  if ACache then
    Result := DatabaseCache.Update(ATable, AFields, Acondicao, AParams)
  else
    Result := Database.Update(ATable, AFields, Acondicao, AParams);

end;

function TModelCRUD.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String;
  APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset; ACache: Boolean
  ): Integer;
begin
   if ACache then
     Result := DatabaseCache.Select(ATable, AFields, ACondicao,
       AParams, ACount, AFieldCount, APage, AMaxPage, ADataSet)
   else
     Result := Database.Select(ATable, AFields, ACondicao,
       AParams, ACount, AFieldCount, APage, AMaxPage, ADataSet);
end;

function TModelCRUD.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ADataSet: TBufDataset; ACache: Boolean): Integer;
begin
  if ACache then
    Result := DatabaseCache.Select(ATable, AFields, ACondicao,
      AParams, ADataSet)
  else
    Result := Database.Select(ATable, AFields, ACondicao,
      AParams, ADataSet);
end;

function TModelCRUD.Search(ATable, AField, ACondicao: String;
  AParams: array of Variant; ADefault: String; ACache: Boolean): String;
begin
  if ACache then
    Result := FDatabaseCache.Search(ATable, AField, ACondicao, AParams, ADefault)
  else
    Result := FDatabase.Search(ATable, AField, ACondicao, AParams, ADefault);
end;

function TModelCRUD.Search(ATable, AField, ACondicao: String;
  AParams: array of Variant; ADefault: Boolean; ACache: Boolean): Boolean;
begin
  if ACache then
    Result := FDatabaseCache.Search(ATable, AField, ACondicao, AParams, ADefault)
  else
    Result := FDatabase.Search(ATable, AField, ACondicao, AParams, ADefault);
end;

function TModelCRUD.TableExists(ATable: String; ACache: Boolean): Boolean;
begin
  if ACache then
    Result := DatabaseCache.TableExists(ATable)
  else
    Result := Database.TableExists(ATable);
end;

procedure TModelCRUD.ExecuteDirect(ASQL: String; ACache: Boolean);
begin

  if ACache then
    DatabaseCache.ExecuteDirect(ASQL)
  else
    Database.ExecuteDirect(ASQL);

end;

procedure TModelCRUD.ExecuteDirect(ASQL: TStringList; ACache: Boolen);
begin
  ExecuteDirect(ASQL.Text, ACache);
end;

function TModelCRUD.DateTimeToCacheDateTime(ADateTime: TDateTime): String;
begin
  Result := DatabaseCache.DateTimeToSQLiteDateTime(ADateTime);
end;

constructor TModelCRUD.Create;
begin
  FSQL := TStringList.Create;
end;

function TModelCRUD.Connected(ACache: Boolean): Boolean;
begin
  if ACache then
    Result := DatabaseCache.Connected
  else
    Result := Database.Connected;
end;

end.

