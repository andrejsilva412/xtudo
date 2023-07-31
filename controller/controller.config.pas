unit controller.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, BCButton, BCTypes, BCButtonFocus,
  BGRABitmapTypes, ucript;

type

  { TBaseConfig }

  TBaseConfig = class
  private
    FCript: TCript;
  protected
    function Cript: TCript;
    function GetConfig(AConfig: String; ADefault: String; Global: Boolean = false): String; overload;
    function GetConfig(AConfig: String; ADefault: Boolean; Global: Boolean = false): Boolean; overload;
    procedure SetConfig(AConfig: String; AValue: String; Global: Boolean = false); overload;
    procedure SetConfig(AConfig: String; AValue: Boolean; Global: Boolean = false); overload;
    procedure Get; virtual;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type

  { TConfigTheme }

  TConfigTheme = class(TBaseConfig)
    private
      FBackGround1: TColor;
      FBackGround2: TColor;
      FForeGround: TColor;
      FSecondary1: TColor;
      FSecondary2: TColor;
      FSecondary3: TColor;
      FSecondary4: TColor;
      FSecondary5: TColor;
      FSecondary6: TColor;
      FSecondary7: TColor;
    protected
      procedure Get; override;
    public
      procedure SetBcButtonStyle(Button: TBCButtonFocus);
      property BackGround1: TColor read FBackGround1;
      property BackGround2: TColor read FBackGround2;
      property ForeGround: TColor read FForeGround;
      property Secondary1: TColor read FSecondary1;
      property Secondary2: TColor read FSecondary2;
      property Secondary3: TColor read FSecondary3;
      property Secondary4: TColor read FSecondary4;
      property Secondary5: TColor read FSecondary5;
      property Secondary6: TColor read FSecondary6;
      property Secondary7: TColor read FSecondary7;
  end;

type

  { TConfigDatabase }

  TConfigDatabase = class(TBaseConfig)
    private
      FCacheDatabase: String;
      FCharSet: String;
      FCheckTransaction: Boolean;
      FDatabaseName: String;
      FHostName: String;
      FParams: TStringList;
      FPassword: String;
      FPort: Integer;
      FUsername: String;
    protected
      procedure Get; override;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Save;
      function CheckDBConnection: Boolean;
      function CheckCacheConnection: Boolean;
      property CharSet: String read FCharSet;
      property CheckTransaction: Boolean read FCheckTransaction write FCheckTransaction;
      property DatabaseName: String read FDatabaseName write FDatabaseName;
      property HostName: String read FHostName write FHostName;
      property Port: Integer read FPort write FPort;
      property Params: TStringList read FParams write FParams;
      property Username: String read FUsername write FUsername;
      property Password: String read FPassword write FPassword;
      property CacheDatabase: String read FCacheDatabase;
  end;


type

  TConfig = class(TBaseConfig)
    private
      FTheme: TConfigTheme;
      FDatabase: TConfigDatabase;
    public
      destructor Destroy; override;
      procedure Inicializa;
      function Theme: TConfigTheme;
      function Database: TConfigDatabase;
      function ShowWizard: Boolean;
      procedure WizardDone;
  end;

implementation

uses utils, uhtmlutils, uconst, model.config;

{ TConfig }

destructor TConfig.Destroy;
begin
  if Assigned(FTheme) then
    FreeAndNil(FTheme);
  if Assigned(FDatabase) then
    FreeAndNil(FDatabase);
  inherited Destroy;
end;

procedure TConfig.Inicializa;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.CreateConfigTable;
  finally
    FreeAndNil(MConfig);
  end;

end;

function TConfig.Theme: TConfigTheme;
begin

  if not Assigned(FTheme) then
    FTheme := TConfigTheme.Create;
  Result := FTheme;

end;

function TConfig.Database: TConfigDatabase;
begin
  if not Assigned(FDatabase) then
    FDatabase := TConfigDatabase.Create;

  Result := FDatabase;
end;

function TConfig.ShowWizard: Boolean;
begin

  Result := GetConfig('show_wizard', false);

end;

procedure TConfig.WizardDone;
begin

  SetConfig('show_wizard', false, false);

end;

{ TConfigTheme }

procedure TConfigTheme.Get;
var
  FHTMLUtils: THTMLUtils;
begin

  FHTMLUtils := THTMLUtils.Create;
  try

    with FHTMLUtils do
    begin
      // Seta os valores Default

      FBackGround1 := HTMLToColor('#272727');
      FBackGround2 := HTMLToColor('#2F0505');
      FForeGround := HTMLToColor('#85311B');
      FSecondary1 := HTMLToColor('#C1853B');
      FSecondary2 := HTMLToColor('#DB9327');
      FSecondary3 := HTMLToColor('#CC1B1B');
      FSecondary4 := HTMLToColor('#9E9E9E');
      FSecondary5 := HTMLToColor('#E2C52C');
      FSecondary6 := HTMLToColor('#0CA147');
      FSecondary7 := HTMLToColor('#F4F4F4');

      FBackGround1 := HTMLToColor(GetConfig(
        'background1', ColorToHTML(FBackGround1)));
      FBackGround2 := HTMLToColor(GetConfig(
        'background2', ColorToHTML(FBackGround2)));
      FForeGround := HTMLToColor(GetConfig(
        'foreground',  ColorToHTML(FForeGround)));
      FSecondary1 := HTMLToColor(GetConfig(
        'secondary1',  ColorToHTML(FSecondary1)));
      FSecondary2 := HTMLToColor(GetConfig(
        'secondary2',  ColorToHTML(FSecondary2)));
      FSecondary3 := HTMLToColor(GetConfig(
         'secondary3', ColorToHTML(FSecondary3)));
      FSecondary4 := HTMLToColor(GetConfig(
         'secondary4', ColorToHTML(FSecondary4)));
      FSecondary5 := HTMLToColor(GetConfig(
         'secondary5', ColorToHTML(FSecondary5)));
      FSecondary6 := HTMLToColor(GetConfig(
         'secondary6', ColorToHTML(FSecondary6)));
      FSecondary7 := HTMLToColor(GetConfig(
         'secondary7',  ColorToHTML(FSecondary7)));
    end;

  finally
    FreeAndNil(FHTMLUtils);
  end;

