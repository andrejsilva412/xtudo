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
      procedure Empresa;
      function Usuario: Integer; overload;
      function Usuario(AGUID: String): Integer; overload;
  end;

implementation

uses view.main, view.assistenteinicial, view.usuario, view.cadusuario,
  view.cadempresa;

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

procedure TForms.Empresa;
begin
  frmCadEmpresa := TfrmCadEmpresa.Create(nil);
  try
    frmCadEmpresa.ShowModal;
  finally
    FreeAndNil(frmCadEmpresa);
  end;
end;

function TForms.Usuario: Integer;
begin
  if not FormExists(TfrmUsuario) then
    frmUsuario := TfrmUsuario.Create(nil);
  frmMain.TDINoteBook1.ShowFormInPage(frmUsuario);
  Result := mrIgnore;
end;

function TForms.Usuario(AGUID: String): Integer;
begin

  frmCadUsuario := TfrmCadUsuario.Create(nil);
  try
    if AGUID = '' then
      frmCadUsuario.Insert
    else
      frmCadUsuario.Edit(AGUID);
    Result := frmCadUsuario.ShowModal;
  finally
    FreeAndNil(frmCadUsuario);
  end;

end;

end.

