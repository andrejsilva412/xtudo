unit model.banco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, BufDataset, controller.banco, model.dataset;

type

  { TModelBanco }

  TModelBanco = class(TModelDataSet)
    private
      function Insert(ABanco: TBanco): Integer;
      function Update(ABanco: TBanco): Integer;
    public
      constructor Create;
      function Get(AID: Integer; ABanco: TBanco): Integer; overload;
      function Get(ABanco: TBanco; APage: Integer): Integer; overload;
      function Post(ABanco: TBanco): Integer;
  end;

implementation

uses utypes, uconst;

{ TModelBanco }

function TModelBanco.Insert(ABanco: TBanco): Integer;
begin

  ABanco.ID := inherited GetNextID();

  Result := inherited Insert('id = :id, codigo = :codigo, '
    + 'nome = :nome', [ABanco.ID, ABanco.Codigo, ABanco.Nome]);

end;

function TModelBanco.Update(ABanco: TBanco): Integer;
begin

  Result := inherited Update('codigo = :codigo, nome = :nome',
    'where id = :id', [ABanco.Codigo, ABanco.Nome, ABanco.ID]);

end;

constructor TModelBanco.Create;
begin
  inherited;
  TableName := 'banco';
end;

function TModelBanco.Get(AID: Integer; ABanco: TBanco): Integer;
var
  ADataSet: TBufDataset;
begin

  Result := C_REG_NOT_FOUND;
  ADataSet := TBufDataset.Create(nil);
  try
    Select('id, codigo, nome', 'where id = :id', [AID], ADataSet);
    ABanco.Clear;
    if not ADataSet.IsEmpty then
    begin
      ABanco.ID := ADataSet.FieldByName('id').AsInteger;
      ABanco.Codigo := ADataSet.FieldByName('codigo').AsString;
      ABanco.Nome := ADataSet.FieldByName('nome').AsString;
      Result := C_REG_FOUND;
    end;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelBanco.Get(ABanco: TBanco; APage: Integer): Integer;
var
  ADataSet: TBufDataset;
  ARecords, AMaxPage: Integer;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    Result := C_REG_FOUND;
    AMaxPage := 1;
    ARecords := Select('id, codigo, nome', '', [],
                           'count(banco.id) total', 'total', APage,
                           AMaxPage, ADataSet);
    ADataSet.First;
    ABanco.Data.Clear;
    ABanco.Data.MaxPage := AMaxPage;
    while not ADataSet.EOF do
    begin
      DoProgress(ADataSet.RecNo, ARecords);
      with ABanco.Data.Add do
      begin
        This.ID := ADataSet.FieldByName('id').AsInteger;
        This.Codigo := ADataSet.FieldByName('codigo').AsString;
        This.Nome := ADataSet.FieldByName('nome').AsString;
      end;
      ADataSet.Next;
    end;
    ADataSet.Close;
  finally
    FreeAndNil(ADataSet);
  end;

end;

function TModelBanco.Post(ABanco: TBanco): Integer;
begin

  StartTransaction;
  Result := mrNone;
  try
    if ABanco.ID = 0 then
      Result := Insert(ABanco)
    else
      Result := Update(ABanco);
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

