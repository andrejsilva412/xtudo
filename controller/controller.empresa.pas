unit controller.empresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, db, controller.pessoajuridica;

type

  { TEmpresa }

  TEmpresa = class(TPessoaJuridica)
    protected
      procedure Valida; override;
    public
      function Post: Integer; override;
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

function TEmpresa.Post: Integer;
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

