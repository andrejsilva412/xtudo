unit controller.base;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uvalida, udbstatus;

type

  { TControllerBase }

  TControllerBase = class(TDBStatus)
    private
      FValidador: TValidador;
    protected
      function Validador: TValidador;
      procedure Valida; virtual;
    public
      destructor Destroy; override;
      function Delete: Integer; virtual;
      function Post: Integer; virtual;
      procedure Get(APage: Integer = 1); virtual;
  end;

implementation

{ TControllerBase }

function TControllerBase.Validador: TValidador;
begin
  if not Assigned(FValidador) then
    FValidador := TValidador.Create;
  Result := FValidador;
end;

procedure TControllerBase.Valida;
begin

end;

destructor TControllerBase.Destroy;
begin
  if Assigned(FValidador) then
    FreeAndNil(FValidador);
  inherited Destroy;
end;

function TControllerBase.Delete: Integer;
begin

end;

function TControllerBase.Post: Integer;
begin
  Valida;
end;

procedure TControllerBase.Get(APage: Integer);
begin

end;

end.

