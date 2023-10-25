unit utypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLType, uconst;

// Imagens
type

  TSVGImages = (svgNone, svgClose);

// Tipo de Usuário
type

  TUserType = (utNormal, utAdmin);

type
  TView = (vEmpresa, vUsuario, vBanco, vContaCorrente, vMovFinanceiro,
   vCadMovFinanceiroEntrada, vCadMovFinanceiroSaida);

function SVGImagesToString(ASVGImage: TSVGImages): String;
function UserTypeToInteger(AUserType: TUserType): Integer;
function IntegerToUserType(AUserType: Integer): TUserType;

implementation

function SVGImagesToString(ASVGImage: TSVGImages): String;
var
  RS: TResourceStream;
  SS: TStringStream;
  sResource: String;
begin

  if ASVGImage = svgNone then
  begin
    Result := '';
    exit;
  end;

  case ASVGImage of
    svgClose: sResource := C_SVG_CLOSE;
  end;

  SS := TStringStream.Create('');
  RS := TResourceStream.Create(HINSTANCE, sResource, RT_RCDATA);
  try
    RS.Position := 0;
    SS.CopyFrom(RS, RS.Size);
    Result := SS.DataString;
  finally
    FreeAndNil(SS);
    FreeAndNil(RS);
  end;

end;

function UserTypeToInteger(AUserType: TUserType): Integer;
begin
  Result := Ord(AUserType);
end;

function IntegerToUserType(AUserType: Integer): TUserType;
begin
  Result := TUserType(AUserType);
end;

end.

