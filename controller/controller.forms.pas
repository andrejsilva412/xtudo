unit controller.forms;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TForms }

  TForms = class
    public
      procedure ShowWizard;
      procedure CloseWizard;
  end;

implementation

uses view.assistenteinicial;

{ TForms }

procedure TForms.ShowWizard;
begin

  frmAssistenteInicial := TfrmAssistenteInicial.Create(nil);
  frmAssistenteInicial.Show;
  frmAssistenteInicial.BringToFront;

end;

procedure TForms.CloseWizard;
begin
  frmAssistenteInicial.Close;
  FreeAndNil(frmAssistenteInicial);
end;

end.

