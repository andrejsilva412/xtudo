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
      function MinPasswordLength(APassword: String): Boolean;
  end;

implementation

uses uconst;

{ TValidador }

constructor TValidador.Create;
begin
  FValidador := TACBrValidador.Create(nil);
end;

destructor TValidador.Destroy;
begin
  FreeAndNil(FValidador);
  inherited Destroy;
end;

function TValidador.CNPJ(AString: String): Boolean;
begin
  FValidador.TipoDocto := docCNPJ;
  FValidador.Documento := AString;
  Result := FValidador.Validar;
end;

function TValidador.MinPasswordLength(APassword: String): Boolean;
begin
  Result := Length(APassword) >= StrToInt(C_MIN_PASSWORD_LENGHT);
end;

end.

