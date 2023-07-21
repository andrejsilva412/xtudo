unit uvalida;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ACBrValidador;

type

  { TValidador }

  TValidador = class
    private
      FValidador: TACBrValidador;
    public
      constructor Create;
      destructor Destroy; override;
      function CNPJ(AString: String): Boolean;
  end;

implementation

{ TValidador }

constructor TValidador.Create;
begin
  FValidador: TACBrValidador.Create(nil);
end;

destructor TValidador.Destroy;
begin
  FreeAndNil(FValidador);
  inherited Destroy;
end;

function TValidador.CNPJ(AString: String): Boolean;
begin
  FValida.TipoDocto := docCNPJ;
  FValida.Documento := Documento;
  Result := FValidador.Validar;
end;

end.

