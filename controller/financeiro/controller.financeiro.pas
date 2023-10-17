unit controller.financeiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.banco, controller.contacorrente;

type

  { TFinanceiro }

  TFinanceiro = class
    private
      FBanco: TBanco;
      FContaCorrente: TContaCorrente;
    public
      destructor Destroy; override;
      function Banco: TBanco;
      function ContaCorrente: TContaCorrente;
  end;

implementation

{ TFinanceiro }

destructor TFinanceiro.Destroy;
begin
  if Assigned(FBanco) then
    FreeAndNil(FBanco);
  if Assigned(FContaCorrente) then
    FreeAndNil(FContaCorrente);
  inherited Destroy;
end;

function TFinanceiro.Banco: TBanco;
begin

  if not Assigned(FBanco) then
    FBanco := TBanco.Create;
  Result := FBanco;

end;

function TFinanceiro.ContaCorrente: TContaCorrente;
begin
  if not Assigned(FContaCorrente) then
    FContaCorrente := TContaCorrente.Create;
  Result := FContaCorrente;
end;

end.

