unit controller.sistema;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, utema, json.files;

type

  { TSistema }

  TSistema = class
    private
      FDefaultFileTheme: String;
      FTema: TTema;
      FFPJSON: TFPJson;
      procedure ReadConfiFile;
    public
      constructor Create;
      destructor Destroy; override;
      function DiretorioUsuario: String;
      function Tema: TTema;
      function JSON: TFPJson;
      property DefaultFileTheme: String read FDefaultFileTheme write FDefaultFileTheme;
  end;

implementation

uses utils;

{ TSistema }

procedure TSistema.ReadConfiFile;
begin

  if not DirectoryExists('config') then
    CreateDir('config');

  Self.JSON.FileName := 'config\config.json';
  if not FileExists(Self.JSON.FileName) then
    Self.JSON.WriteString('theme', 'theme\default.json');
  FDefaultFileTheme := Self.JSON.ReadString('theme', 'theme\default.json');

end;

constructor TSistema.Create;
begin

  // Se não existir cria o arquivo de configuração
  ReadConfiFile;
  Self.Tema.SetTheme(FDefaultFileTheme);

end;

destructor TSistema.Destroy;
begin

  if Assigned(FTema) then
    FreeAndNil(FTema);
  if Assigned(FFPJSON) then
    FreeAndNil(FFPJSON);

  inherited Destroy;
end;

function TSistema.DiretorioUsuario: String;
begin

  Result := Path;

end;

function TSistema.Tema: TTema;
begin

  if not Assigned(FTema) then
    FTema := TTema.Create;
  Result := FTema;

end;

function TSistema.JSON: TFPJson;
begin

  if not Assigned(FFPJSON) then
    FFPJSON := TFPJson.Create;
  Result := FFPJSON;

end;

end.

