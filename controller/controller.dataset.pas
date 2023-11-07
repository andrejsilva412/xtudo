unit controller.dataset;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, uvalida, udbnotifier;

type

  { TPeriodo }

  TPeriodo = class
    private
      FFim: TDateTime;
      FInicio: TDateTime;
    public
      constructor Create;
      property Inicio: TDateTime read FInicio write FInicio;
      property Fim: TDateTime read FFim write FFim;
  end;

type

  { TControllerDataSet }

  TControllerDataSet = class(TDBNotifier)
    private
      FPeriodo: TPeriodo;
      FValidador: TValidador;
    protected
      function Validador: TValidador;
      procedure Valida; virtual;
    public
      constructor Create;
      destructor Destroy; override;
      function Delete: Integer; virtual;
      function Post: Integer; virtual;
      procedure GetPage(APage: Integer = 1); virtual;
      property Periodo: TPeriodo read FPeriodo;
  end;

implementation

{ TPeriodo }

constructor TPeriodo.Create;
begin
  FInicio := Date;
  FFim := Date;
end;

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

constructor TControllerDataSet.Create;
begin
  FPeriodo := TPeriodo.Create;
end;

destructor TControllerDataSet.Destroy;
begin
  FreeAndNil(FPeriodo);
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

