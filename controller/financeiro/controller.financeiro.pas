unit controller.financeiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.banco, controller.contacorrente, controller.movfinanceiro;

type

  { TFinanceiro }

  TFinanceiro = class
    private
      FBanco: TBanco;
      FContaCorrente: TContaCorrente;
      FMovFinanceiro: TMovFinanceiro;
    public
      destructor Destroy; override;
      function Banco: TBanco;
      function ContaCorrente: TContaCorrente;
      function Movimento: TMovFinanceiro;
  end;

implementation

{ TFinanceiro }

destructor TFinanceiro.Destroy;
begin
  if Assigned(FBanco) then
    FreeAndNil(FBanco);
  if Assigned(FContaCorrente) then
    FreeAndNil(FContaCorrente);
  if Assigned(FMovFinanceiro) then
    FreeAndNil(FMovFinanceiro);
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

function TFinanceiro.Movimento: TMovFinanceiro;
begin
  if not Assigned(FMovFinanceiro) then
    FMovFinanceiro := TMovFinanceiro.Create;
  Result := FMovFinanceiro;
end;

end.

