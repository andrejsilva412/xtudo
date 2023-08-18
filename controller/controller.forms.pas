unit controller.forms;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms;

type

  { TForms }

  TForms = class
    public
      destructor Destroy; override;
      procedure ShowWizard;
      procedure CloseWizard;
      procedure ShowUsuario;
  end;

implementation

uses view.main, view.assistenteinicial, view.usuario;

{ TForms }

destructor TForms.Destroy;
begin
  if Assigned(frmAssistenteInicial) then
    FreeAndNil(frmAssistenteInicial);
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

procedure TForms.ShowUsuario;
begin
  if not Assigned(frmUsuario) then
    frmUsuario := TfrmUsuario.Create(Application);
  frmMain.TDINoteBook1.ShowFormInPage(frmUsuario);
end;

end.

