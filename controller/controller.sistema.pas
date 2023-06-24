unit controller.sistema;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, Dialogs, LMessages, utema, uimage, json.files;

type

  { TMensagem }

  TMensagem = class
    public
      function Excluir: Boolean;
  end;

type

  { TSistema }

  TSistema = class
    private
      FDefaultFileTheme: String;
      FTema: TTema;
      FFPJSON: TFPJson;
      FImage: TImages;
      FMessagem: TMensagem;
      procedure ReadConfiFile;
    public
      constructor Create;
      destructor Destroy; override;
      function DiretorioUsuario: String;
      function Tema: TTema;
      function JSON: TFPJson;
      function Image: TImages;
      function Mensagem: TMensagem;
      property DefaultFileTheme: String read FDefaultFileTheme write FDefaultFileTheme;
  end;

implementation

uses utils, uconst;

{ TMensagem }

function TMensagem.Excluir: Boolean;
begin

  Result := false;
  with TTaskDialog.Create(nil) do
  begin
    try
      Title := SMSTituloExcluir;
      Caption := C_EXCLUIR;
      Text := SMSGExcluir;
      CommonButtons := [];
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := C_EXCLUIR;
        ModalResult := mrYes;
      end;
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := C_CANCELAR;
        ModalResult := mrNo;
      end;
      MainIcon := tdiQuestion;
      if Execute then
        if ModalResult = mrYes then
          Result := true;
    finally
      Free;
    end;
  end;

end;

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
  if Assigned(FImage) then
    FreeAndNil(FImage);
  if Assigned(FMessagem) then
    FreeAndNil(FMessagem);
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

function TSistema.Image: TImages;
begin
  if not Assigned(FImage) then
    FImage := TImages.Create;
  Result := FImage;
end;

function TSistema.Mensagem: TMensagem;
begin
  if not Assigned(FMessagem) then
    FMessagem := TMensagem.Create;
  Result := FMessagem;
end;

end.

