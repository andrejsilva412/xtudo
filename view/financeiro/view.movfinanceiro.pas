unit view.movfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  rxdbcomb, rxmemds, view.dbgrid, uframeperiodo, DB;

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
    mdMovFinanceirodata: TDateTimeField;
    mdMovFinanceirohistorico: TStringField;
    mdMovFinanceiroid: TLongintField;
    mdMovFinanceirovalor: TCurrencyField;
    Panel2: TPanel;
    procedure acNovoExecute(Sender: TObject);
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

{ TfrmMovFinanceiro }

procedure TfrmMovFinanceiro.FormCreate(Sender: TObject);
begin
  inherited;
  acSalvar.Visible := false;
  cboContaCorrente.Items.Clear;
  cboContaCorrente.Text := EmptyStr;
end;

procedure TfrmMovFinanceiro.acNovoExecute(Sender: TObject);
begin
  if Sistema.Forms.Financeiro.CadastrarMovimento = mrOK then
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

