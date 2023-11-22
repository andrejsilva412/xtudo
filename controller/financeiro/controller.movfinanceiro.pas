unit controller.movfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.dataset, controller.contacorrente, udatacollection;

type

  TMovFinanceiro = class;


type

  TDataMovFinanceiro = class(specialize TDataItem<TMovFinanceiro>);

type

  { TData }

  TData = class(specialize TDataCollecion<TDataMovFinanceiro>)
    public
      function Add: TDataMovFinanceiro;
  end;

type

  { TMovFinanceiro }

  TMovFinanceiro = class(TControllerDataSet)
    private
      FContaCorrente: TContaCorrente;
      FData: TData;
      FDataMovimento: TDateTime;
      FEntrada: Currency;
      FHistorico: String;
      FID: Integer;
      FSaida: Currency;
      FSaldoAnterior: Currency;
      FSaldoAtual: Currency;
      FValor: Currency;
    protected
      procedure Valida; override;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      function Post: Integer; override;
      function PostEntrada: Integer;
      function PostSaida: Integer;
      procedure GetPage(APage: Integer = 1); override;
      property ID: Integer read FID write FID;
      property Data: TData read FData write FData;
      property ContaCorrente: TContaCorrente read FContaCorrente write FContaCorrente;
      property DataMovimento: TDateTime read FDataMovimento write FDataMovimento;
      property Historico: String read FHistorico write FHistorico;
      property Valor: Currency read FValor write FValor;
      property SaldoAnterior: Currency read FSaldoAnterior write FSaldoAnterior;
      property Entrada: Currency read FEntrada write FEntrada;
      property Saida: Currency read FSaida write FSaida;
      property SaldoAtual: Currency read FSaldoAtual write FSaldoAtual;
  end;

implementation

uses uconst, model.movfinanceiro;

{ TData }

function TData.Add: TDataMovFinanceiro;
begin
  Result := inherited as TDataMovFinanceiro;
end;

{ TMovFinanceiro }

procedure TMovFinanceiro.Valida;
begin

  if ContaCorrente.ID = 0 then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Conta Corrente']));

  if FHistorico = '' then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Histórico']));

  if FValor = 0 then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Valor']));

end;

constructor TMovFinanceiro.Create;
begin
  inherited;
  FContaCorrente := TContaCorrente.Create;
  FData := TData.Create;
end;

destructor TMovFinanceiro.Destroy;
begin
  FreeAndNil(FData);
  FreeAndNil(FContaCorrente);
  inherited Destroy;
end;

procedure TMovFinanceiro.Clear;
begin
  FID := 0;
  FContaCorrente.Clear;
  FDataMovimento := 0;
  FHistorico := '';
  FValor := 0;
  FSaldoAnterior := 0;
  FEntrada := 0;
  FSaida := 0;
  FSaldoAtual := 0;
end;

function TMovFinanceiro.Post: Integer;
var
  MMovFinanceiro: TModelMovFinanceiro;
begin

  Valida;

  MMovFinanceiro := TModelMovFinanceiro.Create;
  try
    Result := MMovFinanceiro.Post(Self);
  finally
    FreeAndNil(MMovFinanceiro);
  end;

end;

function TMovFinanceiro.PostEntrada: Integer;
begin

   Result := Post;

end;

function TMovFinanceiro.PostSaida: Integer;
begin

  Valor := Valor *-1;
  Result := Post;

end;

procedure TMovFinanceiro.GetPage(APage: Integer);
var
  MMovFinanceiro: TModelMovFinanceiro;
begin

  MMovFinanceiro := TModelMovFinanceiro.Create;
  try
   MMovFinanceiro.Get(Self, APage);
  finally
    FreeAndNil(MMovFinanceiro);
  end;

end;

end.

