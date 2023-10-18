unit controller.formsadministrativo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, utypes;

type

  { TFormAdministrativo }

  TFormAdministrativo = class
    private
      function View(AView: TView; AList: Boolean; AID: Integer): Integer;
    public
      procedure Empresa;
      function Usuario: Integer; overload;
      function Usuario(AID: Integer): Integer; overload;
  end;

implementation

uses utils, view.main, view.usuario, view.cadusuario, view.cadempresa;

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

procedure TFormAdministrativo.Empresa;
begin
  View(vEmpresa, false, 0);
end;

function TFormAdministrativo.Usuario: Integer;
begin
  Result := View(vUsuario, true, 0);
end;

function TFormAdministrativo.Usuario(AID: Integer): Integer;
begin
  Result := View(vUsuario, false, AID);
end;

end.

