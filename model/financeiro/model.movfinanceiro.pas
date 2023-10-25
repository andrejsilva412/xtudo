unit model.movfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, controller.movfinanceiro, model.dataset;

type

  { TModelMovFinanceiro }

  TModelMovFinanceiro = class(TModelDataSet)
    public
      constructor Create;
      function Post(AMovFinanceiro: TMovFinanceiro): Integer;
      function Get(AMovFinanceiro: TMovFinanceiro; APage: Integer): Integer; overload;
  end;

implementation

uses uconst;

{ TModelMovFinanceiro }

constructor TModelMovFinanceiro.Create;
begin
  inherited;
  TableName := 'movfinanceiro';
end;

function TModelMovFinanceiro.Post(AMovFinanceiro: TMovFinanceiro): Integer;
begin

  StartTransaction();
  try
    AMovFinanceiro.ID := GetNextID();
    Result := inherited Insert('id = :id, idconta = :idconta, data = :data, historico = :historico, '
     + 'valor = :valor', [AMovFinanceiro.ID, AMovFinanceiro.ContaCorrente.ID, AMovFinanceiro.Data,
       AMovFinanceiro.Historico, AMovFinanceiro.Valor]);
    Commit();
  except
    on E: Exception do
    begin
      RollBack();
      raise Exception.Create(E.Message);
    end;
  end;

end;

function TModelMovFinanceiro.Get(AMovFinanceiro: TMovFinanceiro; APage: Integer
  ): Integer;
var
  ADataSet: TBufDataset;
  ARecords, AMaxPage: Integer;
  sIDContaCorrente: String;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    Result := C_REG_FOUND;
    AMaxPage := 1;
    sIDContaCorrente := AMovFinanceiro.ContaCorrente.ID;

    Select('(SELECT movfinanceiro.`data`, banco.codigo codbanco, banco.nome banco, '
     + 'contacorrente.numero contacorrente, movfinanceiro.historico, '
     + 'case when SIGN(movfinanceiro.valor) = -1 then '
     + 'movfinanceiro.valor ELSE 0 END saida, case when SIGN(movfinanceiro.valor) = 1 then '
     + 'movfinanceiro.valor ELSE 0 END entrada, SUM(movfinanceiro.valor) OVER(order BY movfinanceiro.id) saldo_atual '
     + 'FROM movfinanceiro INNER JOIN contacorrente ON contacorrente.id = movfinanceiro.idconta '
     + 'INNER JOIN banco ON banco.id = contacorrente.idbanco '
     + 'WHERE contacorrente.id = ' + sIDContaCorrente + ') mov',
       'mov.data, mov.codbanco, mov.banco, mov.contacorrente, mov.historico, '
     + 'mov.saldo_atual - (mov.entrada + mov.saida) saldo_anterior, '
     + 'mov.entrada, mov.saida, mov.saldo_atual', '', [], ADataSet);

    ADataSet.First;
    AMovFinanceiro.Data.Clear;
    AMovFinanceiro.Data.MaxPage := AMaxPage;
    while not ADataSet.EOF do
    begin
      DoProgress(ADataSet.RecNo, ARecords);
      with AMovFinanceiro.Data.Add do
      begin
        This.DataMovimento := ADataSet.FieldByName('data').AsDateTime;
        This.ContaCorrente.Banco.Codigo := ADataSet.FieldByName('codbanco').AsString;
        This.ContaCorrente.Banco.Nome := ADataSet.FieldByName('banco').AsString;
        This.ContaCorrente.Numero := ADataSet.FieldByName('contacorrente').AsInteger;
        This.Historico := ADataSet.FieldByName('historico').AsString;
        This.SaldoAnterior := ADataSet.FieldByName('saldo_anterior').AsCurrency;
        This.Entrada := ADataSet.FieldByName('entrada').AsCurrency;
        This.Saida := ADataSet.FieldByName('saida').AsCurrency;
        This.SaldoAtual := ADataSet.FieldByName('saldo_atual').AsCurrency;
      end;
      ADataSet.Next;
    end;
    ADataSet.Close;
  finally
    FreeAndNil(ADataSet);
  end;



end;

end.
