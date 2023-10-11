unit controller.user;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics, controller.pessoa,
  udatacollection, usyserror, utypes;

type

  TUser = class;

type
  TDataUser = class(specialize TDataItem<TUser>);

type

  { TData }

  TData = class(specialize TDataCollecion<TDataUser>)
    public
      function Add: TDataUser;
  end;


type

  { TUser }

  TUser = class(TPessoa)
    private
      FData: TData;
      FImage: TPortableNetworkGraphic;
      FNome: String;
      FPassword: String;
      FUsername: String;
      FUserType: TUserType;
      procedure GetLoggedUser;
    protected
      procedure Valida; override;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear; override;
      function Delete: Integer; override;
      function Post: Integer; override;
      function Get(AUserName: String; APassword: String): Integer;
      function Get(AID: Integer): Integer;
      procedure GetPage(APage: Integer = 1); override;
      procedure LogOut;
      function AdministradorCadastrado: Boolean;
      function Login: Boolean;
      function ConfigFile: String;
      property Nome: String read FNome write FNome;
      property Username: String read FUsername write FUsername;
      property Password: String read FPassword write FPassword;
      property Image: TPortableNetworkGraphic read FImage write FImage;
      property UserType: TUserType read FUserType write FUserType;
      property Data: TData read FData write FData;
  end;

implementation

uses uconst, utils, model.user;

{ TData }

function TData.Add: TDataUser;
begin
  Result := inherited Add as TDataUser;
end;

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
  inherited;
  FUserType := utNormal;
  FData := TData.Create;
  FImage := TPortableNetworkGraphic.Create;
end;

destructor TUser.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FData);
  inherited Destroy;
end;

procedure TUser.Clear;
begin

  inherited;
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
    inherited Post;
    Result := MUser.Post(Self);
  finally
    FreeAndNil(MUser);
  end;
end;

function TUser.Get(AUserName: String; APassword: String): Integer;
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    Result := MUser.Get(AUserName, APassword, Self);
  finally
    FreeAndNil(MUser);
  end;

end;

function TUser.Get(AID: Integer): Integer;
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    Result := MUser.Get(AID, Self);
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
var
  MUser: TModelUser;
begin

  MUser := TModelUser.Create;
  try
    MUser.OnProgress := @DoProgress;
    MUser.Get(Self, APage);
  finally
    FreeAndNil(MUser);
  end;

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
    if ID = 0 then
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
    on E: SysError do
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

