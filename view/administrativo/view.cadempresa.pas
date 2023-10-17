unit view.cadempresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  rxmemds, view.bascadastro, DB, uframecnpj, uframeendereco;

type

  { TfrmCadEmpresa }

  TfrmCadEmpresa = class(TfrmBasCadastro)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    frameCNPJ1: TframeCNPJ;
    FrameEndereco1: TFrameEndereco;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    mdEmpresa: TRxMemoryData;
    mdEmpresabairro: TStringField;
    mdEmpresacep: TStringField;
    mdEmpresacidade: TStringField;
    mdEmpresacnpj: TStringField;
    mdEmpresacomplemento: TStringField;
    mdEmpresaemail: TStringField;
    mdEmpresaendereco: TStringField;
    mdEmpresafantasia: TStringField;
    mdEmpresaid: TLongintField;
    mdEmpresainscricaoestadual: TStringField;
    mdEmpresanumero: TStringField;
    mdEmpresarazaosocial: TStringField;
    mdEmpresasite: TStringField;
    mdEmpresatelefone: TStringField;
    mdEmpresauf: TStringField;
    mdEmpresawhatsapp: TStringField;
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
  with Sistema.Administrativo.Empresa do
  begin
    ID := mdEmpresaid.AsInteger;
    Nome := mdEmpresarazaosocial.AsString;
    NomeFantasia := mdEmpresafantasia.AsString;
    CNPJ := mdEmpresacnpj.AsString;
    InscricaoEstadual := mdEmpresainscricaoestadual.AsString;
    Endereco.CEP := mdEmpresacep.AsString;
    Endereco.Logradouro := mdEmpresaendereco.AsString;
    Endereco.Numero := mdEmpresanumero.AsString;
    Endereco.Complemento := mdEmpresacomplemento.AsString;
    Endereco.Bairro := mdEmpresabairro.AsString;
    Endereco.Cidade.Nome := mdEmpresacidade.AsString;
    Endereco.Cidade.UF.Sigla := mdEmpresauf.AsString;
    Telefone := mdEmpresatelefone.AsString;
    Whatsapp := mdEmpresawhatsapp.AsString;
    Site := mdEmpresasite.AsString;
    Email := mdEmpresaemail.AsString;
  end;
  if Sistema.Administrativo.Empresa.Post = mrOK then
    Close;
end;

procedure TfrmCadEmpresa.FormShow(Sender: TObject);
begin
  inherited;
  Sistema.Administrativo.Empresa.Get;
  mdEmpresa.CloseOpen;
  mdEmpresa.Edit;
  with Sistema.Administrativo.Empresa do
  begin
    mdEmpresaid.AsInteger := ID;
    mdEmpresarazaosocial.AsString := Nome;
    mdEmpresafantasia.AsString := NomeFantasia;
    mdEmpresacnpj.AsString := CNPJ;
    mdEmpresainscricaoestadual.AsString := InscricaoEstadual;
    mdEmpresacep.AsString := Endereco.CEP;
    mdEmpresaendereco.AsString := Endereco.Logradouro;
    mdEmpresanumero.AsString := Endereco.Numero;
    mdEmpresacomplemento.AsString := Endereco.Complemento;
    mdEmpresabairro.AsString := Endereco.Bairro;
    mdEmpresacidade.AsString := Endereco.Cidade.Nome;
    mdEmpresauf.AsString := Endereco.Cidade.UF.Sigla;
    mdEmpresatelefone.AsString := Telefone;
    mdEmpresawhatsapp.AsString := Whatsapp;
    mdEmpresasite.AsString := Site;
    mdEmpresaemail.AsString := Email;
  end;
end;

end.

