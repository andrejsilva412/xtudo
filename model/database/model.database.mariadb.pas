unit model.database.mariadb;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDBLib, model.database;


type

  { TModelMariaDB }

  TModelMariaDB = class(specialize TModelDatabase<TMySQL80Connection>)
    private
      FSQLDBLibraryLoader: TSQLDBLibraryLoader;
      procedure BeforeConnect(Sender: TObject); override;
    public
      constructor Create;
      destructor Destroy; override;
  end;

implementation

{ TModelMariaDB }

procedure TModelMariaDB.BeforeConnect(Sender: TObject);
begin
  FConfig.Database.Get;
  FDatabase.CharSet := FConfig.Database.CharSet;
  FDataBase.DatabaseName := FConfig.Database.DatabaseName;
  FDataBase.HostName := FConfig.Database.HostName;
  FDataBase.Password := FConfig.Database.Password;
  FDataBase.Port := FConfig.Database.Port;
  FDataBase.UserName := FConfig.Database.Username;
  FDataBase.SkipLibraryVersionCheck := true;
end;

constructor TModelMariaDB.Create;
begin

  FSQLDBLibraryLoader := TSQLDBLibraryLoader.Create(nil);
  FSQLDBLibraryLoader.ConnectionType := 'MySQL 8.0';
  FSQLDBLibraryLoader.LibraryName := 'libmariadb.dll';
  FSQLDBLibraryLoader.Enabled := true;
  inherited Create;

end;

destructor TModelMariaDB.Destroy;
begin
  FreeAndNil(FSQLDBLibraryLoader);
  inherited Destroy;
end;

end.

