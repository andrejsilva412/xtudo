unit controller.user;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.crud;

type

  { TUser }

  TUser = class(TControllerCRUD)
    private
      FGUID: String;
      FNome: String;
      FPassword: String;
      FUsername: String;
    protected
      procedure Valida; override;
    public
      function Delete: Integer; override;
      function Post: Integer; override;
      procedure Get(AUserName: String);
      procedure GetPage(APage: Integer = 1); override;
      property GUID: String read FGUID write FGUID;
      property Nome: String read FNome write FNome;
      property Username: String read FUsername write FUsername;
      property Password: String read FPassword write FPassword;
  end;

implementation

uses uconst, model.user;

{ TUser }

procedure TUser.Valida;
begin
  if FNome = '' then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Nome']));
  if FUsername = '' then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Username']));
  if not Validador.MinPasswordLength(FPassword) then
    raise Exception.Create(SMSGSenhaTamanhoMinimo);
end;

function TUser.Delete: Integer;
begin
  Result := inherited Delete;
end;

function TUser.Post: Integer;
var
  MUser: TModelUser;
begin
  MUser := TModelUser.Create;
  try
    inherited Post;
    Result := MUser.Post(Self);
  finally
    FreeAndNil(MUser);
  end;
end;

procedure TUser.Get(AUserName: String);
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    MUser.Get(AUserName, Self);
  finally
    FreeAndNil(MUser);
  end;

end;

procedure TUser.GetPage(APage: Integer);
begin
  inherited GetPage(APage);
end;

end.

