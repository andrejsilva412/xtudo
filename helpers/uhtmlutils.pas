unit uhtmlutils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

function HTMLToColor(HTMLColor: String): TColor;
function ColorToHTML(Color: TColor): String;
function StrToHTML(mStr: string; mFont: TFont = nil): string;

implementation

function HTMLToColor(HTMLColor: String): TColor;
var
  R, G, B: Byte;
begin

  // Remove '#' se presente
  if HTMLColor[1] = '#' then
    Delete(HTMLColor, 1, 1);

  // Converte os componentes de cor de hexadecimal para decimal
  R := StrToInt('$' + Copy(HTMLColor, 1, 2));
  G := StrToInt('$' + Copy(HTMLColor, 3, 2));
  B := StrToInt('$' + Copy(HTMLColor, 5, 2));

  // Combina os componentes para obter o TColor
  Result := RGBToColor(R, G, B);

end;

function ColorToHTML(Color: TColor): String;
var
  R, G, B: Byte;
begin

  R := Red(Color);
  G := Green(Color);
  B := Blue(Color);

  // Formata a cor HTML em formado hexadecimal
  Result := Format('#%.2x%.2x%.2x', [R, G, B]);

end;

function StrToHTML(mStr: string; mFont: TFont): string;
var
  vLeft, vRight: string;
begin

  Result := mStr;
  Result := StringReplace(Result, '&', '&AMP;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&LT;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&GT;', [rfReplaceAll]);
  if not Assigned(mFont) then
    Exit;
  vLeft := Format('<FONT FACE="%s" COLOR="%s">',
    [mFont.Name, ColorToHtml(mFont.Color)]);
  vRight := '</FONT>';
  if fsBold in mFont.Style then
  begin
    vLeft := vLeft + '<B>';
    vRight := '</B>' + vRight;
  end;
  if fsItalic in mFont.Style then
  begin
    vLeft := vLeft + '<I>';
    vRight := '</I>' + vRight;
  end;
  if fsUnderline in mFont.Style then
  begin
    vLeft := vLeft + '<U>';
    vRight := '</U>' + vRight;
  end;
  if fsStrikeOut in mFont.Style then
  begin
    vLeft := vLeft + '<S>';
    vRight := '</S>' + vRight;
  end;
  Result := vLeft + Result + vRight;

end;

end.

