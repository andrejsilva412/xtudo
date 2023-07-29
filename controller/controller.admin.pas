unit controller.admin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.user, controller.empresa;

type

  { TAdministrativo }

  TAdministrativo = class
    private
      FUser: TUser;
      FEmpresa: TEmpresa;
    public
      destructor Destroy; override;
      function Empresa: TEmpresa;
      function User: TUser;
  end;

implementation

{ TAdministrativo }

destructor TAdministrativo.Destroy;
begin
  if Assigned(FUser) then
    FreeAndNil(FUser);
  if Assigned(FEmpresa) then
    FreeAndNil(FEmpresa);
  inherited Destroy;
end;

function TAdministrativo.Empresa: TEmpresa;
begin
  if not Assigned(FEmpresa) then
    FEmpresa := TEmpresa.Create;
  Result := FEmpresa;
end;

function TAdministrativo.User: TUser;
begin
  if not Assigned(FUser) then
    FUser := TUser.Create;
  Result := FUser;
end;

end.

