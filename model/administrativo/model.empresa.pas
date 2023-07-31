unit model.empresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, controller.empresa, model.pessoa;

type

  { TModelEmpresa }

  TModelEmpresa = class(TModelPessoa)
    private
      function Insert(AEmpresa: TEmpresa): Integer;
      function Update(AEmpresa: TEmpresa): Integer;
    public
      function Get(AEmpresa: TEmpresa): Boolean;
      function Post(AEmpresa: TEmpresa): Integer;
  end;

implementation

uses utypes;

{ TModelEmpresa }

function TModelEmpresa.Insert(AEmpresa: TEmpresa): Integer;
begin
  if Search('empresa', 'guid', '', [], 0) > 0 then
    raise Exception.Create('O sistema não permite multiempresa.');

  AEmpresa.GUID := NewGUID;

  Result := inherited Insert(
    'empresa', 'guid = :guid, nome = :nome, fantasia = :fantasia, cnpj = :cnpj, '
    + 'inscricaoestadual = :ie, endereco = :endereco, numero = :numero, '
    + 'complemento = :complemento, bairro = :bairro, cidade = :cidade, uf = :uf',
    [AEmpresa.GUID, AEmpresa.Nome, AEmpresa.NomeFantasia, AEmpresa.CNPJ,
    AEmpresa.InscricaoEstadual, AEmpresa.Endereco.Logradouro,
    AEmpresa.Endereco.Numero, AEmpresa.Endereco.Complemento, AEmpresa.Endereco.Bairro,
    AEmpresa.Endereco.Cidade.Nome, AEmpresa.Endereco.Cidade.UF.Sigla]);

end;

function TModelEmpresa.Update(AEmpresa: TEmpresa): Integer;
begin

  Result := inherited Update(
    'empresa', 'nome = :nome, fantasia = :fantasia, cnpj = :cnpj, '
    + 'inscricaoestadual = :ie, endereco = :endereco, numero = :numero, '
    + 'complemento = :complemento, bairro = :bairro, cidade = :cidade, uf = :uf',
    'where guid = :guid',
    [AEmpresa.Nome, AEmpresa.NomeFantasia, AEmpresa.CNPJ,
    AEmpresa.InscricaoEstadual, AEmpresa.Endereco.Logradouro,
    AEmpresa.Endereco.Numero, AEmpresa.Endereco.Complemento, AEmpresa.Endereco.Bairro,
    AEmpresa.Endereco.Cidade.Nome, AEmpresa.Endereco.Cidade.UF.Sigla, AEmpresa.GUID]);

end;

function TModelEmpresa.Get(AEmpresa: TEmpresa): Boolean;
var
  ADataSet: TBufDataset;
begin

  ADataSet := TBufDataset.Create(nil);
  Result := false;
  try
    Select('empresa', '*', '', [], ADataSet);
    AEmpresa.Clear;
    if not ADataSet.IsEmpty then
    begin
      AEmpresa.GUID := ADataSet.FieldByName('guid').AsString;
      AEmpresa.Nome := ADataSet.FieldByName('nome').AsString;
      AEmpresa.NomeFantasia := ADataSet.FieldByName('fantasia').AsString;
      AEmpresa.CNPJ := ADataSet.FieldByName('cnpj').AsString;
      AEmpresa.InscricaoEstadual := ADataSet.FieldByName('inscricaoestadual').AsString;
      AEmpresa.Endereco.Logradouro := ADataSet.FieldByName('endereco').AsString;
      AEmpresa.Endereco.Numero := ADataSet.FieldByName('numero').AsString;
      AEmpresa.Endereco.Complemento := ADataSet.FieldByName('complemento').AsString;
      AEmpresa.Endereco.Bairro := ADataSet.FieldByName('bairro').AsString;
      AEmpresa.Endereco.Cidade.Nome := ADataSet.FieldByName('cidade').AsString;
      AEmpresa.Endereco.Cidade.UF.Sigla := ADataSet.FieldByName('uf').AsString;
      Result := true;
    end;
    inherited Get(tcEmpresa, AEmpresa.Contato);
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelEmpresa.Post(AEmpresa: TEmpresa): Integer;
begin

  StartTransaction();
  try
    if AEmpresa.GUID = '' then
      Result := Insert(AEmpresa)
    else
      Result := Update(AEmpresa);
    inherited Post(AEmpresa.TipoContato, AEmpresa.Contato);
    Commit();
  except
    on E: Exception do
    begin
      RollBack();
      raise Exception.Create(E.Message);
    end;
  end;

end;

end.

