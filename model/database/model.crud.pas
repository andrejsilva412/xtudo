unit model.crud;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, model.database.mariadb, model.database.sqlite,
  udbnotifier, uvalida, uimage, ucript;

type

  { TModelCRUD }

  TModelCRUD = class(TDBNotifier)
    private
      FDatabaseCache: TModelSQLite;
      FDatabase: TModelMariaDB;
      FSQL: TStringList;
      FValida: TValidador;
      FCrip: TCript;
      FImage: TImages;
      function Database: TModelMariaDB;
      function DatabaseCache: TModelSQLite;
    protected
      function Cript: TCript;
      function Image: TImages;
      procedure StartTransaction(ACache: Boolean = false);
      procedure Commit(ACache: Boolean = false);
      procedure RollBack(ACache: Boolean = false);
      function Insert(ATable, AFields: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function Delete(ATable, ACondicao: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function NewGUID: String;
      function GetPasswordHash(APassword: String): String;
      function GetBase64Content(ATable, GUIDField, GUID, ABase64Field: String): String;
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
      function Search(ATable, AField, ACondicao: String;
         AParams: array of Variant; ADefault: Integer; ACache: Boolean = false): Integer; overload;
      procedure ExecuteDirect(ASQL: String; ACache: Boolean = false);
      procedure ExecuteDirect(ASQL: TStringList; ACache: Boolean = false);
      function DateTimeToCacheDateTime(ADateTime: TDateTime): String;
      function TableExists(ATable: String; ACache: Boolean): Boolean;
      function Validador: TValidador;
      property SQL: TStringList read FSQL;
      function DatabaseConnected(ACache: Boolean): Boolean;
    public
      constructor Create;
      destructor Destroy; override;
  end;

implementation

uses utils, uconst;

{ TModelCRUD }

destructor TModelCRUD.Destroy;
begin
  if Assigned(FCrip) then
    FreeAndNil(FCrip);
  if Assigned(FDatabase) then
    FreeAndNil(FDatabase);
  if Assigned(FDatabaseCache) then
    FreeAndNil(FDatabaseCache);
  if Assigned(FValida) then
    FreeAndNil(FValida);
  if Assigned(FImage) then
    FreeAndNil(FImage);
  FreeAndNil(FSQL);
  inherited Destroy;
end;

function TModelCRUD.Database: TModelMariaDB;
begin
  if not Assigned(FDatabase) then
    FDatabase := TModelMariaDB.Create;
  FDatabase.OnDatabaseNotify := @DoDataBaseNotify;
  FDatabase.OnProgress := @DoProgress;
  FDatabase.OnStatus := @DoStatus;
  Result := FDatabase;
end;

function TModelCRUD.DatabaseCache: TModelSQLite;
begin
  if not Assigned(FDatabaseCache) then
      FDatabaseCache := TModelSQLite.Create;
  FDatabaseCache.OnDatabaseNotify := @DoDataBaseNotify;
  FDatabaseCache.OnProgress := @DoProgress;
  FDatabaseCache.OnStatus := @DoStatus;
  Result := FDatabaseCache;
end;

function TModelCRUD.Cript: TCript;
begin
  if not Assigned(FCrip) then
    FCrip := TCript.Create;
  Result := FCrip;
end;

function TModelCRUD.Image: TImages;
begin
  if not Assigned(FImage) then
    FImage := TImages.Create;
  Result := FImage;
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

function TModelCRUD.NewGUID: String;
begin
  Result := TGuid.NewGuid.ToString();
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

function TModelCRUD.GetPasswordHash(APassword: String): String;
begin

  Result := Cript.GetPassHASH(APassword);

end;

function TModelCRUD.GetBase64Content(ATable, GUIDField, GUID,
  ABase64Field: String): String;
begin

  Result := Database.GetBase64Content(ATable,  GUIDField, GUID, ABase64Field);

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
    Result := DatabaseCache.Search(ATable, AField, ACondicao, AParams, ADefault)
  else
    Result := Database.Search(ATable, AField, ACondicao, AParams, ADefault);
end;

function TModelCRUD.Search(ATable, AField, ACondicao: String;
  AParams: array of Variant; ADefault: Boolean; ACache: Boolean): Boolean;
begin
  if ACache then
    Result := DatabaseCache.Search(ATable, AField, ACondicao, AParams, ADefault)
  else
    Result := Database.Search(ATable, AField, ACondicao, AParams, ADefault);
end;

function TModelCRUD.Search(ATable, AField, ACondicao: String;
  AParams: array of Variant; ADefault: Integer; ACache: Boolean): Integer;
begin
  if ACache then
    Result := DatabaseCache.Search(ATable, AField, ACondicao, AParams, ADefault)
  else
    Result := Database.Search(ATable, AField, ACondicao, AParams, ADefault);
end;

procedure TModelCRUD.ExecuteDirect(ASQL: String; ACache: Boolean);
begin

  if ACache then
    DatabaseCache.ExecuteDirect(ASQL)
  else
    Database.ExecuteDirect(ASQL);

end;

procedure TModelCRUD.ExecuteDirect(ASQL: TStringList; ACache: Boolean);
begin
  ExecuteDirect(ASQL.Text, ACache);
end;

function TModelCRUD.DateTimeToCacheDateTime(ADateTime: TDateTime): String;
begin
  Result := DatabaseCache.DateTimeToSQLiteDateTime(ADateTime);
end;

function TModelCRUD.TableExists(ATable: String; ACache: Boolean): Boolean;
var
  lResult: String;
  ADataSet: TBufDataset;
begin

  if not ACache then
  begin
    ADataSet := TBufDataset.Create(nil);
    try
      Database.Select('RDB$RELATIONS', '1', 'RDB$RELATION_NAME = :name',
        [ATable], ADataSet);
      Result := not ADataSet.IsEmpty;
      ADataSet.Close;
    finally
      FreeAndNil(ADataSet);
    end;
  end else begin
    lResult := DatabaseCache.Search('sqlite_master', 'name', 'WHERE type=:tipo AND name=:name',
      ['table', ATable], '');
    Result := iif(lResult = '', false, true);
  end;

end;

function TModelCRUD.Validador: TValidador;
begin
  if not Assigned(FValida) then
     FValida := TValidador.Create;
  Result := FValida;
end;

constructor TModelCRUD.Create;
begin
  FSQL := TStringList.Create;
end;

function TModelCRUD.DatabaseConnected(ACache: Boolean): Boolean;
begin
  if ACache then
    Result := DatabaseCache.Connected
  else
    Result := Database.Connected;
end;

end.

