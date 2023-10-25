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
    Button2: TButton;
    cboContaCorrente: TComboBox;
    edHistorico: TEdit;
    FrameDataInicialFinal1: TFrameDataInicialFinal;
    Label1: TLabel;
    Label2: TLabel;
    mdMovFinanceiro: TRxMemoryData;
    mdMovFinanceirodata: TDateTimeField;
    mdMovFinanceirohistorico: TStringField;
    mdMovFinanceiroid: TLongintField;
    mdMovFinanceirovalor: TCurrencyField;
    Panel2: TPanel;
    procedure acGenerico1Execute(Sender: TObject);
    procedure acGenerico2Execute(Sender: TObject);
    procedure cboContaCorrenteChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  protected
    procedure SetStyle; override;
  public

  end;

var
  frmMovFinanceiro: TfrmMovFinanceiro;

implementation

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
  i, Page: Integer;
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
  Page := 1;
  repeat
    Sistema.Financeiro.ContaCorrente.GetPage(Page);
    MaxPage := Sistema.Financeiro.ContaCorrente.Data.MaxPage;
    for i := 0 to Sistema.Financeiro.ContaCorrente.Data.Count -1 do
    begin
      cboContaCorrente.Items.Add(
        Sistema.Financeiro.ContaCorrente.Data.Items[i].This.Banco.Nome);
      cboContaCorrente.Values.Add(
        IntToStr(Sistema.Financeiro.ContaCorrente.Data.Items[i].This.ID));
    end;
    inc(Page);
  until Page > MaxPage;
end;

procedure TfrmMovFinanceiro.acGenerico2Execute(Sender: TObject);
begin

  if Sistema.Forms.Financeiro.MovimentoEntrada(
    StrToIntDef(cboContaCorrente.Values[cboContaCorrente.ItemIndex], 0))  = mrOK then
     LoadPage;
end;

procedure TfrmMovFinanceiro.cboContaCorrenteChange(Sender: TObject);
begin
  LoadPage;
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

