unit model.cidade;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, model.uf;

type

  { TModelCidade }

  TModelCidade = class
    private
      FIBGE: Integer;
      FNome: String;
      FUF: TModelUF;
    public
      constructor Create;
      destructor Destroy; override;
      property IBGE: Integer read FIBGE write FIBGE;
      property Nome: String read FNome write FNome;
      property UF: TModelUF read FUF;
  end;

implementation

{ TModelCidade }

constructor TModelCidade.Create;
begin
  FUF := TModelUF.Create;
end;

destructor TModelCidade.Destroy;
begin
  FreeAndNil(FUF);
  inherited Destroy;
end;

end.

