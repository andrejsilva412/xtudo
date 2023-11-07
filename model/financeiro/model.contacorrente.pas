unit model.contacorrente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Controls, SysUtils, BufDataset, model.dataset, controller.contacorrente;

type

  { TModelContaCorrente }

  TModelContaCorrente = class(TModelDataSet)
    private
      function Insert(AContaCorrente: TContaCorrente): Integer;
      function Update(AContaCorrente: TContaCorrente): Integer;
    public
      constructor Create;
      function AtualizaSaldo(AID: Integer): Integer;
      function GetSaldo(AID: Integer): Currency;
      function Get(AID: Integer; AContaCorrente: TContaCorrente): Integer; overload;
      function Get(AContaCorrente: TContaCorrente; APage: Integer): Integer; overload;
      function Post(AContaCorrente: TContaCorrente): Integer;
  end;

implementation

uses uconst;

{ TModelContaCorrente }

function TModelContaCorrente.Insert(AContaCorrente: TContaCorrente): Integer;
begin

  AContaCorrente.ID := inherited GetNextID();

  Result := inherited Insert('id = :id, idbanco = :idbanco, '
    + 'numero = :numero, dataabertura = :dataabertura, saldo = :saldo',
    [AContaCorrente.ID, AContaCorrente.Banco.ID, AContaCorrente.Numero,
    AContaCorrente.Abertura, AContaCorrente.Saldo]);

end;

function TModelContaCorrente.Update(AContaCorrente: TContaCorrente): Integer;
begin

  Result := inherited Update('idbanco = :idbanco, numero = :numero, '
    + 'dataabertura = :dataabertura, saldo = :saldo', 'where id = :id', [AContaCorrente.Banco.ID,
     AContaCorrente.Numero, AContaCorrente.Abertura, AContaCorrente.Saldo, AContaCorrente.ID]);

end;

constructor TModelContaCorrente.Create;
begin

  inherited;
  TableName := 'contacorrente';

end;

function TModelContaCorrente.AtualizaSaldo(AID: Integer): Integer;
begin
  StartTransaction();
  try
    Result := inherited Update('saldo = :saldo', 'where id = :id',
      [GetSaldo(AID), AID]);
    Commit();
  except
    on E: Exception do
    begin
      RollBack();
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TModelContaCorrente.GetSaldo(AID: Integer): Currency;
begin

  Result := SelectCurr('movfinanceiro', 'SUM(movfinanceiro.valor)',
    'WHERE movfinanceiro.idconta = :idconta', [AID], 0);

end;

function TModelContaCorrente.Get(AID: Integer; AContaCorrente: TContaCorrente
  ): Integer;
var
  ADataSet: TBufDataset;
begin

  Result := C_REG_NOT_FOUND;
  ADataSet := TBufDataset.Create(nil);
  try
    Select('id, idbanco, dataabertura, numero, saldo', 'where id = :id', [AID], ADataSet);
      AContaCorrente.Clear;
      if not ADataSet.IsEmpty then
      begin
        AContaCorrente.ID := ADataSet.FieldByName('id').AsInteger;
        AContaCorrente.Abertura := ADataSet.FieldByName('dataabertura').AsDateTime;
        AContaCorrente.Banco.ID := ADataSet.FieldByName('idbanco').AsInteger;
        AContaCorrente.Banco.Get(AContaCorrente.Banco.ID);
        AContaCorrente.Numero := ADataSet.FieldByName('numero').AsString;
        AContaCorrente.Saldo := ADataSet.FieldByName('saldo').AsCurrency;
        Result := C_REG_FOUND;
      end;
    finally
      FreeAndNil(ADataSet);
    end;

end;

function TModelContaCorrente.Get(AContaCorrente: TContaCorrente; APage: Integer
  ): Integer;
var
  ADataSet: TBufDataset;
  ARecords, AMaxPage: Integer;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    Result := C_REG_FOUND;
    AMaxPage := 1;
    ARecords := Select('id, dataabertura, idbanco, numero, saldo', '', [],
                           'count(contacorrente.id) total', 'total', APage,
                           AMaxPage, ADataSet);
    ADataSet.First;
    AContaCorrente.Data.Clear;
    AContaCorrente.Data.MaxPage := AMaxPage;
    while not ADataSet.EOF do
    begin
      DoProgress(ADataSet.RecNo, ARecords);
      with AContaCorrente.Data.Add do
      begin
        This.ID := ADataSet.FieldByName('id').AsInteger;
        This.Banco.ID := ADataSet.FieldByName('idbanco').AsInteger;
        This.Banco.Get(This.Banco.ID);
        This.Abertura := ADataSet.FieldByName('dataabertura').AsDateTime;
        This.numero := ADataSet.FieldByName('numero').AsString;
        This.saldo := ADataSet.FieldByName('saldo').AsCurrency;
      end;
      ADataSet.Next;
    end;
    ADataSet.Close;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelContaCorrente.Post(AContaCorrente: TContaCorrente): Integer;
begin

  StartTransaction;
  Result := mrNone;
  try
    if AContaCorrente.ID = 0 then
      Result := Insert(AContaCorrente)
    else
      Result := Update(AContaCorrente);
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

end.

