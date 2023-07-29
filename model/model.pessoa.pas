unit model.pessoa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, utypes, controller.pessoa, model.crud;

type

  { TModelPessoa }

  TModelPessoa = class(TModelCRUD)
    protected
      function Post(ATipoContato: TTipoContato; AContato: TContato): Integer;
      procedure Get(ATipoContato: TTipoContato; AContato: TContato);
  end;

implementation

{ TModelPessoa }

function TModelPessoa.Post(ATipoContato: TTipoContato; AContato: TContato
  ): Integer;
var
  i: Integer;
begin

  // A Transação fica por conta de classe de herança

  Result := inherited Delete('contato', 'where tipo = :tipo',
    [TipoContatoToInteger(ATipoContato)]);

  for i := 0 to AContato.Count -1 do
  begin
    Result := inherited Insert('contato', 'tipo = :tipo, contato = :contato',
      [AContato.Items[i].Tipo, AContato.Items[i].Contato]);
  end;

end;

procedure TModelPessoa.Get(ATipoContato: TTipoContato; AContato: TContato);
var
  ADataSet: TBufDataset;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    Select('contato', 'tipo, contato', 'where tipocontato = :tipocontato',
      [TipoContatoToInteger(ATipoContato)], ADataSet);
    AContato.Clear;
    ADataSet.First;
    while not ADataSet.EOF do
    begin
      with AContato.Add do
      begin
        Tipo := ADataSet.FieldByName('tipo').AsString;
        Contato := ADataSet.FieldByName('contato').AsString;
      end;
      DoProgress(ADataSet.RecNo, ADataSet.RecordCount);
      ADataSet.Next;
    end;
    ADataSet.Close;
  finally
    FreeAndNil(ADataSet);
  end;

end;

end.

