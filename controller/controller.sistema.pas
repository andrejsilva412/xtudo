unit controller.sistema;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, Dialogs, Forms, LMessages, uimage, controller.config,
  controller.admin, controller.log, uvalida, controller.forms;

type

  { TMensagem }

  TMensagem = class
    private
      procedure GenericTaskDialog
                (ACaption, ATitle, AText: String;
                 ACommonButtons: TTaskDialogCommonButtons;
                  AIcon: TTaskDialogIcon);
    public
      function Excluir: Boolean;
      procedure Alerta(ACaption, ATitle, AText: String); overload;
      procedure Alerta(AText: String); overload;
      procedure Erro(AText: String);
  end;

type

  { TSistema }

  TSistema = class
    private
      FAdministrativo: TAdministrativo;
      FImage: TImages;
      FMessagem: TMensagem;
      FConfig: TConfig;
      FValidador: TValidador;
      FLog: TLog;
      FForms: TForms;
    public
      destructor Destroy; override;
      function Administrativo: TAdministrativo;
      function DiretorioUsuario: String;
      function Image: TImages;
      function Log: TLog;
      function Mensagem: TMensagem;
      function Config: TConfig;
      function Validador: TValidador;
      function ShowWizard: Boolean;
      procedure WizardDone;
      function Forms: TForms;
      procedure Finaliza;
  end;

implementation

uses utils, uconst;

{ TMensagem }

procedure TMensagem.GenericTaskDialog(ACaption, ATitle, AText: String;
  ACommonButtons: TTaskDialogCommonButtons; AIcon: TTaskDialogIcon);
begin

  with TTaskDialog.Create(nil) do
  begin
    try
      Title := ATitle;
      Caption := ACaption;
      Text := AText;
      CommonButtons := ACommonButtons;
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := C_OK;
      end;
      MainIcon := AIcon;
      Execute;
    finally
      Free;
    end;
  end;

end;

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

procedure TMensagem.Alerta(ACaption, ATitle, AText: String);
begin
  GenericTaskDialog(ACaption, ATitle, AText, [], tdiWarning);
end;

procedure TMensagem.Alerta(AText: String);
begin
  Alerta(C_APP_TITLE, C_ATENCAO, AText);
end;

procedure TMensagem.Erro(AText: String);
begin
  GenericTaskDialog(C_APP_TITLE, C_ERRO, AText, [], tdiError);
end;

{ TSistema }

destructor TSistema.Destroy;
begin
  if Assigned(FAdministrativo) then
    FreeAndNil(FAdministrativo);
  if Assigned(FImage) then
    FreeAndNil(FImage);
  if Assigned(FMessagem) then
    FreeAndNil(FMessagem);
  if Assigned(FConfig) then
    FreeAndNil(FConfig);
  if Assigned(FValidador) then
    FreeAndNil(FValidador);
  if Assigned(FLog) then
    FreeAndNil(FLog);
  if Assigned(FForms) then
    FreeAndNil(FForms);
  inherited Destroy;
end;

function TSistema.Administrativo: TAdministrativo;
begin
  if not Assigned(FAdministrativo) then
    FAdministrativo := TAdministrativo.Create;
  Result := FAdministrativo;
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

function TSistema.Log: TLog;
begin
  if not Assigned(FLog) then
    FLog := TLog.Create;
  Result := FLog;
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

function TSistema.ShowWizard: Boolean;
begin
  Self.Config.Get;
  Result := Self.Config.ShowWizard;
  if Result = true then
    exit;
  if not Self.Administrativo.User.AdministradorCadastrado then
    Result := true;
  if not Self.Administrativo.Empresa.Get then
    Result := true;
end;

procedure TSistema.WizardDone;
var
  wd: Boolean;
begin

  wd := true;

  if not Self.Administrativo.User.AdministradorCadastrado then
    wd := false;

  Self.Administrativo.Empresa.Get;
  if Self.Administrativo.Empresa.GUID = '' then
    wd := false;

  if wd then
  begin
    Self.Config.WizardDone;
    Self.Forms.CloseWizard;
  end else Finaliza;

end;

function TSistema.Forms: TForms;
begin
  if not Assigned(FForms) then
    FForms := TForms.Create;
  Result := FForms;
end;

procedure TSistema.Finaliza;
begin
  Application.Terminate;
end;

end.

