unit controller.user;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.crud, utypes;

type

  { TUser }

  TUser = class(TControllerCRUD)
    private
      FGUID: String;
      FNome: String;
      FPassword: String;
      FUsername: String;
      FUserType: TUserType;
    protected
      procedure Valida; override;
    public
      constructor Create;
      procedure Clear;
      function Delete: Integer; override;
      function Post: Integer; override;
      procedure Get(AUserName: String; APassword: String = '');
      procedure GetPage(APage: Integer = 1); override;
      function AdministradorCadastrado: Boolean;
      function Login: Boolean;
      property GUID: String read FGUID write FGUID;
      property Nome: String read FNome write FNome;
      property Username: String read FUsername write FUsername;
      property Password: String read FPassword write FPassword;
      property UserType: TUserType read FUserType write FUserType;
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

constructor TUser.Create;
begin
  FUserType := utNormal;
end;

procedure TUser.Clear;
begin

  FGUID := '';
  FNome := '';
  FUsername := '';
  FPassword := '';
  FUserType := utNormal;

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
    Valida;
    Result := MUser.Post(Self);
  finally
    FreeAndNil(MUser);
  end;
end;

procedure TUser.Get(AUserName: String; APassword: String);
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    MUser.Get(AUserName, APassword, Self);
  finally
    FreeAndNil(MUser);
  end;

end;

procedure TUser.GetPage(APage: Integer);
begin
  inherited GetPage(APage);
end;

function TUser.AdministradorCadastrado: Boolean;
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    Result := MUser.AdministradorCadastrado;
  finally
    FreeAndNil(MUser);
  end;

end;

function TUser.Login: Boolean;
begin

  Result := false;
  try
    Get(FUsername, FPassword);
    if FGUID = '' then
    begin
      DoStatus('Usuário ou Senha inválido.');
    end else Result := true;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;

end;

end.

