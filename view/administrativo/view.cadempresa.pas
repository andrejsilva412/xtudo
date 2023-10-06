unit view.cadempresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  rxmemds, view.bascadastro, DB;

type

  { TfrmCadEmpresa }

  TfrmCadEmpresa = class(TfrmBasCadastro)
    DBEdit1: TDBEdit;
    Label1: TLabel;
    mdEmpresa: TRxMemoryData;
    mdEmpresaid: TLongintField;
    mdEmpresarazaosocial: TStringField;
    procedure acSalvarExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmCadEmpresa: TfrmCadEmpresa;

implementation

{$R *.lfm}

{ TfrmCadEmpresa }

procedure TfrmCadEmpresa.acSalvarExecute(Sender: TObject);
begin
  inherited;
  Sistema.Administrativo.Empresa.ID := mdEmpresaid.AsInteger;
  Sistema.Administrativo.Empresa.Nome := mdEmpresarazaosocial.AsString;
  if Sistema.Administrativo.Empresa.Post = mrOK then
    Close;
end;

procedure TfrmCadEmpresa.FormShow(Sender: TObject);
begin
  inherited;
  Sistema.Administrativo.Empresa.Get;
  mdEmpresa.CloseOpen;
  mdEmpresa.Edit;
  mdEmpresaid.AsInteger := Sistema.Administrativo.Empresa.ID;
  mdEmpresarazaosocial.AsString := Sistema.Administrativo.Empresa.Nome;
end;

end.

