unit view.contacorrente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, uframetitulo, rxmemds, view.dbgrid,
  DB;

type

  { TfrmContaCorrente }

  TfrmContaCorrente = class(TfrmDBGrid)
    mdContaCorrente: TRxMemoryData;
    mdContaCorrenteabertura: TDateField;
    mdContaCorrentebanco: TStringField;
    mdContaCorrenteid: TLongintField;
    mdContaCorrentenumero: TStringField;
    mdContaCorrentesaldo: TCurrencyField;
    procedure acNovoExecute(Sender: TObject);
  private

  protected
    procedure LoadPage; override;
    procedure Edit; override;
  public

  end;

var
  frmContaCorrente: TfrmContaCorrente;

implementation

{$R *.lfm}

{ TfrmContaCorrente }

procedure TfrmContaCorrente.acNovoExecute(Sender: TObject);
begin
  if Sistema.Forms.Financeiro.ContaCorrente(0) = mrOK then
    LoadPage;
end;

procedure TfrmContaCorrente.LoadPage;
var
  i, APage: Integer;
begin

  APage := GetPage;
  mdContaCorrente.CloseOpen;
  with Sistema.Financeiro do
  begin
    ContaCorrente.OnProgress := @ProgressBar;
    ContaCorrente.GetPage(APage);
    MaxPage := ContaCorrente.Data.MaxPage;
    for i := 0 to ContaCorrente.Data.Count -1 do
    begin
      ProgressBar(i+1, ContaCorrente.Data.Count);
      mdContaCorrente.Insert;
      mdContaCorrenteid.AsInteger := ContaCorrente.Data.Items[i].This.ID;
      mdContaCorrenteabertura.AsDateTime := ContaCorrente.Data.Items[i].This.Abertura;
      mdContaCorrentebanco.AsString := ContaCorrente.Data.Items[i].This.Banco.Nome;
      mdContaCorrentenumero.AsString := ContaCorrente.Data.Items[i].This.Numero;
      mdContaCorrentesaldo.AsCurrency := ContaCorrente.Data.Items[i].This.Saldo;
      mdContaCorrente.Post;
    end;
    inherited;
  end;
end;

procedure TfrmContaCorrente.Edit;
begin
  if Sistema.Forms.Financeiro.ContaCorrente(
    dsDBGrid.DataSet.FieldByName('id').AsInteger) = mrOK then
    inherited;
end;

end.

