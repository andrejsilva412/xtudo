unit model.database.sqlite;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, model.database;

type

  { TModelSQLite }

  TModelSQLite = class(specialize TModelDatabase<TSQLite3Connection>)
    private
      procedure BeforeConnect(Sender: TObject); override;
    public
      function SQLLiteDataTimeToDateTime(ADateTime: String): TDateTime;
      function DateTimeToSQLiteDateTime(ADataTime: TDateTime): String;
  end;

const
  C_SQLITE_DATETIME = 'yyyy-mm-dd';

implementation

{ TModelSQLite }

procedure TModelSQLite.BeforeConnect(Sender: TObject);
begin

  FDataBase.DatabaseName := FConfig.Database.CacheDatabase;
  FDataBase.HostName := '';
  FDataBase.Params.Clear;
  FDataBase.Password := '';
  FDataBase.UserName := '';

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

