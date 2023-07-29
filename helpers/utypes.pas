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

// Tipo de Pessoa

type

  TTipoContato = (tcEmpresa);

function SVGImagesToString(ASVGImage: TSVGImages): String;
function UserTypeToInteger(AUserType: TUserType): Integer;
function IntegerToUserType(AUserType: Integer): TUserType;
function TipoContatoToInteger(ATipoContato: TTipoContato): Integer;
function IntegerToTipoContato(ATipoContato: Integer): TTipoContato;

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

function TipoContatoToInteger(ATipoContato: TTipoContato): Integer;
begin
  Result := Ord(ATipoContato);
end;

function IntegerToTipoContato(ATipoContato: Integer): TTipoContato;
begin
  Result := TTipoContato(ATipoContato);
end;

end.

