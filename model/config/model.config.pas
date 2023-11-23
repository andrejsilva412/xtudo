unit model.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, controller.config, controller.user,
  model.crud;

type

  { TModelConfig }

  TModelConfig = class(TModelCRUD)
    private
      procedure CreateCacheConfigTable;
      function GetConfig(AConfig: String; ADefault: String; Global: Boolean = false): String; overload;
      function GetConfig(AConfig: String; ADefault: Boolean; Global: Boolean = false): Boolean; overload;
      function GetConfig(AConfig: String; ADefault: Integer; Global: Boolean = false): Integer; overload;
      procedure SetConfig(AConfig: String; AValue: String; Global: Boolean = false); overload;
      procedure SetConfig(AConfig: String; AValue: Boolean; Global: Boolean = false); overload;
      procedure SetConfig(AConfig: String; AValue: Integer; Global: Boolean = false); overload;
      procedure Delete(AConfig: String; Global: Boolean = false);
    public
      constructor Create;
      procedure CreateConfigTable;
      function Connected(ACache: Boolean): Boolean;
      procedure Get(AConfig: TConfigTheme);
      procedure Get(AConfig: TConfigDatabase);
      procedure Get(Aconfig: TConfig);
      procedure Get(ALoggedUser: TUser);
      procedure Save(AConfig: TConfigDatabase);
      procedure Save(ALoggedUser: TUser);
      procedure LogOutUser;
      procedure WizardDone;
  end;

implementation

uses uconst, utils, ucript, uhtmlutils;

{ TModelConfig }

procedure TModelConfig.CreateConfigTable;
begin

  CreateCacheConfigTable

end;

procedure TModelConfig.CreateCacheConfigTable;
begin

  // Cria a tabela de configuração no cache
  if not TableExists('config', true) then
  begin
    SQL.Clear;
    SQL.Add('CREATE TABLE "config" (');
    SQL.Add('"id"	INTEGER NOT NULL UNIQUE,');
    SQL.Add('"nome"	TEXT NOT NULL,');
    SQL.Add('"valor"	TEXT NOT NULL,');
    SQL.Add('PRIMARY KEY("id"));');
    StartTransaction(true);
    ExecuteDirect(SQL, true);
    SQL.Clear;
    SQL.Add('CREATE UNIQUE INDEX "idx_config" ON "config" (');
    SQL.Add('"nome");');
    ExecuteDirect(SQL, true);
    Commit(true);
  end;

end;

constructor TModelConfig.Create;
begin
  inherited;
end;

function TModelConfig.GetConfig(AConfig: String; ADefault: String;
  Global: Boolean): String;
begin

  Global := not Global;
  Result := Select('config', 'valor', 'where nome = :nome', [AConfig], '', Global);
  Result := iif(Result = '', ADefault, Result);

end;

function TModelConfig.GetConfig(AConfig: String; ADefault: Boolean;
  Global: Boolean): Boolean;
var
  lResult: String;
begin

  lResult := GetConfig(AConfig, '', Global);
  Result := StrToBoolDef(lResult, ADefault);

end;

function TModelConfig.GetConfig(AConfig: String; ADefault: Integer;
  Global: Boolean): Integer;
var
  lResult: String;
begin

  lResult := GetConfig(AConfig, '', Global);
  Result := StrToIntDef(lResult, ADefault);

end;

procedure TModelConfig.SetConfig(AConfig: String; AValue: String;
  Global: Boolean);
var
  lExists: Boolean;
begin

  Global := not Global;
  StartTransaction(Global);
  try
    lExists := Select('config', 'nome', 'where nome = :nome', [AConfig], false, Global);
    if not lExists then
      Insert('config', 'id = :id, nome = :nome, valor = :valor',
          [GetNextID('config', 'id', true), AConfig, AValue], Global)
    else
        Update('config', 'valor = :valor', 'where nome = :nome',
          [AValue, AConfig], Global);
    Commit(Global);
  except
    on E: Exception do
    begin
      RollBack(Global);
      raise Exception.Create('Ocorreu uma falha ao salvar a configuração. ' + E.Message);
    end;
  end;

end;

procedure TModelConfig.SetConfig(AConfig: String; AValue: Boolean;
  Global: Boolean);
var
  lBoolean: String;
begin

  lBoolean := BoolToStr(AValue);
  SetConfig(AConfig, lBoolean, Global);

end;

