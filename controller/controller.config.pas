unit controller.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, BCTypes, BCButtonFocus,
  BGRABitmapTypes;

type

  { TBaseConfig }

  TBaseConfig = class
    protected
      function GetGlobalConfigFolder: String;
    public
      procedure CreateGlobalConfigFolder;
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
    public
      constructor Create;
      procedure SetBcButtonStyle(Button: TBCButtonFocus);
      property BackGround1: TColor read FBackGround1 write FBackGround1;
      property BackGround2: TColor read FBackGround2 write FBackGround2;
      property ForeGround: TColor read FForeGround write FForeGround;
      property Secondary1: TColor read FSecondary1 write FSecondary1;
      property Secondary2: TColor read FSecondary2 write FSecondary2;
      property Secondary3: TColor read FSecondary3 write FSecondary3;
      property Secondary4: TColor read FSecondary4 write FSecondary4;
      property Secondary5: TColor read FSecondary5 write FSecondary5;
      property Secondary6: TColor read FSecondary6 write FSecondary6;
      property Secondary7: TColor read FSecondary7 write FSecondary7;
  end;

type

  { TConfigDatabase }

  TConfigDatabase = class(TBaseConfig)
    private
      FCacheDatabase: String;
      FCharSet: String;
      FDatabaseName: String;
      FHostName: String;
      FParams: TStringList;
      FPassword: String;
      FPort: Integer;
      FUsername: String;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Get;
      procedure Save;
      function CheckDBConnection: Boolean;
      function CheckCacheConnection: Boolean;
      procedure CreateConfigTable;
      property CharSet: String read FCharSet write FCharSet;
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
      FShowWizard: Boolean;
      FTheme: TConfigTheme;
      FDatabase: TConfigDatabase;
    public
      destructor Destroy; override;
      procedure Get;
      function Theme: TConfigTheme;
      function Database: TConfigDatabase;
      procedure WizardDone;
      property ShowWizard: Boolean read FShowWizard write FShowWizard;
    end;

implementation

uses utils,  model.config;

{ TConfig }

destructor TConfig.Destroy;
begin
  if Assigned(FTheme) then
    FreeAndNil(FTheme);
  if Assigned(FDatabase) then
    FreeAndNil(FDatabase);
  inherited Destroy;
end;

procedure TConfig.Get;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.Get(Self);
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

procedure TConfig.WizardDone;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.WizardDone;
  finally
    FreeAndNil(MConfig);
  end;

end;

{ TBaseConfig }

function TBaseConfig.GetGlobalConfigFolder: String;
begin
  Result := GetAppConfigDir(true);
  if not DirectoryExists(Result) then
  begin
    if not CreateDir(Result) then
    begin
      Result := Path + PathDelim + {$ifdef windows} 'config'; {$else} '.config'; {$endif}
      CreateDir(Result);
    end;
  end
end;

procedure TBaseConfig.CreateGlobalConfigFolder;
begin
  CreateDir(GetGlobalConfigFolder);
end;

{ TConfigTheme }

constructor TConfigTheme.Create;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.Get(Self);
  finally
    FreeAndNil(MConfig);
  end;

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
        Color := Self.ForeGround;
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
        Color := Self.ForeGround;
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

{ TConfigDatabase }

procedure TConfigDatabase.Get;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.Get(Self);
  finally
    FreeAndNil(MConfig);
  end;

end;

constructor TConfigDatabase.Create;
begin
  FParams := TStringList.Create;
  FCacheDatabase := GetGlobalConfigFolder + PathDelim + 'cache.db';
  inherited;
end;

destructor TConfigDatabase.Destroy;
begin
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TConfigDatabase.Save;
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.Save(Self);
    Get;
  finally
    FreeAndNil(MConfig);
  end;

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

procedure TConfigDatabase.CreateConfigTable;
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

end.

