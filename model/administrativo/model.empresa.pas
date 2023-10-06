unit model.empresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, Controls, controller.empresa, model.dataset;

type

  { TModelEmpresa }

  TModelEmpresa = class(TModelDataSet)
    private
      function Insert(AEmpresa: TEmpresa): Integer;
      function Update(AEmpresa: TEmpresa): Integer;
    public
      constructor Create;
      function Get(AEmpresa: TEmpresa): Boolean;
      function Post(AEmpresa: TEmpresa): Integer;
  end;

implementation

{ TModelEmpresa }

function TModelEmpresa.Insert(AEmpresa: TEmpresa): Integer;
begin

  if Search('id', '', [], 0) > 0 then
    raise Exception.Create('O sistema não permite multiempresa.');

  AEmpresa.ID := GetNextID();

  Result := inherited Insert('id = :id, nome = :nome, fantasia = :fantasia, cnpj = :cnpj, '
    + 'inscricaoestadual = :ie, endereco = :endereco, numero = :numero, '
    + 'complemento = :complemento, bairro = :bairro, cidade = :cidade, uf = :uf, '
    + 'cep = :cep', [AEmpresa.ID, AEmpresa.Nome, AEmpresa.NomeFantasia,
    AEmpresa.CNPJ, AEmpresa.InscricaoEstadual, AEmpresa.Endereco.Logradouro,
    AEmpresa.Endereco.Numero, AEmpresa.Endereco.Complemento, AEmpresa.Endereco.Bairro,
    AEmpresa.Endereco.Cidade.Nome, AEmpresa.Endereco.Cidade.UF.Sigla,
    AEmpresa.Endereco.CEP]);

end;

function TModelEmpresa.Update(AEmpresa: TEmpresa): Integer;
begin

  Result := inherited Update('nome = :nome, fantasia = :fantasia, cnpj = :cnpj, '
    + 'inscricaoestadual = :ie, endereco = :endereco, numero = :numero, '
    + 'complemento = :complemento, bairro = :bairro, cidade = :cidade, '
    + 'uf = :uf, cep = :cep',
    'where id = :id',
    [AEmpresa.Nome, AEmpresa.NomeFantasia, AEmpresa.CNPJ,
    AEmpresa.InscricaoEstadual, AEmpresa.Endereco.Logradouro,
    AEmpresa.Endereco.Numero, AEmpresa.Endereco.Complemento, AEmpresa.Endereco.Bairro,
    AEmpresa.Endereco.Cidade.Nome, AEmpresa.Endereco.Cidade.UF.Sigla,
    AEmpresa.Endereco.CEP, AEmpresa.ID]);

end;

constructor TModelEmpresa.Create;
begin
  TableName := 'empresa';
end;

function TModelEmpresa.Get(AEmpresa: TEmpresa): Boolean;
var
  ADataSet: TBufDataset;
begin

  ADataSet := TBufDataset.Create(nil);
  Result := false;
  try
    Select('*', '', [], ADataSet);
    AEmpresa.Clear;
    if not ADataSet.IsEmpty then
    begin
      AEmpresa.ID := ADataSet.FieldByName('id').AsInteger;
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
      AEmpresa.Endereco.CEP := ADataSet.FieldByName('cep').AsString;
      Result := true;
    end;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelEmpresa.Post(AEmpresa: TEmpresa): Integer;
begin

  StartTransaction();
  Result := mrNone;
  try
    if AEmpresa.ID = 0 then
      Result := Insert(AEmpresa)
    else
      Result := Update(AEmpresa);
    Commit();
    Result := mrOK;
  except
    on E: Exception do
    begin
      RollBack();
      raise Exception.Create(E.Message);
    end;
  end;

end;

end.

