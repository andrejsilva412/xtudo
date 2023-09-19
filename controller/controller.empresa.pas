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
      function Post: Boolean; override;
      function Get: Boolean;
  end;

implementation

uses uconst, model.empresa;

{ TEmpresa }

procedure TEmpresa.Valida;
begin
  if Nome = '' then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Razão Social']));
  if NomeFantasia = '' then
    raise Exception.Create(Format(SMSGCampoObrigatorio, ['Nome Fantasia']));
end;

function TEmpresa.Post: Boolean;
var
  MEmpresa: TModelEmpresa;
begin

  MEmpresa := TModelEmpresa.Create;
  try
    inherited Post;
    Result := MEmpresa.Post(Self);
  finally
    FreeAndNil(MEmpresa);
  end;

end;

function TEmpresa.Get: Boolean;
var
  MEmpresa: TModelEmpresa;
begin

  MEmpresa := TModelEmpresa.Create;
  try
    Result := MEmpresa.Get(Self);
  finally
    FreeAndNil(MEmpresa);
  end;

end;

end.

