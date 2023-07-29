unit controller.crud;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uvalida, udbnotifier;

type

  { TControllerCRUD }

  TControllerCRUD = class(TDBNotifier)
    private
      FValidador: TValidador;
    protected
      function Validador: TValidador;
      procedure Valida; virtual;
    public
      destructor Destroy; override;
      function Delete: Integer; virtual;
      function Post: Integer; virtual;
      procedure GetPage(APage: Integer = 1); virtual;
  end;

implementation

{ TControllerCRUD }

function TControllerCRUD.Validador: TValidador;
begin
  if not Assigned(FValidador) then
    FValidador := TValidador.Create;
  Result := FValidador;
end;

procedure TControllerCRUD.Valida;
begin

end;

destructor TControllerCRUD.Destroy;
begin
  if Assigned(FValidador) then
    FreeAndNil(FValidador);
  inherited Destroy;
end;

function TControllerCRUD.Delete: Integer;
begin

end;

function TControllerCRUD.Post: Integer;
begin
  Valida;
end;

procedure TControllerCRUD.GetPage(APage: Integer);
begin

end;

end.

