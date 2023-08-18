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
      procedure GetLoggedUser;
    protected
      procedure Valida; override;
    public
      constructor Create;
      procedure Clear;
      function Delete: Integer; override;
      function Post: Integer; override;
      procedure Get(AUserName: String; APassword: String = '');
      procedure GetPage(APage: Integer = 1); override;
      procedure LogOut;
      function AdministradorCadastrado: Boolean;
      function Login: Boolean;
      function ConfigFile: String;
      property GUID: String read FGUID write FGUID;
      property Nome: String read FNome write FNome;
      property Username: String read FUsername write FUsername;
      property Password: String read FPassword write FPassword;
      property UserType: TUserType read FUserType write FUserType;
  end;

implementation

uses uconst, utils, model.user;

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

procedure TUser.GetLoggedUser;
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    MUser.GetLoggedUser(Self);
  finally
    FreeAndNil(MUser);
  end;

end;

procedure TUser.GetPage(APage: Integer);
begin
  inherited GetPage(APage);
end;

procedure TUser.LogOut;
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    MUser.LogOut(Self);
  finally
    FreeAndNil(MUser);
  end;

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
var
  MUser: TModelUser;
begin

  Result := false;
  try
    Get(FUsername, FPassword);
    if FGUID = '' then
    begin
      DoStatus(SMSGUsuarioOuSenhaInvalido);
    end else begin
      MUser := TModelUser.Create;
      try
        MUser.SaveLoggedUser(Self);
        Result := true;
      finally
        FreeAndNil(MUser);
      end;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;

end;

function TUser.ConfigFile: String;
var
  FFolder: String;
begin

  GetLoggedUser;
  FFolder := Path;
  if FUsername <> '' then
  begin
    FFolder := Path + LowerCase(FUsername);
    if not DirectoryExists(FFolder) then
      CreateDir(FFolder);
  end;
  Result := FFolder + PathDelim + C_FILE_JSON_FORM;

end;

end.

