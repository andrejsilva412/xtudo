unit model.dataset;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, model.crud;

type

  { TModelDataSet }

  TModelDataSet = class(TModelCRUD)
    private
      FTableName: String;
    protected
      function Insert(AFields: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
      function GetNextID(AIDField: String = 'id'; ACache: Boolean = false): Integer;
      function Search(AField, ACondicao: String;
         AParams: array of Variant; ADefault: Integer; ACache: Boolean = false): Integer; overload;
      function Search(AField, ACondicao: String;
         AParams: array of Variant; ADefault: Boolean; ACache: Boolean = false): Boolean; overload;
      function Search(AField, ACondicao: String;
         AParams: array of Variant; ADefault: String; ACache: Boolean = false): String; overload;
      function Select(AFields, ACondicao: String;
        AParams: array of Variant; ADataSet: TBufDataset;
        ACache: Boolean = false): Integer; overload;
      function Select(AFields, ACondicao: String;
        AParams: array of Variant; ACount: String; AFieldCount: String;
        APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset;
        ACache: Boolean = false): Integer; overload;
      function Update(AFields, Acondicao: String; AParams: array of Variant;
        ACache: Boolean = false): Integer;
    public
      property TableName: String read FTableName write FTableName;
  end;

implementation

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

function TModelDataSet.Search(AField, ACondicao: String;
  AParams: array of Variant; ADefault: Integer; ACache: Boolean): Integer;
begin
  Result := Inherited Search(TableName, AField, ACondicao, AParams, ADefault, ACache);
end;

function TModelDataSet.Search(AField, ACondicao: String;
  AParams: array of Variant; ADefault: Boolean; ACache: Boolean): Boolean;
begin
  Result := inherited Search(TableName, AField, ACondicao, AParams, ADefault, ACache);
end;

function TModelDataSet.Search(AField, ACondicao: String;
  AParams: array of Variant; ADefault: String; ACache: Boolean): String;
begin
  Result := inherited Search(TableName, AField, ACondicao, AParams, ADefault, ACache);
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

end.

