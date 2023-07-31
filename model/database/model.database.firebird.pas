unit model.database.firebird;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, model.database;

type

  { TModelFirebird }

  TModelFirebird = class(specialize TModelDatabase<TIBConnection>)
    private
      procedure BeforeConnect(Sender: TObject); override;
    public
  end;

implementation

{ TModelFirebird }

procedure TModelFirebird.BeforeConnect(Sender: TObject);
begin
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

end.

