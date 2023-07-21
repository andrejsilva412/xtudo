unit controller.sistema;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, Dialogs, LMessages, uimage, controller.config,
  uvalida;

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
      FImage: TImages;
      FMessagem: TMensagem;
      FConfig: TConfig;
      FValidador: TValidador;
    public
      destructor Destroy; override;
      function DiretorioUsuario: String;
      function Image: TImages;
      function Mensagem: TMensagem;
      function Config: TConfig;
      function Validador: TValidador;
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

destructor TSistema.Destroy;
begin

  if Assigned(FImage) then
    FreeAndNil(FImage);
  if Assigned(FMessagem) then
    FreeAndNil(FMessagem);
  if Assigned(FConfig) then
    FreeAndNil(FConfig);
  if Assigned(FValidador) then
    FreeAndNil(FValidador);
  inherited Destroy;
end;

function TSistema.DiretorioUsuario: String;
begin

  Result := Path;

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

function TSistema.Config: TConfig;
begin
  if not Assigned(FConfig) then
    FConfig := TConfig.Create;
  Result := FConfig;
end;

function TSistema.Validador: TValidador;
begin
  if not Assigned(FValidador) then
    FValidador := TValidador.Create;
  Result := FValidador;
end;

end.

