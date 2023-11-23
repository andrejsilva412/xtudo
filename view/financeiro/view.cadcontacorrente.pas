unit view.cadcontacorrente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  DBDateTimePicker, rxmemds, rxdbcomb, rxdbcurredit, view.bascadastro, DB;

type

  { TfrmCadContaCorrente }

  TfrmCadContaCorrente = class(TfrmBasCadastro)
    DBCheckBox1: TDBCheckBox;
    DBDateTimePicker1: TDBDateTimePicker;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mdContaCorrente: TRxMemoryData;
    mdContaCorrenteabertura: TDateField;
    mdContaCorrentebanco: TStringField;
    mdContaCorrenteid: TLongintField;
    mdContaCorrenteidbanco: TLongintField;
    mdContaCorrentenumero: TStringField;
    mdContaCorrentepadrao: TBooleanField;
    mdContaCorrentesaldo: TCurrencyField;
    RxDBComboBox1: TRxDBComboBox;
    RxDBCurrEdit1: TRxDBCurrEdit;
    procedure acNovoExecute(Sender: TObject);
    procedure acSalvarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure Edit(AID: Integer); override;
  end;

var
  frmCadContaCorrente: TfrmCadContaCorrente;

implementation

{$R *.lfm}

{ TfrmCadContaCorrente }

procedure TfrmCadContaCorrente.FormCreate(Sender: TObject);
var
  Page, MaxPage, i: Integer;
begin
  inherited;
  RxDBComboBox1.Items.Clear;
  RxDBComboBox1.Values.Clear;

  Page := 1;
  repeat

    Sistema.Financeiro.Banco.GetPage(Page);
    MaxPage := Sistema.Financeiro.Banco.Data.MaxPage;
    for i := 0 to Sistema.Financeiro.Banco.Data.Count -1 do
    begin
      with Sistema.Financeiro do
      begin
        RxDBComboBox1.Items.Add(Banco.Data.Items[i].This.Nome);
        RxDBComboBox1.Values.Add(Banco.Data.Items[i].This.ID.ToString);
      end;
    end;
    inc(Page);
  until Page > MaxPage;
  RxDBComboBox1.ItemIndex := 0;

end;

procedure TfrmCadContaCorrente.acSalvarExecute(Sender: TObject);
begin
  inherited;
  Sistema.Financeiro.ContaCorrente.ID := mdContaCorrenteid.AsInteger;
  Sistema.Financeiro.ContaCorrente.Abertura := mdContaCorrenteabertura.AsDateTime;
  Sistema.Financeiro.ContaCorrente.Banco.ID := mdContaCorrenteidbanco.AsInteger;
  Sistema.Financeiro.ContaCorrente.Numero := mdContaCorrentenumero.AsString;
  Sistema.Financeiro.ContaCorrente.Saldo := mdContaCorrentesaldo.AsCurrency;
  Sistema.Financeiro.ContaCorrente.Padrao := mdContaCorrentepadrao.AsBoolean;
  ModalResult := Sistema.Financeiro.ContaCorrente.Post;
end;

procedure TfrmCadContaCorrente.acNovoExecute(Sender: TObject);
begin
  inherited;
  mdContaCorrenteabertura.AsDateTime := Date;
end;

procedure TfrmCadContaCorrente.Edit(AID: Integer);
begin
  Sistema.Financeiro.ContaCorrente.Get(AID);
  mdContaCorrente.CloseOpen;
  mdContaCorrente.Edit;
  mdContaCorrenteid.AsInteger := Sistema.Financeiro.ContaCorrente.ID;
  mdContaCorrenteidbanco.AsInteger := Sistema.Financeiro.ContaCorrente.Banco.ID;
  mdContaCorrenteabertura.AsDateTime := Sistema.Financeiro.ContaCorrente.Abertura;
  mdContaCorrentenumero.AsString := Sistema.Financeiro.ContaCorrente.Numero;
  mdContaCorrentesaldo.AsCurrency := Sistema.Financeiro.ContaCorrente.Saldo;
  mdContaCorrentepadrao.AsBoolean := Sistema.Financeiro.ContaCorrente.Padrao;
end;

end.

