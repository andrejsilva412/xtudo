unit view.cadmovfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  rxdbcurredit, rxmemds, rxdbcomb, view.bascadastro, DB;

type

  TTipo = (tEntrada, tSaida);

type

  { TfrmCadMovFinanceiro }

  TfrmCadMovFinanceiro = class(TfrmBasCadastro)
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    mdMovimento: TRxMemoryData;
    mdMovimentohistorico: TStringField;
    mdMovimentoidcontacorrente: TLongintField;
    mdMovimentotipo: TLongintField;
    mdMovimentovalor: TCurrencyField;
    RxDBComboBox1: TRxDBComboBox;
    RxDBCurrEdit1: TRxDBCurrEdit;
    procedure acSalvarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FIDContaCorrente: Integer;
    FTipo: TTipo;
    procedure SetTipo(AValue: TTipo);
  public
    property IDContaCorrente: Integer read FIDContaCorrente write FIDContaCorrente;
    property Tipo: TTipo read FTipo write SetTipo;
  end;

var
  frmCadMovFinanceiro: TfrmCadMovFinanceiro;

implementation

uses utils;

{$R *.lfm}

{ TfrmCadMovFinanceiro }

procedure TfrmCadMovFinanceiro.FormShow(Sender: TObject);
begin
  inherited;
  mdMovimento.CloseOpen;
  mdMovimento.Insert;
  mdMovimentotipo.AsInteger := iif(FTipo = tEntrada, 0, 1);
  mdMovimentoidcontacorrente.AsInteger := FIDContaCorrente;
end;

procedure TfrmCadMovFinanceiro.FormCreate(Sender: TObject);
begin
  inherited;
  RxDBComboBox1.Enabled := false;
end;

procedure TfrmCadMovFinanceiro.acSalvarExecute(Sender: TObject);
begin
  inherited;
  if Validado then
  begin
    with Sistema.Financeiro do
    begin
      Movimento.DataMovimento := Now;
      Movimento.ContaCorrente.ID := mdMovimentoidcontacorrente.AsInteger;
      Movimento.Historico := mdMovimentohistorico.AsString;
      Movimento.Valor := mdMovimentovalor.AsCurrency;
      case Tipo of
        tEntrada: ModalResult := Movimento.PostEntrada;
        tSaida: ModalResult := Movimento.PostSaida;
      end;
    end;
  end;
end;

procedure TfrmCadMovFinanceiro.SetTipo(AValue: TTipo);
begin
  FTipo := AValue;
  if FTipo = tEntrada then
  begin
    Caption := 'Movimento Financeiro - Entrada';
  end else begin
    Caption := 'Movimento Financeiro - Saida';
  end;
end;

end.

