unit controller.crud;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, DB, uvalida, udbnotifier;

type

  { TCRUD }

  TCRUD = class(TDBNotifier)
    private
      FResponce: String;
      FValidador: TValidador;
    protected
      function Validador: TValidador;
      procedure Valida; virtual;
    public
      destructor Destroy; override;
      procedure Clear; virtual;
      function Delete: Boolean; virtual;
      function Post: Boolean; virtual;
      procedure GetPage(APage: Integer = 1); virtual;
      property Responce: String read FResponce write FResponce;
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

function TCRUD.Delete: Boolean;
begin
  Result := false;
end;

function TCRUD.Post: Boolean;
begin
  Valida;
  Result := false;
end;

procedure TCRUD.GetPage(APage: Integer);
begin

end;

end.

