unit controller.forms;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TForms }

  TForms = class
    public
      destructor Destroy; override;
      procedure ShowWizard;
      procedure CloseWizard;
  end;

implementation

uses view.main, view.assistenteinicial;

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

end.