end;

procedure TConfigTheme.SetBcButtonStyle(Button: TBCButtonFocus);
var
  FHTMLUtils: THTMLUtils;
begin

  FHTMLUtils := THTMLUtils.Create;
  try
    with Button do
    begin
      with StateNormal do
      begin
        with Background do
        begin
          Style := bbsColor;
          Color := FHTMLUtils.HTMLToColor('#85311B');
        end;
        with Border do
        begin
          Style := bboSolid;
          Color := Background.Color;
        end;
        with FontEx do
        begin
          Color := InvertColor(Background.Color);
          FontQuality := fqSystemClearType;
        end;
      end;

      with StateHover do
      begin
        with Background do
        begin
          Style := bbsColor;
          Color := FHTMLUtils.HTMLToColor('#85311B');
          ColorOpacity := 235;
        end;
        with Border do
        begin
          Style := bboSolid;
          Color := Background.Color;
        end;
        with FontEx do
        begin
          FontQuality := fqSystemClearType;
        end;
      end;
      StateClicked.Assign(StateNormal);
    end;
  finally
    FreeAndNil(FHTMLUtils);
  end;

end;

{ TBaseConfig }

destructor TBaseConfig.Destroy;
begin
  if Assigned(FCript) then
    FreeAndNil(FCript);
  inherited Destroy;
end;

function TBaseConfig.Cript: TCript;
begin
  if not Assigned(FCript) then
    FCript := TCript.Create;
  Result := FCript;
end;

function TBaseConfig.GetConfig(AConfig: String; ADefault: String;
  Global: Boolean): String;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    Result := MConfig.GetConfig(ADefault, Global);
    Result := iif(Result = '', ADefault, Result);
  finally
    FreeAndNil(MConfig);
  end;

end;

procedure TBaseConfig.SetConfig(AConfig: String; AValue: String; Global: Boolean
  );
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.SetConfig(AConfig, AValue, Global);
  finally
    FreeAndNil(MConfig);
  end;

end;

procedure TBaseConfig.SetConfig(AConfig: String; AValue: Boolean;
  Global: Boolean);
var
  lBoolean: String;
begin

  lBoolean := iif(AValue = true, '1', '0');
  SetConfig(AConfig, lBoolean, Global);

end;

function TBaseConfig.GetConfig(AConfig: String; ADefault: Boolean;
  Global: Boolean): Boolean;
var
  lResult: String;
begin

  lResult := GetConfig(AConfig, '', Global);
  Result := iif(lResult = '', ADefault, true);

end;

procedure TBaseConfig.Get;
begin

end;

constructor TBaseConfig.Create;
begin
  inherited;
end;

{ TConfigDatabase }

procedure TConfigDatabase.Get;
var
  aDef: String;
begin

  aDef := Path + 'database' + PathDelim + 'XTUDO.FDB';
  FDatabaseName := GetConfig('database_filename', '');
  if FDatabaseName = '' then
    SetConfig('database_filename', aDef);
  FDatabaseName := GetConfig('database_filename', aDef);
  FHostName := GetConfig('database_hostname', 'localhost');
  FCharSet := GetConfig('database_charset', 'WIN1252');
  FCheckTransaction := GetConfig('database_checktransaction', false);
  FParams.Clear;
  FParams.DelimitedText :=
    GetConfig('database_params', 'isc_tpb_read_committed');
  FUsername :=
    Cript.Sha256Decrypt(
        GetConfig('database_username', ''));
  FPassword :=
    Cript.Sha256Decrypt(
        GetConfig('database_password', ''));
end;

constructor TConfigDatabase.Create;
var
  FConfigFolder: String;
begin

  FParams := TStringList.Create;

  FConfigFolder := GetAppConfigDir(false);
  if not DirectoryExists(FConfigFolder) then
    CreateDir(FConfigFolder);

  FConfigFolder := FConfigFolder + 'cache.db';

  FCacheDatabase := FConfigFolder;
  inherited;

end;

destructor TConfigDatabase.Destroy;
begin
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TConfigDatabase.Save;
begin

  SetConfig('database_filename', FDatabaseName);
  SetConfig('database_charset', FCharSet);
  SetConfig('database_checktransaction', FCheckTransaction);
  SetConfig('database_params', FParams.DelimitedText);
  SetConfig('database_username',
    Cript.Sha256Encrypt(FUsername));
  SetConfig('database_password', Cript.Sha256Encrypt(
    FPassword));
  SetConfig('database_hostname', FHostName);
  Get;

end;

function TConfigDatabase.CheckDBConnection: Boolean;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    Result := MConfig.Connected(false);
  finally
    FreeAndNil(MConfig);
  end;

end;

function TConfigDatabase.CheckCacheConnection: Boolean;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    Result := MConfig.Connected(true);
  finally
    FreeAndNil(MConfig);
  end;

end;

end.

