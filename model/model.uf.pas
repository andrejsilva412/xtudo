unit model.uf;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, udatacollection, BufDataset, model.crud, model.pais;

type

  { UF }

  UF = class(TCollectionItem)
    private
      FEstado: String;
      FSigla: String;
    public
      property Estado: String read FEstado;
      property Sigla: String read FSigla;
  end;

type

  { TUFData }

  TUFData = class(specialize TDataCollecion<UF>)
    public
      constructor Create; override;
      function Add: UF;
  end;

type

  { TModelUF }

  TModelUF = class(TModelCRUD)
    private
      FCodigo: Integer;
      FPais: TModelPais;
      FSigla: String;
      FUFs: TUFData;
      function IsEmpty: Boolean;
      procedure InsertUFs;
    public
      constructor Create;
      destructor Destroy; override;
      procedure GetUFs;
      property Codigo: Integer read FCodigo write FCodigo;
      property Sigla: String read FSigla write FSigla;
      property Pais: TModelPais read FPais;
      property UFs: TUFData read FUFs;
  end;

implementation

{ TUFData }

constructor TUFData.Create;
begin
  inherited Create;
end;

function TUFData.Add: UF;
begin
  Result := inherited Add as UF;
end;

{ TModelUF }

function TModelUF.IsEmpty: Boolean;
begin
  Result := not Search('uf', 'id', 'where sigla = :sigla',
    ['SP'], false, true);
end;

procedure TModelUF.InsertUFs;
var
  sUF: TStringList;
  i: Integer;
begin

  sUF := TStringList.Create;
  try
    sUF.AddObject('Acre', String('AC'));
    sUF.AddObject('Alagoas', String('AL'));
    sUF.AddObject('Amapá', String('AP');
    sUF.AddObject('Amazonas', String('AM'));
    sUF.AddObject('Bahia', String('BA'));
    sUF.AddObject('Ceará', String('CE'));
    sUF.AddObject('Distrito Federal', String('DF'));
    sUF.AddObject('Espírito Santo', String('ES'));
    sUF.AddObject('Goiás', String('GO'));
    sUF.AddObject('Maranhão', String('MA'));
    sUF.AddObject('Mato Grosso', String('MT'));
    sUF.AddObject('Mato Grosso do Sul', String('MS'));
    sUF.AddObject('Minas Gerais', String('MG'));
    sUF.AddObject('Pará', String('PA'));
    sUF.AddObject('Paraíba', String('PB'));
    sUF.AddObject('Paraná', String('PR'));
    sUF.AddObject('Pernambuco', String('PE'));
    sUF.AddObject('Piauí', String('PI'));
    sUF.AddObject('Rio de Janeiro', String('RJ'));
    sUF.AddObject('Rio Grande do Norte', String('RN'));
    sUF.AddObject('Rio Grande do Sul', String('RS'));
    sUF.AddObject('Rondônia', String('RO'));
    sUF.AddObject('Roraima', String('RR'));
    sUF.AddObject('Santa Catarina', String('SC'));
    sUF.AddObject('São Paulo', String('SP'));
    sUF.AddObject('Sergipe', String('SE'));
    sUF.AddObject('Tocantins', String('TO'));

    SQL.Clear;
    SQL.Add('CREATE TABLE "uf" (');
    SQL.Add('"id"	INTEGER NOT NULL UNIQUE,');
    SQL.Add('"estado"	TEXT NOT NULL,');
    SQL.Add('"sigla"	TEXT NOT NULL UNIQUE,');
    SQL.Add('PRIMARY KEY("id"));');
    StartTransaction(true);
    ExecuteDirect(SQL, true);
    SQL.Clear;
    SQL.Add('CREATE INDEX "idx_uf_estado" ON "uf" (');
    SQL.Add('"estado");');
    ExecuteDirect(SQL, true);
    SQL.Clear;
    SQL.Add('CREATE INDEX "idx_uf_sigla" ON "uf" (');
    SQL.Add('"sigla");');
    ExecuteDirect(SQL, true);
    for i := 0 to sUF.Count -1 do
    begin
      Insert('uf', 'id = :id, estado = :estado, sigla = :sigla',
        [GetNextID('uf', 'id', true), sUF[i],
          String(sUF.Objects[i])], true);
    end;
    Commit(true);
  finally
    FreeAndNil(sUF);
  end;

end;

constructor TModelUF.Create;
begin
  FPais := TModelPais.Create;
  FCodigo := 0;
  if IsEmpty then
    InsertUFs;
end;

destructor TModelUF.Destroy;
begin
  if Assigned(FUFs) then
    FreeAndNil(FUFs);
  FreeAndNil(FPais);
  inherited Destroy;
end;

procedure TModelUF.GetUFs;
var
  ADataSet: TBufDataset;
begin

  ADataSet := TBufDataset.Create(nil);
  try
    FUFs.Clear;
    Select('uf', '*', '', [], ADataSet, true);
    ADataSet.First;
    while not ADataSet.EOF do
    begin
      with FUFs.Add do
      begin
        FEstado := ADataSet.FieldByName('estado').AsString;
        FSigla := ADataSet.FieldByName('sigla').AsString;
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