procedure TModelConfig.SetConfig(AConfig: String; AValue: Integer;
  Global: Boolean);
var
  lInteger: String;
begin

  lInteger := IntToStr(AValue);
  SetConfig(AConfig, lInteger, Global);

end;

function TModelConfig.Connected(ACache: Boolean): Boolean;
begin
  Result := DatabaseConnected(ACache);
end;

procedure TModelConfig.Get(AConfig: TConfigTheme);
begin

  with AConfig do
  begin
    // Seta os valores Default
    BackGround1 := HTMLToColor('#272727');
    BackGround2 := HTMLToColor('#2F0505');
    ForeGround := HTMLToColor('#85311B');
    Secondary1 := HTMLToColor('#C1853B');
    Secondary2 := HTMLToColor('#DB9327');
    Secondary3 := HTMLToColor('#CC1B1B');
    Secondary4 := HTMLToColor('#9E9E9E');
    Secondary5 := HTMLToColor('#E2C52C');
    Secondary6 := HTMLToColor('#0CA147');
    Secondary7 := HTMLToColor('#F4F4F4');

    BackGround2 := HTMLToColor(GetConfig(
      'background2', ColorToHTML(BackGround2)));
    BackGround2 := HTMLToColor(GetConfig(
      'background2', ColorToHTML(BackGround2)));
    ForeGround := HTMLToColor(GetConfig(
      'foreground',  ColorToHTML(ForeGround)));
    Secondary1 := HTMLToColor(GetConfig(
      'secondary1',  ColorToHTML(Secondary1)));
    Secondary2 := HTMLToColor(GetConfig(
      'secondary2',  ColorToHTML(Secondary2)));
    Secondary3 := HTMLToColor(GetConfig(
       'secondary3', ColorToHTML(Secondary3)));
    Secondary4 := HTMLToColor(GetConfig(
       'secondary4', ColorToHTML(Secondary4)));
    Secondary5 := HTMLToColor(GetConfig(
       'secondary5', ColorToHTML(Secondary5)));
    Secondary6 := HTMLToColor(GetConfig(
       'secondary6', ColorToHTML(Secondary6)));
    Secondary7 := HTMLToColor(GetConfig(
       'secondary7',  ColorToHTML(Secondary7)));
  end;

end;

procedure TModelConfig.Get(AConfig: TConfigDatabase);
var
  aDef: String;
begin
  with AConfig do
  begin
    DatabaseName := GetConfig('database_name', 'xtudo');
    HostName := GetConfig('database_hostname', 'localhost');
    CharSet := GetConfig('database_charset', 'utf8');
    aDef := GetConfig('database_username', '');
    Username := iif(aDef <> '', Cript.Sha256Decrypt(aDef), 'root');
    aDef := GetConfig('database_password', '');
    Password := iif(aDef <> '', Cript.Sha256Decrypt(aDef), 'root');
    Port := GetConfig('database_port', C_MARIA_DB_DEFAULT_PORT, false);
  end;

end;

procedure TModelConfig.Get(Aconfig: TConfig);
begin

  Aconfig.ShowWizard := GetConfig('show_wizard', true);

end;

procedure TModelConfig.Get(ALoggedUser: TUser);
begin

  ALoggedUser.Username := GetConfig('logged_username', '');

end;

procedure TModelConfig.Save(AConfig: TConfigDatabase);
begin

  with AConfig do
  begin
    SetConfig('database_name', DatabaseName);
    SetConfig('database_charset', CharSet);
    SetConfig('database_params', Params.DelimitedText);
    SetConfig('database_username',
      Cript.Sha256Encrypt(Username));
    SetConfig('database_password', Cript.Sha256Encrypt(
      Password));
    SetConfig('database_hostname', HostName);
    SetConfig('database_port', AConfig.Port);
  end;

end;

procedure TModelConfig.Save(ALoggedUser: TUser);
begin

  SetConfig('logged_username', ALoggedUser.Username);

end;

procedure TModelConfig.LogOutUser;
begin

  Delete('logged_username');

end;

procedure TModelConfig.Delete(AConfig: String; Global: Boolean);
begin

  Global := not Global;

  StartTransaction(Global);
  try
    inherited Delete('config', 'where nome = :nome', [AConfig], Global);
    Commit(Global);
  except
    on E: Exception do
    begin
      RollBack(Global);
    end;
  end;

end;

procedure TModelConfig.WizardDone;
begin
  SetConfig('show_wizard', false);
end;

end.

