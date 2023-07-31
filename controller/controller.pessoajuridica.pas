unit controller.pessoajuridica;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.pessoa;

type

  { TPessoaJuridica }

  TPessoaJuridica = class(TPessoa)
    private
      FCNPJ: String;
      FInscricaoEstadual: String;
      FNomeFantasia: String;
    public
      procedure Clear; override;
      property CNPJ: String read FCNPJ write FCNPJ;
      property InscricaoEstadual: String read FInscricaoEstadual write FInscricaoEstadual;
      property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
  end;

implementation

{ TPessoaJuridica }

procedure TPessoaJuridica.Clear;
begin
  inherited Clear;
  FCNPJ := '';
  FInscricaoEstadual := '';
  FNomeFantasia := '';
end;

end.

