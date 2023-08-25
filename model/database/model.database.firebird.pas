unit model.database.firebird;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, BufDataset, model.database;

type

  { TModelFirebird }

  TModelFirebird = class(specialize TModelDatabase<TIBConnection>)
    private
      procedure BeforeConnect(Sender: TObject); override;
    public
      function Select(ATable, AFields, ACondicao: String; AParams: array of Variant;
        ACount: String; AFieldCount: String; APage: Integer; out
        AMaxPage: Integer; ADataSet: TBufDataset): Integer; override;
      function Select(ATable, AFields, ACondicao: String;
        AParams: array of Variant; ADataSet: TBufDataset): Integer; override;
  end;

const
  C_COUNT_SELECT = 'select first %d skip %d %s from %s';

implementation

{ TModelFirebird }

procedure TModelFirebird.BeforeConnect(Sender: TObject);
begin
  FConfig.Database.Get;
  FDatabase.CharSet := FConfig.Database.CharSet;
  FDataBase.CheckTransactionParams := FConfig.Database.CheckTransaction;
  FDataBase.DatabaseName := FConfig.Database.DatabaseName;
  FDataBase.Dialect := 3;
  FDataBase.HostName := FConfig.Database.HostName;
  FDataBase.Params.Clear;
  FDataBase.Params.Assign(FConfig.Database.Params);
  FDataBase.Password := FConfig.Database.Password;
  FDataBase.Port := FConfig.Database.Port;
  FDataBase.UserName := FConfig.Database.Username;
end;

function TModelFirebird.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ACount: String; AFieldCount: String;
  APage: Integer; out AMaxPage: Integer; ADataSet: TBufDataset): Integer;
var
  SQL: String;
  OffSet, ARecords: Integer;
begin

  ARecords := CountRecords(ATable, ACondicao, AParams, ACount, AFieldCount);
  OffSet := (C_MAX_REG * APage) - C_MAX_REG;
  SQL := Trim(Format(C_COUNT_SELECT, [C_MAX_REG, OffSet, AFields, ATable])
    + ' ' + ACondicao);
  Execute(SQL, ADataSet, AParams);
  AMaxPage := MaxPage(ARecords);
  Result := ARecords;

end;

function TModelFirebird.Select(ATable, AFields, ACondicao: String;
  AParams: array of Variant; ADataSet: TBufDataset): Integer;
begin
  Result := inherited Select(ATable, AFields, ACondicao, AParams, ADataSet);
end;

end.

