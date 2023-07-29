unit uformats;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function FormataCEP(ACEP: String): String;

implementation

uses ustrutils;

function FormataCEP(ACEP: String): String;
begin
  Result := '';
  ACEP := RemoveChar(ACEP);
  if Length(ACEP) = 8 then
    Result := Copy(ACEP, 1, 5) + '-' + Copy(ACEP, 6, 8);
end;

end.

