unit controller.forms;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, utypes, Forms;

type

  TFormAdministrativo = class;
  TFormFinanceiro = class;


type

  { TForms }

  TForms = class
    private
      FAdministrativo: TFormAdministrativo;
      FFinanceiro: TFormFinanceiro;
      function Administrativo: TFormAdministrativo;
      function Financeiro: TFormFinanceiro;
    protected
      function FormExists(FormClass: TFormClass): Boolean;
    public
      destructor Destroy; override;
      procedure ShowWizard;
      procedure CloseWizard;
      procedure Empresa;
      function Usuario: Integer; overload;
      function Usuario(AID: Integer): Integer; overload;
      function Banco: Integer; overload;
      function Banco(AID: Integer): Integer; overload;
      function ContaCorrente: Integer; overload;
      function ContaCorrente(AID: Integer): Integer; overload;
  end;

type

  { TFormAdministrativo }

  TFormAdministrativo = class(TForms)
    public
      function View(AView: TView; AList: Boolean; AID: Integer): Integer;
  end;

type

  { TFormFinanceiro }

  TFormFinanceiro = class(TForms)
    public
      function View(AView: TView; AList: Boolean; AID: Integer): Integer;
  end;

implementation

uses view.main, view.assistenteinicial, view.usuario, view.cadusuario,
  view.banco, view.cadbanco, view.contacorrente, view.cadcontacorrente, view.cadempresa;

{ TFormFinanceiro }

function TFormFinanceiro.View(AView: TView; AList: Boolean; AID: Integer
  ): Integer;
begin
  case AView of
    vBanco: begin
      if (AList) then
      begin
        if not FormExists(TfrmBanco) then
          frmBanco := TfrmBanco.Create(nil);
        frmMain.TDINoteBook1.ShowFormInPage(frmBanco);
        Result := mrIgnore;
      end else begin
        frmCadBanco := TfrmCadBanco.Create(nil);
        try
          if AID = 0 then
            frmCadBanco.Insert
          else
            frmCadBanco.Edit(AID);
          Result := frmCadBanco.ShowModal;
        finally
          FreeAndNil(frmCadBanco);
        end;
      end;
    end;
    vContaCorrente: begin
      if (AList) then
      begin
        if not FormExists(TfrmContaCorrente) then
          frmContaCorrente := TfrmContaCorrente.Create(nil);
        frmMain.TDINoteBook1.ShowFormInPage(frmContaCorrente);
        Result := mrIgnore;
      end else begin
        frmCadContaCorrente := TfrmCadContaCorrente.Create(nil);
        try
          if AID = 0 then
            frmCadContaCorrente.Insert
          else
            frmCadContaCorrente.Edit(AID);
          Result := frmCadContaCorrente.ShowModal;
        finally
          FreeAndNil(frmCadContaCorrente);
        end;
      end;
    end;
  end;
end;

{ TFormAdministrativo }

function TFormAdministrativo.View(AView: TView; AList: Boolean; AID: Integer
  ): Integer;
begin

  case AView of
    vEmpresa: begin
      frmCadEmpresa := TfrmCadEmpresa.Create(nil);
      try
        frmCadEmpresa.ShowModal;
      finally
        FreeAndNil(frmCadEmpresa);
      end;
    end;
    vUsuario: begin
      if (AList) then
      begin
        if not FormExists(TfrmUsuario) then
          frmUsuario := TfrmUsuario.Create(nil);
        frmMain.TDINoteBook1.ShowFormInPage(frmUsuario);
        Result := mrIgnore;
      end else begin
        frmCadUsuario := TfrmCadUsuario.Create(nil);
        try
          if AID = 0 then
            frmCadUsuario.Insert
          else
            frmCadUsuario.Edit(AID);
          Result := frmCadUsuario.ShowModal;
        finally
          FreeAndNil(frmCadUsuario);
        end;
      end;
    end;
  end;

end;

{ TForms }

function TForms.Administrativo: TFormAdministrativo;
begin
  if not Assigned(FAdministrativo) then
    FAdministrativo := TFormAdministrativo.Create;
  Result := FAdministrativo;
end;

function TForms.Financeiro: TFormFinanceiro;
begin
  if not Assigned(FFinanceiro) then
    FFinanceiro := TFormFinanceiro.Create;
  Result := FFinanceiro;
end;

function TForms.FormExists(FormClass: TFormClass): Boolean;
var
  i: byte;
begin

  Result := false;

  for i := 0 to Screen.FormCount -1 do
  begin
    if Screen.Forms[i] is FormClass then
    begin
      Result := true;
      break;
    end;
  end;

end;

destructor TForms.Destroy;
begin
  if Assigned(frmAssistenteInicial) then
    FreeAndNil(frmAssistenteInicial);
  if Assigned(FAdministrativo) then
    FreeAndNil(FAdministrativo);
  if Assigned(FFinanceiro) then
    FreeAndNil(FFinanceiro);
  inherited Destroy;
end;

procedure TForms.ShowWizard;
begin

  frmAssistenteInicial := TfrmAssistenteInicial.Create(nil);
  frmAssistenteInicial.Show;
  frmAssistenteInicial.BringToFront;

end;

procedure TForms.CloseWizard;
begin
  frmAssistenteInicial.Hide;
  frmMain.Show;
end;

procedure TForms.Empresa;
begin

  Administrativo.View(vEmpresa, false, 0);

end;

function TForms.Usuario: Integer;
begin

  Result := Administrativo.View(vUsuario, true, 0);

end;

function TForms.Usuario(AID: Integer): Integer;
begin

  Result := Administrativo.View(vUsuario, false, AID);

end;

function TForms.Banco: Integer;
begin

  Result := Financeiro.View(vBanco, true, 0);

end;

function TForms.Banco(AID: Integer): Integer;
begin

  Result := Financeiro.View(vBanco, false, AID);

end;

function TForms.ContaCorrente: Integer;
begin

  Result := Financeiro.View(vContaCorrente, true, 0);

end;

function TForms.ContaCorrente(AID: Integer): Integer;
begin

  Result := Financeiro.View(vContaCorrente, false, AID);

end;

end.

