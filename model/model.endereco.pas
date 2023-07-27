unit model.endereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, udatacollection, model.cidade;

type

  TModelEndereco = class;

type

  { Endereco }

  Endereco = class(TCollectionItem)
    private
      FEntitie: TModelEndereco;
    public
      constructor Create(ACollection: TCollection); override;
      destructor Destroy; override;
      function This: TModelEndereco;
  end;

type

  { TData }

  TData = class(specialize TDataCollecion<Endereco>)
    public
      function Add: Endereco;
  end;

type

  { TModelEndereco }

  TModelEndereco = class
    private
      FBairro: String;
      FCEP: String;
      FCidade: TModelCidade;
      FComplemento: String;
      FData: TData;
      FLogradouro: String;
      FNumero: String;
      procedure SetCEP(AValue: String);
    public
      constructor Create;
      destructor Destroy; override;
      procedure Get(ACEP: String);
      property Logradouro: String read FLogradouro write FLogradouro;
      property Complemento: String read FComplemento write FComplemento;
      property Numero: String read FNumero write FNumero;
      property Bairro: String read FBairro write FBairro;
      property Cidade: TModelCidade read FCidade write FCidade;
      property CEP: String read FCEP write SetCEP;
      property Data: TData read FData;
  end;

implementation

{ TModelEndereco }

procedure TModelEndereco.SetCEP(AValue: String);
begin
  if FCEP = AValue then Exit;
  FCEP := AValue;
end;

constructor TModelEndereco.Create;
begin
  FCidade := TModelCidade.Create;
  FData := TData.Create;
end;

destructor TModelEndereco.Destroy;
begin
  FreeAndNil(FCidade);
  FreeAndNil(FData);
  inherited Destroy;
end;

{ Endereco }

constructor Endereco.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FEntitie := TModelEndereco.Create;
end;

destructor Endereco.Destroy;
begin
  FreeAndNil(FEntitie);
  inherited Destroy;
end;

function Endereco.This: TModelEndereco;
begin
  Result := FEntitie;
end;

{ TData }

function TData.Add: Endereco;
begin
  Result := inherited Add as Endereco;
end;

end.

