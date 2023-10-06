unit controller.dataset;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, uvalida, udbnotifier;

type

  { TControllerDataSet }

  TControllerDataSet = class(TDBNotifier)
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

{ TControllerDataSet }

function TControllerDataSet.Validador: TValidador;
begin
  if not Assigned(FValidador) then
    FValidador := TValidador.Create;
  Result := FValidador;
end;

procedure TControllerDataSet.Valida;
begin

end;

destructor TControllerDataSet.Destroy;
begin
  if Assigned(FValidador) then
    FreeAndNil(FValidador);
  inherited Destroy;
end;

function TControllerDataSet.Delete: Integer;
begin
  Result := mrOK;
end;

function TControllerDataSet.Post: Integer;
begin
  Valida;
  Result := mrOK;
end;

procedure TControllerDataSet.GetPage(APage: Integer);
begin

end;

end.

