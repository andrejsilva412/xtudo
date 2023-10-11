unit controller.pessoa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.endereco, controller.dataset,
  udatacollection;

type

  { TContatoItem }

  TContatoItem = class(TCollectionItem)
    private
      FContato: String;
      FGUID: String;
      FTipo: String;
    public
      property GUID: String read FGUID write FGUID;
      property Tipo: String read FTipo write FTipo;
      property Contato: String read FContato write FContato;
  end;

  TContato = class(specialize TDataCollecion<TContatoItem>)
    public
      function Add: TContatoItem;
  end;
type

  { TPessoa }

  TPessoa = class(TControllerDataSet)
    private
      FCNPJ: String;
      FContato: TContato;
      FEndereco: TEndereco;
      FID: Integer;
      FInscricaoEstadual: String;
      FNome: String;
      FNomeFantasia: String;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear; virtual;
      function Delete: Integer; override;
      function Post: Integer; override;
      property ID: Integer read FID write FID;
      property Nome: String read FNome write FNome;
      property Endereco: TEndereco read FEndereco;
      property Contato: TContato read FContato;
      property CNPJ: String read FCNPJ write FCNPJ;
      property InscricaoEstadual: String read FInscricaoEstadual write FInscricaoEstadual;
      property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
  end;

implementation

{ TContato }

function TContato.Add: TContatoItem;
begin
  Result := inherited Add as TContatoItem;
end;

{ TPessoa }

constructor TPessoa.Create;
begin
  FEndereco := TEndereco.Create;
  FContato := TContato.Create;
end;

destructor TPessoa.Destroy;
begin
  FreeAndNil(FEndereco);
  FreeAndNil(FContato);
  inherited Destroy;
end;

procedure TPessoa.Clear;
begin

  FID := 0;
  FNome := '';
  FEndereco.Clear;
  FContato.Clear;
  FCNPJ := '';
  FInscricaoEstadual := '';
  FNomeFantasia := '';

end;

function TPessoa.Delete: Integer;
begin
  Result := inherited Delete;
end;

function TPessoa.Post: Integer;
begin
  Result := inherited Post;
end;

end.

