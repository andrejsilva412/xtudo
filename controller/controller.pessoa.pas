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
      FEmail: String;
      FEndereco: TEndereco;
      FID: Integer;
      FInscricaoEstadual: String;
      FNome: String;
      FNomeFantasia: String;
      FTelefone: String;
      FWhatsapp: String;
      procedure SetCNPJ(AValue: String);
      procedure SetEmail(AValue: String);
      procedure SetTelefone(AValue: String);
      procedure SetWhatsapp(AValue: String);
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
      property CNPJ: String read FCNPJ write SetCNPJ;
      property InscricaoEstadual: String read FInscricaoEstadual write FInscricaoEstadual;
      property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
      property Telefone: String read FTelefone write SetTelefone;
      property Whatsapp: String read FWhatsapp write SetWhatsapp;
      property Email: String read FEmail write SetEmail;
  end;

implementation

uses uformats;

{ TContato }

function TContato.Add: TContatoItem;
begin
  Result := inherited Add as TContatoItem;
end;

{ TPessoa }

procedure TPessoa.SetCNPJ(AValue: String);
begin
  if FCNPJ = AValue then Exit;
  FCNPJ := FormataCNPJCPF(AValue);
end;

procedure TPessoa.SetEmail(AValue: String);
begin
  if FEmail = AValue then Exit;
  FEmail := LowerCase(AValue);
end;

procedure TPessoa.SetTelefone(AValue: String);
begin
  if FTelefone = AValue then Exit;
  FTelefone := FormataTelefone(AValue);
end;

procedure TPessoa.SetWhatsapp(AValue: String);
begin
  if FWhatsapp = AValue then Exit;
  FWhatsapp := FormataTelefone(AValue);
end;

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

