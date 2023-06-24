unit utypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLType, uconst;


type

  TSVGImages = (svgNone, svgClose);


function SVGImagesToString(ASVGImage: TSVGImages): String;


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

end.

