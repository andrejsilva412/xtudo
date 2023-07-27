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
      procedure Get(AUserName: String; AUser: TUser);
      function Post(AUser: TUser): Integer;
  end;

implementation

{ TModelUser }

function TModelUser.Insert(AUSer: TUser): Integer;
begin

  AUSer.GUID := GetGUID;
  AUSer.Password := GetPasswordHash(AUSer.Password);
  Result := inherited Insert('usuario', 'guid = :guid, nome = :nome, '
    + 'username = :username, senha = :senha',
    [AUSer.GUID, AUSer.Nome, AUSer.Username, AUSer.Password]);

end;

function TModelUser.Update(AUSer: TUser): Integer;
begin

  Result := inherited Update('usuario', 'nome = :nome, username = :username, '
    + 'senha = :senha', 'where guid = :guid',
    [AUSer.Nome, AUSer.Username, AUSer.Password, AUSer.GUID]);

end;

procedure TModelUser.Get(AUserName: String; AUser: TUser);
var
  ADataSet: TBufDataset;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    Select('usuario', '*', 'where username = :username',
      [AUserName], ADataSet);
    if not ADataSet.IsEmpty then
    begin
      AUser.GUID := ADataSet.FieldByName('guid').AsString;
      AUser.Username := ADataSet.FieldByName('username').AsString;
      AUser.Password := ADataSet.FieldByName('senha').AsString;
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
    Get(AUser.Username, AUser);
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

