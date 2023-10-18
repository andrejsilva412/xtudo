unit controller.forms;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, utypes, controller.formsfinanceiro,
  controller.formsadministrativo, Forms;

type

  { TForms }

  TForms = class
    private
      FAdministrativo: TFormAdministrativo;
      FFinanceiro: TFormFinanceiro;
    public
      destructor Destroy; override;
      procedure ShowWizard;
      procedure CloseWizard;
      function Administrativo: TFormAdministrativo;
      function Financeiro: TFormFinanceiro;
  end;

implementation

uses view.main, view.assistenteinicial;

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

end.

