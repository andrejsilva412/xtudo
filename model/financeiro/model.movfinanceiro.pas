unit model.movfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, controller.movfinanceiro, model.dataset;

type

  { TModelMovFinanceiro }

  TModelMovFinanceiro = class(TModelDataSet)
    private
      procedure AtualizaSaldoContaCorrente(AIDContaCorrente:  Integer);
      function GetSaldo(AIDContaCorrente: Integer): Currency;
    public
      constructor Create;
      function Post(AMovFinanceiro: TMovFinanceiro): Integer;
      function Get(AMovFinanceiro: TMovFinanceiro; APage: Integer): Integer; overload;
  end;

implementation

uses uconst, udatabaseutils, model.contacorrente;

{ TModelMovFinanceiro }

constructor TModelMovFinanceiro.Create;
begin
  inherited;
  TableName := 'movfinanceiro';
end;

procedure TModelMovFinanceiro.AtualizaSaldoContaCorrente(
  AIDContaCorrente: Integer);
var
  ASaldo: Currency;
  MContaCorrente: TModelContaCorrente;
begin

  MContaCorrente := TModelContaCorrente.Create;
  try
    ASaldo := SelectCurr('movfinanceiro', 'SUM(movfinanceiro.valor)',
      'WHERE movfinanceiro.idconta = :idconta', [AIDContaCorrente], 0);
    MContaCorrente.AtualizaSaldo(AIDContaCorrente, ASaldo);
  finally
    FreeAndNil(MContaCorrente);
  end;

end;

function TModelMovFinanceiro.GetSaldo(AIDContaCorrente: Integer): Currency;
begin



end;

function TModelMovFinanceiro.Post(AMovFinanceiro: TMovFinanceiro): Integer;
begin

  StartTransaction();
  try
    AMovFinanceiro.ID := GetNextID();
    Result := inherited Insert('id = :id, idconta = :idconta, data = :data, historico = :historico, '
     + 'valor = :valor', [AMovFinanceiro.ID, AMovFinanceiro.ContaCorrente.ID, AMovFinanceiro.DataMovimento,
       AMovFinanceiro.Historico, AMovFinanceiro.Valor]);
    Commit();
    AtualizaSaldoContaCorrente(AMovFinanceiro.ContaCorrente.ID);
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
  sLimit: String;
  MContaCorrente: TModelContaCorrente;
begin

  MContaCorrente := TModelContaCorrente.Create;
  ADataSet := TBufDataset.Create(nil);
  try
    Result := C_REG_FOUND;

    ARecords := Select('movfinanceiro', 'count(movfinanceiro.id)',
      'inner join contacorrente on contacorrente.id = movfinanceiro.idconta '
      + 'where date(movfinanceiro.data) between :data1 and :data and movfinanceiro.idconta = :idconta', [
       AMovFinanceiro.Periodo.Inicio, AMovFinanceiro.Periodo.Fim, AMovFinanceiro.ContaCorrente.ID], 0);

    AMaxPage := MaxPage(ARecords);
    sLimit := SetLimit(GetOffSet(APage));

    Select('(SELECT movfinanceiro.id, movfinanceiro.`data`, banco.id idbanco, banco.codigo codbanco, banco.nome banco, '
     + 'contacorrente.numero contacorrente, movfinanceiro.historico, '
     + 'case when SIGN(movfinanceiro.valor) = -1 then '
     + 'movfinanceiro.valor ELSE 0 END saida, case when SIGN(movfinanceiro.valor) = 1 then '
     + 'movfinanceiro.valor ELSE 0 END entrada, SUM(movfinanceiro.valor) OVER(order BY movfinanceiro.id) saldo_atual '
     + 'FROM movfinanceiro INNER JOIN contacorrente ON contacorrente.id = movfinanceiro.idconta '
     + 'INNER JOIN banco ON banco.id = contacorrente.idbanco WHERE movfinanceiro.idconta = :idconta) mov',
       'mov.id, mov.data, mov.codbanco, mov.banco, mov.contacorrente, mov.historico, '
     + 'mov.saldo_atual - (mov.entrada + mov.saida ) saldo_anterior, '
     + 'mov.entrada, mov.saida, mov.saldo_atual', 'where date(mov.data) between :data1 and :data '
     + ' ORDER BY mov.id ' + sLimit  + '', [
       AMovFinanceiro.ContaCorrente.ID, AMovFinanceiro.Periodo.Inicio, AMovFinanceiro.Periodo.Fim], ADataSet);
    AtualizaSaldoContaCorrente(AMovFinanceiro.ContaCorrente.ID);
    ADataSet.First;
    AMovFinanceiro.Data.Clear;
    AMovFinanceiro.Data.MaxPage := AMaxPage;
    while not ADataSet.EOF do
    begin
      DoProgress(ADataSet.RecNo, ADataSet.RecordCount);
      with AMovFinanceiro.Data.Add do
      begin
        This.ID := ADataSet.FieldByName('id').AsInteger;
        This.DataMovimento := ADataSet.FieldByName('data').AsDateTime;
        This.ContaCorrente.Banco.Codigo := ADataSet.FieldByName('codbanco').AsString;
        This.ContaCorrente.Banco.Nome := ADataSet.FieldByName('banco').AsString;
        This.ContaCorrente.Numero := ADataSet.FieldByName('contacorrente').AsString;
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

