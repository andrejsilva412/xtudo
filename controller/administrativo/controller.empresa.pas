unit controller.empresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.pessoa;

type

  { TEmpresa }

  TEmpresa = class(TPessoa)
  private
    FSite: String;
    procedure SetSite(AValue: String);
    protected
      procedure Valida; override;
    public
      function Post: Integer; override;
      function Get: Boolean;
      property Site: String read FSite write SetSite;
  end;

implementation

uses uconst, model.empresa;

{ TEmpresa }

procedure TEmpresa.SetSite(AValue: String);
begin
  if FSite = AValue then Exit;
  FSite := LowerCase(AValue);
end;

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

