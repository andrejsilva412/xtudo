unit model.endereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ACBrCEP, BufDataset, controller.endereco, model.crud;

type

  { TModelEndereco }

  TModelEndereco = class(TModelCRUD)
    private
      procedure CreateTableEndereco;
    public
      function BuscaCEP(ACEP: String; AEndereco: TEndereco): Boolean;
  end;

implementation

uses uformats;

{ TModelEndereco }

procedure TModelEndereco.CreateTableEndereco;
begin

  if not TableExists('endereco', true) then
  begin
    SQL.Clear;
    SQL.Add('CREATE TABLE "endereco" (');
    SQL.Add('"cep"	INTEGER NOT NULL UNIQUE,');
    SQL.Add('"logradouro"	TEXT,');
    SQL.Add('"complemento"	TEXT,');
    SQL.Add('"bairro"	TEXT,');
    SQL.Add('"municipio"	TEXT,');
    SQL.Add('"municipio_ibge"	TEXT,');
    SQL.Add('"uf"	TEXT,');
    SQL.Add('"uf_ibge"	TEXT);');
    StartTransaction(true);
    ExecuteDirect(SQL, true);
    Commit(true);
  end;

end;

function TModelEndereco.BuscaCEP(ACEP: String; AEndereco: TEndereco): Boolean;
var
  ADataSet: TBufDataset;
  ACBRCEP: TACBrCEP;
  cache: Boolean;
begin

  ADataSet := TBufDataset.Create(nil);
  ACBRCEP := TACBrCEP.Create(nil);

  // Provedor de pesquisa ACBRCep
  ACBRCEP.WebService := wsViaCep;

  try
    Result := false;
    cache := false;
    ACEP := FormataCEP(ACEP);
    if not Validador.CEP(ACEP) then
      exit;

    CreateTableEndereco;
    AEndereco.Clear;
    Select('endereco', '*', 'where cep = :cep', [ACEP], ADataSet, true);
    if not ADataSet.IsEmpty then
    begin
      AEndereco.CEP := ADataSet.FieldByName('cep').AsString;
      AEndereco.Logradouro := ADataSet.FieldByName('logradouro').AsString;
      AEndereco.Complemento := ADataSet.FieldByName('complemento').AsString;
      AEndereco.Bairro := ADataSet.FieldByName('bairro').AsString;
      AEndereco.Cidade.Nome := ADataSet.FieldByName('municipio').AsString;
      AEndereco.Cidade.IBGE := ADataSet.FieldByName('municipio_ibge').AsString;
      AEndereco.Cidade.UF.Sigla := ADataSet.FieldByName('uf').AsString;
      AEndereco.Cidade.UF.IBGE := ADataSet.FieldByName('uf_ibge').AsString;
      cache := true;
      Result := true;
    end else begin
      if ACBRCEP.BuscarPorCEP(ACEP) > 0 then
      begin
        with ACBRCEP.Enderecos[0] do
        begin
          AEndereco.CEP := CEP;
          AEndereco.Logradouro := Tipo_Logradouro + ' ' + Logradouro;
          AEndereco.Complemento := Complemento;
          AEndereco.Bairro := Bairro;
          AEndereco.Cidade.Nome := Municipio;
          AEndereco.Cidade.IBGE := IBGE_Municipio;
          AEndereco.Cidade.UF.Sigla := UF;
          AEndereco.Cidade.UF.IBGE := IBGE_UF;
        end;
      end;
    end;
    if (AEndereco.CEP <> '') and (not cache) then
    begin
      StartTransaction(true);
      try
        Insert('endereco', 'cep = :cep, logradouro = :logradouro, '
          + 'complemento = :complemento, bairro = :bairro, '
          + 'municipio = :municipio, municipio_ibge = :municipio_ibge, '
          + 'uf = :uf, uf_ibge = :uf_ibge', [AEndereco.CEP,
           AEndereco.Logradouro, AEndereco.Complemento,
           AEndereco.Bairro, AEndereco.Cidade.Nome,
           AEndereco.Cidade.IBGE, AEndereco.Cidade.UF.Sigla,
           AEndereco.Cidade.UF.IBGE], true);
        Commit(true);
        Result := true;
      except
        on E: Exception do
        begin
          RollBack();
          raise Exception.Create(E.Message);
        end;
      end;
    end;
  finally
    FreeAndNil(ACBRCEP);
    FreeAndNil(ADataSet);
  end;

end;

end.

