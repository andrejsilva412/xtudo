unit view.movfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  rxmemds, view.dbgrid, uframetitulo, uframeperiodo, DB;

type

  { TComboBox }

  TComboBox = class(StdCtrls.TComboBox)
  private
    FValues: TStringList;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    property Values: TStringList read FValues write FValues;
  end;

type

  { TfrmMovFinanceiro }

  TfrmMovFinanceiro = class(TfrmDBGrid)
    Button1: TButton;
    cboContaCorrente: TComboBox;
    edHistorico: TEdit;
    FrameDataInicialFinal1: TFrameDataInicialFinal;
    Label1: TLabel;
    Label2: TLabel;
    mdMovFinanceiro: TRxMemoryData;
    mdMovFinanceiroconta: TStringField;
    mdMovFinanceirodata: TDateTimeField;
    mdMovFinanceiroentrada: TCurrencyField;
    mdMovFinanceirohistorico: TStringField;
    mdMovFinanceiroid: TLongintField;
    mdMovFinanceirosaida: TCurrencyField;
    mdMovFinanceirosaldoanterior: TCurrencyField;
    mdMovFinanceirosaldoatual: TCurrencyField;
    Panel2: TPanel;
    procedure acGenerico1Execute(Sender: TObject);
    procedure acGenerico2Execute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cboContaCorrenteChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function IDContaCorrente: Integer;
  private
    procedure CarregaMovimento;
  protected
    procedure LoadPage; override;
    procedure SetStyle; override;
  public

  end;

var
  frmMovFinanceiro: TfrmMovFinanceiro;

implementation

uses uconst;

{$R *.lfm}

{ TComboBox }

constructor TComboBox.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FValues := TStringList.Create;
end;

destructor TComboBox.Destroy;
begin
  FreeAndNil(FValues);
  inherited Destroy;
end;

{ TfrmMovFinanceiro }

procedure TfrmMovFinanceiro.FormCreate(Sender: TObject);
var
  i, APage, AMaxPage: Integer;
begin
  inherited;
  acSalvar.Visible := false;
  acNovo.Visible := false;
  cboContaCorrente.Items.Clear;
  cboContaCorrente.Text := EmptyStr;
  acGenerico2.Caption := 'Entrada';
  acGenerico2.Visible := true;
  acGenerico1.Caption := 'Saida';
  acGenerico1.Visible := true;

  cboContaCorrente.Items.Clear;
  cboContaCorrente.Values.Clear;
  APage := 1;
  repeat
    Sistema.Financeiro.ContaCorrente.GetPage(APage);
    AMaxPage := Sistema.Financeiro.ContaCorrente.Data.MaxPage;
    for i := 0 to Sistema.Financeiro.ContaCorrente.Data.Count -1 do
    begin
      cboContaCorrente.Items.Add(
        Sistema.Financeiro.ContaCorrente.Data.Items[i].This.Banco.Nome);
      cboContaCorrente.Values.Add(
        IntToStr(Sistema.Financeiro.ContaCorrente.Data.Items[i].This.ID));
    end;
    inc(APage);
  until APage > AMaxPage;
end;

procedure TfrmMovFinanceiro.FormShow(Sender: TObject);
begin
  inherited;
  CarregaMovimento;

end;

function TfrmMovFinanceiro.IDContaCorrente: Integer;
begin
  if cboContaCorrente.ItemIndex <> -1 then
    Result := StrToIntDef(cboContaCorrente.Values[cboContaCorrente.ItemIndex], 0)
  else
    Result := 0;
end;

procedure TfrmMovFinanceiro.CarregaMovimento;
var
  LMaxPage: Integer;
begin
  with Sistema.Financeiro do
  begin
    Movimento.Periodo.Inicio := FrameDataInicialFinal1.DateTimePicker1.Date;
    Movimento.Periodo.Fim := FrameDataInicialFinal1.DateTimePicker2.Date;
    Movimento.ContaCorrente.ID := IDContaCorrente;
    Movimento.GetPage(1);
    LMaxPage := Movimento.Data.MaxPage;
  end;
  Page := LMaxPage;
  LoadPage;
end;

procedure TfrmMovFinanceiro.LoadPage;
var
  i, APage: Integer;
begin

  APage := Page;
  mdMovFinanceiro.CloseOpen;
  with Sistema.Financeiro do
  begin
    Movimento.OnProgress := @ProgressBar;
    Movimento.Periodo.Inicio := FrameDataInicialFinal1.DateTimePicker1.Date;
    Movimento.Periodo.Fim := FrameDataInicialFinal1.DateTimePicker2.Date;
    Movimento.ContaCorrente.ID := IDContaCorrente;
    Movimento.GetPage(APage);
    MaxPage := Movimento.Data.MaxPage;
    for i := 0 to Movimento.Data.Count -1 do
    begin
      ProgressBar(i+1, Movimento.Data.Count);
      mdMovFinanceiro.Insert;
      mdMovFinanceiroid.AsInteger := Movimento.Data.Items[i].This.ID;
      mdMovFinanceirodata.AsDateTime := Movimento.Data.Items[i].This.DataMovimento;
      mdMovFinanceiroconta.AsString :=
        Movimento.Data.Items[i].This.ContaCorrente.Banco.Codigo + ' ' +
        Movimento.Data.Items[i].This.ContaCorrente.Banco.Nome + ' ' +
        Movimento.Data.Items[i].This.ContaCorrente.Numero;
      mdMovFinanceirohistorico.AsString := Movimento.Data.Items[i].This.Historico;
      mdMovFinanceirosaldoanterior.AsCurrency := Movimento.Data.Items[i].This.SaldoAnterior;
      mdMovFinanceiroentrada.AsCurrency := Movimento.Data.Items[i].This.Entrada;
      mdMovFinanceirosaida.AsCurrency := Movimento.Data.Items[i].This.Saida;
      mdMovFinanceirosaldoatual.AsCurrency := Movimento.Data.Items[i].This.SaldoAtual;
      mdMovFinanceiro.Post;
    end;
    inherited;
  end;

end;

procedure TfrmMovFinanceiro.acGenerico2Execute(Sender: TObject);
begin

  if Sistema.Forms.Financeiro.MovimentoEntrada(
    StrToIntDef(cboContaCorrente.Values[cboContaCorrente.ItemIndex], 0))  = mrOK then
     LoadPage;
end;

procedure TfrmMovFinanceiro.Button1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Button1.Enabled := false;
  try
    CarregaMovimento;
  finally
    Button1.Enabled := true;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMovFinanceiro.cboContaCorrenteChange(Sender: TObject);
begin
  CarregaMovimento;
end;

procedure TfrmMovFinanceiro.acGenerico1Execute(Sender: TObject);
begin
  if Sistema.Forms.Financeiro.MovimentoSaida(
    StrToIntDef(cboContaCorrente.Values[cboContaCorrente.ItemIndex], 0)) = mrOK then
     LoadPage;
end;

procedure TfrmMovFinanceiro.SetStyle;
begin
  inherited SetStyle;
  FrameDataInicialFinal1.Label1.Font.Color := InvertColor(Panel2.Color);
  FrameDataInicialFinal1.Label2.Font.Color := FrameDataInicialFinal1.Label1.Font.Color;
  Label1.Font.Color := FrameDataInicialFinal1.Label1.Font.Color;
  Label2.Font.Color := Label1.Font.Color;
end;

end.

