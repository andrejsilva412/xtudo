unit view.cadbanco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  rxmemds, view.bascadastro, DB;

type

  { TfrmCadBanco }

  TfrmCadBanco = class(TfrmBasCadastro)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    mdBanco: TRxMemoryData;
    mdBancocodigo: TStringField;
    mdBancoid: TLongintField;
    mdBanconome: TStringField;
    procedure acSalvarExecute(Sender: TObject);
  private

  public
    procedure Edit(AID: Integer); override;
  end;

var
  frmCadBanco: TfrmCadBanco;

implementation

{$R *.lfm}

{ TfrmCadBanco }

procedure TfrmCadBanco.acSalvarExecute(Sender: TObject);
begin

  inherited;
  Sistema.Financeiro.Banco.ID := mdBancoid.AsInteger;
  Sistema.Financeiro.Banco.Codigo := mdBancocodigo.AsString;
  Sistema.Financeiro.Banco.Nome := mdBanconome.AsString;
  ModalResult := Sistema.Financeiro.Banco.Post;

end;

procedure TfrmCadBanco.Edit(AID: Integer);
begin
  Sistema.Financeiro.Banco.Get(AID);
  mdBanco.CloseOpen;
  mdBanco.Edit;
  mdBancoid.AsInteger := Sistema.Financeiro.Banco.ID;
  mdBancocodigo.AsString := Sistema.Financeiro.Banco.Codigo;
  mdBanconome.AsString := Sistema.Financeiro.Banco.Nome;
end;

end.

