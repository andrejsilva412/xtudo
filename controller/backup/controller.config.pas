unit controller.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, BCButton, BCTypes, BCButtonFocus,
  BGRABitmapTypes, uhtmlutils, ucript, json.files;

type

  { TBaseConfig }

  TBaseConfig = class
  private
    FCript: TCript;
    FDirectory: String;
    FFileName: String;
    FJSON: TFPJson;
    procedure SetFileName(AValue: String);
  protected
    function GetConfig(AConfig: String; ADefault: String): String; overload;
    function GetConfig(AConfig: String; ADefault: Boolean): Boolean; overload;
    procedure SetConfig(AConfig: String; AValue: String); overload;
    procedure SetConfig(AConfig: String; AValue: Boolean); overload;
    procedure Get; virtual;
    function Cript: TCript;
    property FileName: String read FFileName write SetFileName;
    property Directory: String read FDirectory write FDirectory;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type

  { TConfigTheme }

  TConfigTheme = class(TBaseConfig)
    private
      FHTMLUtils: THTMLUtils;
      FBackGround1: TColor;
      FBackGround2: TColor;
      FFileTheme: String;
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
      constructor Create;
      destructor Destroy; override;
      procedure SetBcButtonStyle(Button: TBCButtonFocus);
      property FileTheme: String read FFileTheme;
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
      function CheckDB: Boolean;
      property CharSet: String read FCharSet;
      property CheckTransaction: Boolean read FCheckTransaction write FCheckTransaction;
      property DatabaseName: String read FDatabaseName write FDatabaseName;
      property HostName: String read FHostName write FHostName;
      property Port: Integer read FPort write FPort;
      property Params: TStringList read FParams write FParams;
      property Username: String read FUsername write FUsername;
      property Password: String read FPassword write FPassword;
  end;


type

  TConfig = class
    private
      FTheme: TConfigTheme;
      FDatabase: TConfigDatabase;
    public
      destructor Destroy; override;
      function Theme: TConfigTheme;
      function Database: TConfigDatabase;
  end;

implementation

uses utils, model.database;

{ TConfig }

destructor TConfig.Destroy;
begin
  if Assigned(FTheme) then
    FreeAndNil(FTheme);
  if Assigned(FDatabase) then
    FreeAndNil(FDatabase);
  inherited Destroy;
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

{ TConfigTheme }

procedure TConfigTheme.Get;
var
  FDefault: String;
begin

  Directory := '';
  FileName := '';

  FDefault := 'theme' + PathDelim + 'default.json';
  FFileTheme := GetConfig('theme', FDefault);

  with FHTMLUtils do
  begin
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

    Directory := 'theme';
    FileName := 'default.json';

    SetConfig('background1', ColorToHTML(FBackGround1));
    SetConfig('background2', ColorToHTML(FBackGround2));
    SetConfig('foreground', ColorToHTML(FForeGround));
    SetConfig('secondary1', ColorToHTML(FSecondary1));
    SetConfig('secondary2', ColorToHTML(FSecondary2));
    SetConfig('secondary3', ColorToHTML(FSecondary3));
    SetConfig('secondary4', ColorToHTML(FSecondary4));
    SetConfig('secondary5', ColorToHTML(FSecondary5));
    SetConfig('secondary6', ColorToHTML(FSecondary6));
    SetConfig('secondary7', ColorToHTML(FSecondary7));
  end;

end;

constructor TConfigTheme.Create;
begin
  inherited;
  FHTMLUtils := THTMLUtils.Create;
end;

destructor TConfigTheme.Destroy;
begin
  FreeAndNil(FHTMLUtils);
  inherited Destroy;
end;

procedure TConfigTheme.SetBcButtonStyle(Button: TBCButtonFocus);
begin

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

end;

{ TBaseConfig }

constructor TBaseConfig.Create;
begin

  FJSON := TFPJson.Create;
  FileName := '';
  Directory := '';
  Get;

end;

destructor TBaseConfig.Destroy;
begin
  if Assigned(FCript) then
    FreeAndNil(FCript);
  FreeAndNil(FJSON);
  inherited Destroy;
end;

procedure TBaseConfig.SetFileName(AValue: String);
var
  AFile: TStringList;
begin

  if FDirectory = '' then
    FDirectory := {$ifdef windows} 'config' {$else} '.config' {$endif};
  if not DirectoryExists(FDirectory) then
    CreateDir(FDirectory);

  if AValue = '' then
    AValue := 'config.json';

  FFileName := AValue;

  FFileName := FDirectory + PathDelim + FFileName;
  if not FileExists(FFileName) then
  begin
    AFile := TStringList.Create;
    try
      AFile.SaveToFile(FFileName);
    finally
      FreeAndNil(AFile);
    end;
  end;

end;

function TBaseConfig.GetConfig(AConfig: String; ADefault: String): String;
begin

  FJSON.FileName := FFileName;
  Result := FJSON.ReadString(AConfig, ADefault);

end;

function TBaseConfig.GetConfig(AConfig: String; ADefault: Boolean): Boolean;
begin
  FJSON.FileName := FFileName;
  Result := FJSON.ReadBoolean(AConfig, ADefault);
end;

procedure TBaseConfig.SetConfig(AConfig: String; AValue: String);
begin

  FJSON.FileName := FFileName;
  FJSON.WriteString(AConfig, AValue);

end;

procedure TBaseConfig.SetConfig(AConfig: String; AValue: Boolean);
begin
  FJSON.FileName := FFileName;
  FJSON.WriteBoolean(AConfig, AValue);
end;

procedure TBaseConfig.Get;
begin

end;

function TBaseConfig.Cript: TCript;
begin
  if not Assigned(FCript) then
    FCript := TCript.Create;
  Result := FCript;
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
begin
  FParams := TStringList.Create;
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
  Get;

end;

function TConfigDatabase.CheckDB: Boolean;
var
  FDB: TModelDataBase;
begin

  FDB := TModelDataBase.Create;
  try
    Result := FDB.Connected;
  finally
    FreeAndNil(FDB);
  end;

end;

end.

