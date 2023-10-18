unit view.cadmovfinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  rxdbcurredit, rxmemds, rxdbcomb, view.bascadastro, DB;

type

  { TfrmCadMovFinanceiro }

  TfrmCadMovFinanceiro = class(TfrmBasCadastro)
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    mdMovimento: TRxMemoryData;
    mdMovimentohistorico: TStringField;
    mdMovimentotipo: TLongintField;
    mdMovimentovalor: TCurrencyField;
    RxDBComboBox1: TRxDBComboBox;
    RxDBCurrEdit1: TRxDBCurrEdit;
  private

  public

  end;

var
  frmCadMovFinanceiro: TfrmCadMovFinanceiro;

implementation

{$R *.lfm}

end.

