unit controller.admin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.user;

type

  { TAdministrativo }

  TAdministrativo = class
    private
      FUser: TUser;
    public
      destructor Destroy; override;
      function User: TUser;
  end;

implementation

{ TAdministrativo }

destructor TAdministrativo.Destroy;
begin
  if Assigned(FUser) then
    FreeAndNil(FUser);
  inherited Destroy;
end;

function TAdministrativo.User: TUser;
begin
  if not Assigned(FUser) then
    FUser := TUser.Create;
  Result := FUser;
end;

end.

