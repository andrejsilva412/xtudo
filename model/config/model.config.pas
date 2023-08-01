unit model.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, controller.config, model.crud;

type

  { TModelConfig }

  TModelConfig = class(TModelCRUD)
    private
      procedure CreateCacheConfigTable;
      function GetConfig(AConfig: String; ADefault: String; Global: Boolean = false): String;
      function GetConfig(AConfig: String; ADefault: Boolean; Global: Boolean = false): Boolean;
      procedure SetConfig(AConfig: String; AValue: String; Global: Boolean = false);
      procedure SetConfig(AConfig: String; AValue: Boolean; Global: Boolean = false);
    public
      constructor Create;
      procedure CreateConfigTable;
      function Connected(ACache: Boolean): Boolean;
      procedure Get(AConfig: TConfigTheme);
      procedure Get(AConfig: TConfigDatabase);
      procedure Get(Aconfig: TConfig);
      procedure Save(AConfig: TConfigDatabase);
      procedure WizardDone;
  end;

implementation

uses utils, ucript, uhtmlutils;

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

  if not Global then
    Result := Search('config', 'valor', 'where nome = :nome', [AConfig], '', true)
  else
    Result := Search('config', 'valor', 'where nome = :nome', [AConfig], '');

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

procedure TModelConfig.SetConfig(AConfig: String; AValue: String;
  Global: Boolean);
var
  lExists: Boolean;
begin

  if not Global then
  begin
    StartTransaction(true);
    try
      lExists := Search('config', 'nome', 'where nome = :nome', [AConfig], false, true);
      if not lExists then
        Insert('config', 'id = :id, nome = :nome, valor = :valor',
          [GetNextID('config', 'id', true), AConfig, AValue], true)
      else
        Update('config', 'valor = :valor', 'where nome = :nome',
          [AValue, AConfig], true);
      Commit(true);
    except
      on E: Exception do
      begin
        RollBack(true);
        raise Exception.Create('Ocorreu uma falha ao salvar a configuração no cache. ' + E.Message);
      end;
    end;
  end else begin
    StartTransaction();
    try
      lExists := Search('config', 'nome', 'where nome = :nome', [AConfig], false);
      if not lExists then
        Insert('config', 'id = :id, nome = :nome, valor = :valor',
          [GetNextID('config', 'id', true), AConfig, AValue])
      else
        Update('config', 'valor = :valor', 'where nome = :nome',
        [AValue, AConfig]);
      Commit();
    except
      on E: Exception do
      begin
        RollBack();
        raise Exception.Create('Ocorreu uma falha ao salvar a configuração glogal. ' + E.Message);
      end;
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

function TModelConfig.Connected(ACache: Boolean): Boolean;
begin
  Result := DatabaseConnected(ACache);
end;

procedure TModelConfig.Get(AConfig: TConfigTheme);
var
  FHTMLUtils: THTMLUtils;
begin

  FHTMLUtils := THTMLUtils.Create;
  try

    with FHTMLUtils, AConfig do
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

  finally
    FreeAndNil(FHTMLUtils);
  end;
end;

procedure TModelConfig.Get(AConfig: TConfigDatabase);
var
  aDef: String;
begin
  aDef := Path + 'database' + PathDelim + 'XTUDO.FDB';
  with AConfig do
  begin
    DatabaseName := GetConfig('database_filename', aDef);
    HostName := GetConfig('database_hostname', 'localhost');
    CharSet := GetConfig('database_charset', 'WIN1252');
    CheckTransaction := GetConfig('database_checktransaction', false);
    Params.Clear;
    Params.DelimitedText :=
        GetConfig('database_params', 'isc_tpb_read_committed');
    aDef := GetConfig('database_username', '');
    Username := iif(aDef <> '', Cript.Sha256Decrypt(aDef), 'SYSDBA');
    aDef := GetConfig('database_password', '');
    Password := iif(aDef <> '', Cript.Sha256Decrypt(aDef), 'masterkey');
  end;

end;

procedure TModelConfig.Get(Aconfig: TConfig);
begin

  Aconfig.ShowWizard := GetConfig('show_wizard', true);

end;

procedure TModelConfig.Save(AConfig: TConfigDatabase);
begin

  with AConfig do
  begin
    SetConfig('database_filename', DatabaseName);
    SetConfig('database_charset', CharSet);
    SetConfig('database_checktransaction', CheckTransaction);
    SetConfig('database_params', Params.DelimitedText);
    SetConfig('database_username',
      Cript.Sha256Encrypt(Username));
    SetConfig('database_password', Cript.Sha256Encrypt(
      Password));
    SetConfig('database_hostname', HostName);
  end;

end;

procedure TModelConfig.WizardDone;
begin
  SetConfig('show_wizard', false);
end;

end.

