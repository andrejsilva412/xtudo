unit model.user;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, controller.user, model.dataset, BufDataset, usyserror;

type

  { TModelUser }

  TModelUser = class(TModelDataSet)
    private
      function Insert(AUSer: TUser): Integer;
      function Update(AUSer: TUser): Integer;
    public
      constructor Create;
      function AdministradorCadastrado: Boolean;
      function Get(AID: Integer; AUser: TUser): Integer; overload;
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

  AUSer.ID := inherited GetNextID();

  AUSer.Password := GetPasswordHash(AUSer.Password);
  Result := inherited Insert('id = :id, nome = :nome, '
    + 'username = :username, senha = :senha, tipo = :tipo',
    [AUSer.ID, AUSer.Nome, AUSer.Username, AUSer.Password,
    UserTypeToInteger(AUSer.UserType)]);

end;

function TModelUser.Update(AUSer: TUser): Integer;
begin

  AUSer.Password := GetPasswordHash(AUSer.Password);
  Result := inherited Update('nome = :nome, username = :username, '
    + 'senha = :senha, tipo = :tipo', 'where id = :id',
    [AUSer.Nome, AUSer.Username, AUSer.Password,
    UserTypeToInteger(AUSer.UserType), AUSer.ID]);

end;

constructor TModelUser.Create;
begin
  inherited;
  TableName := 'usuario';
end;

function TModelUser.AdministradorCadastrado: Boolean;
begin

  Result := Search('id', 'where tipo = :tipo',
    [1], false);

end;

function TModelUser.Get(AUserName: String; APassword: String; AUser: TUser
  ): Integer;
begin

  if APassword <> '' then
  begin
    APassword := GetPasswordHash(APassword);
    AUser.ID := Search('id', 'where username = :username and senha = :senha',
      [AUserName, APassword], 0);
  end else begin
    AUser.ID := Search('id', 'where username = :username',
      [AUserName], 0);
  end;
  Result := Get(AUser.ID, AUser);

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
    ARecords := Select('id, nome, username, tipo', '', [],
                           'count(usuario.id) total', 'total', APage,
                           AMaxPage, ADataSet);
    ADataSet.First;
    AUser.Data.Clear;
    AUser.Data.MaxPage := AMaxPage;
    while not ADataSet.EOF do
    begin
      DoProgress(ADataSet.RecNo, ARecords);
      with AUser.Data.Add do
      begin
        This.ID := ADataSet.FieldByName('id').AsInteger;
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

function TModelUser.Get(AID: Integer; AUser: TUser): Integer;
var
  ADataSet: TBufDataset;
  Str: String;
begin

  Result := C_REG_NOT_FOUND;
  ADataSet := TBufDataset.Create(nil);
  try
    Select('id, nome, username, tipo',
      'where id = :id', [AID], ADataSet);
    AUser.Clear;
    if not ADataSet.IsEmpty then
    begin
      AUser.ID := ADataSet.FieldByName('id').AsInteger;
      AUser.Nome := ADataSet.FieldByName('nome').AsString;
      AUser.Username := ADataSet.FieldByName('username').AsString;
      AUser.UserType := IntegerToUserType(ADataSet.FieldByName('tipo').AsInteger);
      Result := C_REG_FOUND;
    end;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelUser.Post(AUser: TUser): Integer;
begin

  StartTransaction;
  Result := mrNone;
  try
    if AUser.ID = 0 then
      Result := Insert(AUser)
    else
      Result := Update(AUser);
    Commit;
    if Result > 0 then
      Result := mrOK;
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

