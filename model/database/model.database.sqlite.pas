unit model.database.sqlite;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, BufDataset, model.database;

type

  { TModelSQLite }

  TModelSQLite = class(specialize TModelDatabase<TSQLite3Connection>)
    private
      function AddLimit(OffSet: Integer): String;
      procedure BeforeConnect(Sender: TObject); override;
    public
      function Select(ATable, AFields, ACondicao: String; AParams: array of Variant;
        ACount: String; AFieldCount: String; APage: Integer; out
        AMaxPage: Integer; ADataSet: TBufDataset): Integer; override;
      function Select(ATable, AFields, ACondicao: String;
        AParams: array of Variant; ADataSet: TBufDataset): Integer; override;
      function SQLLiteDataTimeToDateTime(ADateTime: String): TDateTime;
      function DateTimeToSQLiteDateTime(ADataTime: TDateTime): String;
  end;

const
  C_SQLITE_DATETIME = 'yyyy-mm-dd';

implementation

{ TModelSQLite }

function TModelSQLite.AddLimit(OffSet: Integer): String;
begin
  Result := Format('limit %d, %d', [OffSet, C_MAX_REG]);
end;

procedure TModelSQLite.BeforeConnect(Sender: TObject);
begin

  FDataBase.DatabaseName := FConfig.Database.CacheDatabase;
  FDataBase.HostName := '';
  FDataBase.Params.Clear;
  FDataBase.Password := '';
  FDataBase.UserName := '';

end;

function TModelSQLite.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String;
  APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset): Integer;
const
  C_LIMIT = ' limit %d, %d';
var
  SQL: String;
  OffSet, ARecords: Integer;
begin
  ARecords := CountRecords(ATable, ACondicao, AParams, ACount, AFieldCount);
  OffSet := (C_MAX_REG * APage) - C_MAX_REG;
  SQL := Trim(Format(C_SELECT, [OffSet, C_MAX_REG, AFields, ATable])
    + ' ' + ACondicao);
  SQL := SQL + Format(C_LIMIT, [OffSet, C_MAX_REG]);
  Execute(SQL, ADataSet, AParams);
  AMaxPage := MaxPage(ARecords);
  Result := ARecords;
end;

function TModelSQLite.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ADataSet: TBufDataset): Integer;
begin
  Result := inherited Select(ATable, AFields, ACondicao, AParams, ADataSet);
end;

function TModelSQLite.SQLLiteDataTimeToDateTime(ADateTime: String): TDateTime;
begin
  Result := StrToDate(ADateTime, C_SQLITE_DATETIME);
end;

function TModelSQLite.DateTimeToSQLiteDateTime(ADataTime: TDateTime): String;
begin
  Result := FormatDateTime(C_SQLITE_DATETIME, ADataTime);
end;

end.

