unit controller.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, json.files;

type

  { TBaseConfig }

  TBaseConfig = class
  private
    FJSON: TFPJson;
  protected
    function GetConfig(AConfig: String; ADefault: String): String;
    procedure SetConfig(AConfig: String; AValue: String);
    procedure Get; virtual;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type

  { TConfigTheme }

  TConfigTheme = class(TBaseConfig)
    private
      FFileTheme: String;
    protected
      procedure Get; override;
    public
      property FileTheme: String read FFileTheme;
  end;

type

  { TConfigDatabase }

  TConfigDatabase = class(TBaseConfig)
    private
      FFileName: String;
    protected
      procedure Get; override;
    public
      property FileName: String read FFileName write FFileName;
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

  FDefault := 'theme' + PathDelim + 'default.json';
  FFileTheme := GetConfig('theme', '');
  if FFileTheme = '' then
    SetConfig('theme', FDefault);
  FFileTheme := GetConfig('theme', FDefault);
end;

{ TBaseConfig }

constructor TBaseConfig.Create;
var
  FConfigFileName, cDir: String;
  AFile: TStringList;
begin

  FJSON := TFPJson.Create;
  cDir := {$ifdef windows} 'config' {$else} '.config' {$endif};
  if not DirectoryExists(cDir) then
    CreateDir(cDir);
  FConfigFileName := cDir + PathDelim + 'config.json';
  if not FileExists(FConfigFileName) then
  begin
    AFile := TStringList.Create;
    try
      AFile.SaveToFile(FConfigFileName);
    finally
      FreeAndNil(AFile);
    end;
  end;
  FJSON.FileName := FConfigFileName;
  Get;

end;

destructor TBaseConfig.Destroy;
begin
  FreeAndNil(FJSON);
  inherited Destroy;
end;

function TBaseConfig.GetConfig(AConfig: String; ADefault: String): String;
begin

  Result := FJSON.ReadString(AConfig, ADefault);

end;

procedure TBaseConfig.SetConfig(AConfig: String; AValue: String);
begin

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

  FFileName := GetConfig('database_filename', '');
  if FFileName = '' then
    SetConfig('database_filename', aDef);
  FFileName := GetConfig('database_filename', aDef);

end;

end.

