unit controller.crud;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, DB, uvalida, udbnotifier;

type

  { TCRUD }

  TCRUD = class(TDBNotifier)
    private
      FValidador: TValidador;
    protected
      function Validador: TValidador;
      procedure Valida; virtual;
    public
      destructor Destroy; override;
      procedure Clear; virtual;
      function Delete: Integer; virtual;
      function Post: Integer; virtual;
      procedure GetPage(APage: Integer = 1); virtual;
  end;

implementation

{ TCRUD }

function TCRUD.Validador: TValidador;
begin
  if not Assigned(FValidador) then
    FValidador := TValidador.Create;
  Result := FValidador;
end;

procedure TCRUD.Valida;
begin

end;

destructor TCRUD.Destroy;
begin
  if Assigned(FValidador) then
    FreeAndNil(FValidador);
  inherited Destroy;
end;

procedure TCRUD.Clear;
begin

end;

function TCRUD.Delete: Integer;
begin
  Result := 0;
end;

function TCRUD.Post: Integer;
begin
  Valida;
  Result := mrOK;
end;

procedure TCRUD.GetPage(APage: Integer);
begin

end;

end.

