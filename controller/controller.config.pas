unit controller.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, BCButton, BCTypes, BCButtonFocus,
  BGRABitmapTypes, uhtmlutils, json.files;

type

  { TBaseConfig }

  TBaseConfig = class
  private
    FDirectory: String;
    FFileName: String;
    FJSON: TFPJson;
    procedure SetFileName(AValue: String);
  protected
    function GetConfig(AConfig: String; ADefault: String): String;
    procedure SetConfig(AConfig: String; AValue: String);
    procedure Get; virtual;
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
      FDataBaseFileName: String;
    protected
      procedure Get; override;
    public
      property FileName: String read FDataBaseFileName write FDataBaseFileName;
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

uses utils;

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

procedure TBaseConfig.SetConfig(AConfig: String; AValue: String);
begin

  FJSON.FileName := FFileName;
  FJSON.WriteString(AConfig, AValue);

end;

procedure TBaseConfig.Get;
begin

end;

{ TConfigDatabase }

procedure TConfigDatabase.Get;
var
  aDef: String;
begin

  aDef := Path + 'database' + PathDelim + 'XTUDO.FDB';
  FDataBaseFileName := GetConfig('database_filename', '');
  if FDataBaseFileName = '' then
    SetConfig('database_filename', aDef);
  FDataBaseFileName := GetConfig('database_filename', aDef);

end;

end.
