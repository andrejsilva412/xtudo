unit controller.endereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, udbnotifier;

type

  { TPais }

  TPais = class
    private
      FID: Integer;
      FNome: String;
    public
      constructor Create;
      procedure Clear;
      property ID: Integer read FID;
      property Nome: String read FNome;
  end;

type

  { TUF }

  TUF = class
    private
      FEstado: String;
      FIBGE: String;
      FPais: TPais;
      FSigla: String;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      property IBGE: String read FIBGE write FIBGE;
      property Estado: String read FEstado write FEstado;
      property Sigla: String read FSigla write FSigla;
      property Pais: TPais read FPais;
  end;

type

  { TCidade }

  TCidade = class
    private
      FIBGE: String;
      FNome: String;
      FUF: TUF;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      property Nome: String read FNome write FNome;
      property IBGE: String read FIBGE write FIBGE;
      property UF: TUF read FUF;
  end;

type

  { TEndereco }

  TEndereco = class(TDBNotifier)
    private
      FBairro: String;
      FCEP: String;
      FCidade: TCidade;
      FComplemento: String;
      FLogradouro: String;
      FNumero: String;
      procedure SetCEP(AValue: String);
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      function BuscaCEP(ACEP: String): Boolean;
      property CEP: String read FCEP write SetCEP;
      property Logradouro: String read FLogradouro write FLogradouro;
      property Complemento: String read FComplemento write FComplemento;
      property Numero: String read FNumero write FNumero;
      property Bairro: String read FBairro write FBairro;
      property Cidade: TCidade read FCidade;
  end;

implementation

uses model.endereco, uformats;

constructor TPais.Create;
begin
  Clear;
end;

procedure TPais.Clear;
begin
  FID := 1058;
  FNome := 'BRASIL';
end;

{ TUF }

constructor TUF.Create;
begin
  FPais := TPais.Create;
end;

destructor TUF.Destroy;
begin
  FreeAndNil(FPais);
  inherited Destroy;
end;

procedure TUF.Clear;
begin
  FIBGE := '';
  FEstado := '';
  FSigla := '';
  FPais.Clear;
end;

{ TCidade }

constructor TCidade.Create;
begin
  FUF := TUF.Create;
end;

destructor TCidade.Destroy;
begin
  FreeAndNil(FUF);
  inherited Destroy;
end;

procedure TCidade.Clear;
begin
  FNome := '';
  FIBGE := '';
  FUF.Clear;
end;

procedure TEndereco.SetCEP(AValue: String);
begin
  if FCEP = AValue then Exit;
  FCEP := FormataCEP(AValue);
end;

constructor TEndereco.Create;
begin
  FCidade := TCidade.Create;
end;

destructor TEndereco.Destroy;
begin
  FreeAndNil(FCidade);
  inherited Destroy;
end;

procedure TEndereco.Clear;
begin
  FCEP := '';
  FLogradouro := '';
  FComplemento := '';
  FNumero := '';
  FBairro := '';
  FCidade.Clear;
end;

function TEndereco.BuscaCEP(ACEP: String): Boolean;
var
  MEnd: TModelEndereco;
begin

  MEnd := TModelEndereco.Create;
  try
    MEnd.OnStatus := @DoStatus;
    Result := MEnd.BuscaCEP(ACEP, Self);
  finally
    FreeAndNil(MEnd);
  end;

end;

end.

