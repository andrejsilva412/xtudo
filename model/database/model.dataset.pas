unit model.dataset;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, fpjson, model.crud;

type

  { TModelDataSet }

  TModelDataSet = class(TModelCRUD)
    private
      FTableName: String;
    protected
      function Insert(AFields: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function GetNextID(AIDField: String = 'id'; ACache: Boolean = false): Integer;
      function Select(AField, ACondicao: String; AParams: array of Variant; ADefault: String; ACache: Boolean = false): String; overload;
      function Select(AField, ACondicao: String; AParams: array of Variant; ADefault: Boolean; ACache: Boolean = false): Boolean; overload;
      function Select(AField, ACondicao: String; AParams: array of Variant; ADefault: Integer; ACache: Boolean = false): Integer; overload;
      function SelectCurr(AField, ACondicao: String; AParams: array of Variant; ADefault: Currency; ACache: Boolean = false): Currency; overload;
      function Select(AFields, ACondicao: String; AParams: array of Variant; AJSON: TJSONObject; ACache: Boolean = false): Integer; overload;
      function Select(AFields, ACondicao: String; AParams: array of Variant; ADataSet: TBufDataset; ACache: Boolean = false): Integer; overload;
      function Select(AFields, ACondicao: String; AParams: array of Variant; ACount: String; AFieldCount: String;
        APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset;
        ACache: Boolean = false): Integer; overload;
      function Update(AFields, Acondicao: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function IntToBool(Int: Integer): Boolean;
      function BoolToInt(Bool: Boolean): Integer;
    public
      property TableName: String read FTableName write FTableName;
  end;

implementation

uses utils;

{ TModelDataSet }

function TModelDataSet.Insert(AFields: String; AParams: array of Variant;
  ACache: Boolean): Integer;
begin

  Result := inherited Insert(TableName, AFields, AParams, ACache);

end;

function TModelDataSet.GetNextID(AIDField: String; ACache: Boolean): Integer;
begin

  Result := inherited GetNextID(TableName, AIDField, ACache);

end;

function TModelDataSet.Select(AField, ACondicao: String;
  AParams: array of Variant; ADefault: String; ACache: Boolean): String;
begin
  Result := inherited Select(TableName, AField, ACondicao,
   AParams, ADefault, ACache);
end;

function TModelDataSet.Select(AField, ACondicao: String;
  AParams: array of Variant; ADefault: Boolean; ACache: Boolean): Boolean;
begin
  Result := inherited Select(TableName, AField, ACondicao,
   AParams, ADefault, ACache);
end;

function TModelDataSet.Select(AField, ACondicao: String;
  AParams: array of Variant; ADefault: Integer; ACache: Boolean): Integer;
begin
  Result := inherited Select(TableName, AField, ACondicao,
   AParams, ADefault, ACache);
end;

function TModelDataSet.SelectCurr(AField, ACondicao: String;
  AParams: array of Variant; ADefault: Currency; ACache: Boolean): Currency;
begin
  Result := inherited SelectCurr(TableName, AField, ACondicao,
   AParams, ADefault, ACache);
end;

function TModelDataSet.Select(AFields, ACondicao: String;
  AParams: array of Variant; AJSON: TJSONObject; ACache: Boolean): Integer;
begin
  Result := inherited Select(TableName, AFields, ACondicao, AParams, AJSON, ACache);
end;

function TModelDataSet.Select(AFields, ACondicao: String;
  AParams: array of Variant; ADataSet: TBufDataset; ACache: Boolean): Integer;
begin
  Result := inherited Select(TableName, AFields, ACondicao, AParams, ADataSet, ACache);
end;

function TModelDataSet.Select(AFields, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String;
  APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset; ACache: Boolean
  ): Integer;
begin
  Result := inherited Select(TableName, AFields, ACondicao, AParams, ACount,
    AFieldCount, APage, AMaxPage, ADataSet, ACache);
end;

function TModelDataSet.Update(AFields, Acondicao: String;
  AParams: array of Variant; ACache: Boolean): Integer;
begin
  Result := Inherited Update(TableName, AFields, Acondicao, AParams, ACache);
end;

function TModelDataSet.IntToBool(Int: Integer): Boolean;
begin
  Result := iif(Int = 1, true, false);
end;

function TModelDataSet.BoolToInt(Bool: Boolean): Integer;
begin
  Result := iif(Bool = true, 1, 0);
end;

end.

