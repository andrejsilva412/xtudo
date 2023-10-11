unit controller.financeiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.banco;

type

  { TFinanceiro }

  TFinanceiro = class
    private
      FBanco: TBanco;
    public
      destructor Destroy; override;
      function Banco: TBanco;
  end;

implementation

{ TFinanceiro }

destructor TFinanceiro.Destroy;
begin
  if Assigned(FBanco) then
    FreeAndNil(FBanco);
  inherited Destroy;
end;

function TFinanceiro.Banco: TBanco;
begin

  if not Assigned(FBanco) then
    FBanco := TBanco.Create;
  Result := FBanco;

end;

end.

