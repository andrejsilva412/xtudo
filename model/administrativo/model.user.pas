unit model.user;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.user, BufDataset, model.crud;

type

  { TModelUser }

  TModelUser = class(TModelCRUD)
    private
      function Insert(AUSer: TUser): Integer;
      function Update(AUSer: TUser): Integer;
    public
      constructor Create;
      function AdministradorCadastrado: Boolean;
      procedure Get(AUserName: String; APassword: String; AUser: TUser);
      function Post(AUser: TUser): Integer;
  end;

implementation

uses utypes;

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

procedure TModelUser.Get(AUserName: String; APassword: String; AUser: TUser);
var
  ADataSet: TBufDataset;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    if APassword <> '' then
    begin
      APassword := GetPasswordHash(APassword);
      Select('usuario', '*', 'where username = :username and senha = :senha',
        [AUserName, APassword], ADataSet);
    end else begin
      Select('usuario', '*', 'where username = :username',
        [AUserName], ADataSet);
    end;
    if not ADataSet.IsEmpty then
    begin
      AUser.GUID := ADataSet.FieldByName('guid').AsString;
      AUser.Username := ADataSet.FieldByName('username').AsString;
      AUser.UserType := IntegerToUserType(ADataSet.FieldByName('tipo').AsInteger);
    end;
    ADataSet.Close;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelUser.Post(AUser: TUser): Integer;
begin

  StartTransaction;
  try
    Get(AUser.Username, '', AUser);
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

end.

