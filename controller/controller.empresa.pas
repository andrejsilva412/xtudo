unit controller.empresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.pessoa;

type

  { TEmpresa }

  TEmpresa = class(TPessoa)
    protected
      procedure Valida; override;
    public
      function Post: Integer; override;
      procedure Get;
  end;

implementation

uses uconst, model.empresa;

{ TEmpresa }

procedure TEmpresa.Valida;
begin
  if Nome = '' then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Razão Social']));
  if Fantasia = '' then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Nome Fantasia']));
end;

function TEmpresa.Post: Integer;
var
  MEmpresa: TModelEmpresa;
begin

  MEmpresa := TModelEmpresa.Create;
  try
    Result := MEmpresa.Post(Self);
  finally
    FreeAndNil(MEmpresa);
  end;

end;

procedure TEmpresa.Get;
var
  MEmpresa: TModelEmpresa;
begin

  MEmpresa := TModelEmpresa.Create;
  try
    MEmpresa.Get(Self);
  finally
    FreeAndNil(MEmpresa);
  end;

end;

end.

