unit model.user;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.user, model.crud, BufDataset,

  usyserror;

type

  { TModelUser }

  TModelUser = class(TModelCRUD)
    private
      function Insert(AUSer: TUser): Integer;
      function Update(AUSer: TUser): Integer;
    public
      constructor Create;
      function AdministradorCadastrado: Boolean;
      function Get(AGUID: String; AUser: TUser): Integer; overload;
      function Get(AUserName: String; APassword: String; AUser: TUser): Integer; overload;
      function Get(AUser: TUser; APage: Integer): Integer; overload;
      function Post(AUser: TUser): Integer;
      procedure SaveLoggedUser(AUser: TUser);
      procedure GetLoggedUser(AUser: TUser);
      procedure LogOut(AUser: TUser);
  end;

implementation

uses utypes, uconst, model.config;

{ TModelUser }

function TModelUser.Insert(AUSer: TUser): Integer;
begin

  AUSer.GUID := NewGUID;
  AUSer.Password := GetPasswordHash(AUSer.Password);
  Result := inherited Insert('usuario', 'guid = :guid, nome = :nome, '
    + 'username = :username, senha = :senha, tipo = :tipo',
    [AUSer.GUID, AUSer.Nome, AUSer.Username, AUSer.Password,
     UserTypeToInteger(AUSer.UserType)]);

end;

function TModelUser.Update(AUSer: TUser): Integer;
begin

  AUSer.Password := GetPasswordHash(AUSer.Password);
  Result := inherited Update('usuario', 'nome = :nome, username = :username, '
    + 'senha = :senha, tipo = :tipo', 'where guid = :guid',
    [AUSer.Nome, AUSer.Username, AUSer.Password,
    UserTypeToInteger(AUSer.UserType), AUSer.GUID]);

end;

constructor TModelUser.Create;
begin
  inherited;
end;

function TModelUser.AdministradorCadastrado: Boolean;
begin

  Result := Search('usuario', 'guid', 'where tipo = :tipo',
    [1], false);

end;

function TModelUser.Get(AUserName: String; APassword: String; AUser: TUser
  ): Integer;
begin

  if APassword <> '' then
  begin
    APassword := GetPasswordHash(APassword);
    AUser.GUID := Search('usuario', 'guid', 'where username = :username and senha = :senha',
      [AUserName, APassword], '');
  end else begin
    AUser.GUID := Search('usuario', 'guid', 'where username = :username',
      [AUserName], '');
  end;
  Result := Get(AUser.GUID, AUser);

end;

function TModelUser.Get(AUser: TUser; APage: Integer): Integer;
var
  ADataSet: TBufDataset;
  ARecords, AMaxPage: Integer;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    Result := C_REG_FOUND;
    AMaxPage := 1;
    ARecords := Select('usuario', 'guid, nome, username, tipo', '', [],
                           'count(usuario.guid) total', 'total', APage,
                           AMaxPage, ADataSet);
    ADataSet.First;
    AUser.Data.Clear;
    AUser.Data.MaxPage := AMaxPage;
    while not ADataSet.EOF do
    begin
      DoProgress(ADataSet.RecNo, ARecords);
      with AUser.Data.Add do
      begin
        This.GUID := ADataSet.FieldByName('guid').AsString;
        This.Nome := ADataSet.FieldByName('nome').AsString;
        This.Username := ADataSet.FieldByName('username').AsString;
        This.UserType := IntegerToUserType(
           ADataSet.FieldByName('tipo').AsInteger);
      end;
      ADataSet.Next;
    end;
    ADataSet.Close;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelUser.Get(AGUID: String; AUser: TUser): Integer;
var
  ADataSet: TBufDataset;
  Str: String;
begin

  Result := C_REG_NOT_FOUND;
  ADataSet := TBufDataset.Create(nil);
  try
    Select('usuario', 'guid, nome, username, tipo',
      'where guid = :guid', [AGUID], ADataSet);
    AUser.Clear;
    if not ADataSet.IsEmpty then
    begin
      AUser.GUID := ADataSet.FieldByName('guid').AsString;
      AUser.Nome := ADataSet.FieldByName('nome').AsString;
      AUser.Username := ADataSet.FieldByName('username').AsString;
      AUser.UserType := IntegerToUserType(ADataSet.FieldByName('tipo').AsInteger);
{      Str := GetBase64Content('usuario', 'guid', AUser.GUID, 'foto');
      if Str <> '' then
        Image.Base64ToPNG(Str, AUser.Image.Picture.PNG);  }
      Result := C_REG_FOUND;
    end;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelUser.Post(AUser: TUser): Integer;
begin

  StartTransaction;
  try
    //Get(AUser.Username, '', AUser);
    if AUser.GUID = '' then
      Result := Insert(AUser)
    else Result := Update(AUser);
    Commit;
  except
    on E: Exception do
    begin
      RollBack;
      raise Exception.Create(E.Message);
    end;
  end;

end;

procedure TModelUser.SaveLoggedUser(AUser: TUser);
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.Save(AUser);
  finally
    FreeAndNil(MConfig);
  end;

end;

procedure TModelUser.GetLoggedUser(AUser: TUser);
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.Get(AUser);
  finally
    FreeAndNil(MConfig);
  end;

end;

procedure TModelUser.LogOut(AUser: TUser);
var
  MConfig: TModelConfig;
begin

  MConfig := TModelConfig.Create;
  try
    MConfig.LogOutUser;
  finally
    FreeAndNil(MConfig);
  end;

end;

end.

