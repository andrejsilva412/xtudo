unit controller.forms;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms;

type

  { TForms }

  TForms = class
    private
      function FormExists(FormClass: TFormClass): Boolean;
    public
      destructor Destroy; override;
      procedure ShowWizard;
      procedure CloseWizard;
      procedure ShowUsuario;
      function ShowCadastroUsuario: Integer;
  end;

implementation

uses view.main, view.assistenteinicial, view.usuario, view.cadusuario;

{ TForms }

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
  if not FormExists(TfrmUsuario) then
    frmUsuario := TfrmUsuario.Create(Application);
  frmMain.TDINoteBook1.ShowFormInPage(frmUsuario);
end;

function TForms.ShowCadastroUsuario: Integer;
begin

  frmCadUsuario := TfrmCadUsuario.Create(Application);
  try
    Result := frmCadUsuario.ShowModal;
  finally
    FreeAndNil(frmCadUsuario);
  end;

end;

end.

